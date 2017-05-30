//
//  ProductDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "Data.h"

@interface ProductDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productPriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation ProductDetailViewController {
    UIBarButtonItem *rightBarButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_product) {
        [self fillData];
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonClicked)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        [self setEditing:NO];
    } else {
        [self setEditing:YES];
    }
}

- (void)fillData
{
    _productNameTextField.text = _product.name;
    _productPriceTextField.text = [NSString stringWithFormat:@"%.2f", _product.price];
    _descriptionTextView.text = _product.productDesc;
    _descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = _product.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onProductDetailSave:(id)sender
{
    if (![self checkData]) {
        [CallbackAlertView setCallbackTaget:nil
                                    message:@"Please input correct product name & price"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    } else {
        ProductManager *productManager = [ProductManager sharedInstance];
        NSString *productName = [Utils trim:_productNameTextField.text];
        NSInteger productType = [productManager getProductType];
        
        NSString *price = [Utils trim:_productPriceTextField.text];
        NSString *description = _descriptionTextView.text;
        if(_product) {
            if (![_product.name isEqualToString:productName]) {
                if ([self isProductExisted:productName]) return;
            }
            _product.name = productName;
            _product.price = [price floatValue];
            _product.productDesc = description;
            [self updateProduct];
        } else {
            Product *product = [[Product alloc] init];
            if ([self isProductExisted:productName]) return;
            product.name = productName;
            product.price = [price floatValue];
            product.productDesc = description;
            product.type = productType;
            [self addNewProduct:product];
        }
    }
}

- (BOOL)isProductExisted:(NSString *)productName
{
    ProductManager *productManager = [ProductManager sharedInstance];
    if ([productManager exist:productName type:[productManager getProductType]]) {
        [CallbackAlertView setCallbackTaget:nil
                                    message:@"Name of product is existed"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return YES;
    }
    return NO;
}

- (void)addNewProduct:(Product *)product
{
    NSDictionary *params = @{kParams: @{kName: product.name,
                                        kProductPrice: @(product.price),
                                        kProductDesc: product.productDesc,
                                        kType: @(product.type)}};
    Data *data = [Data sharedInstance];
    
    [data get:API_ADD_NEW_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == 200) {
            NSDictionary *data = [res objectForKey:kData];
            product.productId = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
            [[ProductManager sharedInstance] insert:product];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)updateProduct {
    NSDictionary *params = @{kParams: @{kId: _product.productId,
                                        kName: _product.name,
                                        kPrice: @(_product.price),
                                        kDescription: _product.productDesc}};
    [[Data sharedInstance] get:API_UPDATE_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [[ProductManager sharedInstance] update:_product];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)onRightBarButtonClicked {
    if(![Utils hasWritePermission:kProductTableName notify:YES]) return;
    if ([rightBarButton.title isEqualToString:@"Edit"]) {
        [self setEditing:YES];
        [rightBarButton setTitle:@"Cancel"];
    } else {
        [self fillData];
        [rightBarButton setTitle:@"Edit"];
        [self setEditing:NO];
    }
}

- (void)setEditing:(BOOL)editing {
    _productNameTextField.enabled = editing;
    _productPriceTextField.enabled = editing;
    _descriptionTextView.editable = editing;
    _saveButton.hidden = !editing;
}

- (BOOL)checkData {
    if ([[Utils trim:_productPriceTextField.text] isEqualToString:@""] ||
        [[Utils trim:_productNameTextField.text] isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

@end
