//
//  ProductDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductManager.h"

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

- (void)viewDidLoad {
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

- (void)fillData {
    _productNameTextField.text = _product.name;
    _productPriceTextField.text = [NSString stringWithFormat:@"%.2f", _product.price];
    _descriptionTextView.text = _product.productDesc;
    _descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = _product.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onProductDetailSave:(id)sender {
    if (![self checkData]) {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Please input correct product name & price" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    } else {
        NSString *productName = [_productNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *price = [_productPriceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *description = _descriptionTextView.text;
        if(_product) {
            _product.name = productName;
            _product.price = [price floatValue];
            _product.productDesc = description;
            [self updateProduct];
        } else {
            [self addNewProductWith:productName price:price description:description];
        }
    }
}

- (void)addNewProductWith:(NSString *)productName price:(NSString *)price description:(NSString *)description {
    [self showActivity];
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType]),
                             kParams: @{kProductName: productName,
                                        kProductPrice: price,
                                        kProductDesc: description}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_ADD_NEW_PRODUCT
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == 200) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 NSString *productId = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
                 [self insertNewProduct:productId name:productName price:price description:description];
                 [self.navigationController popViewControllerAnimated:YES];
             } else {
                 [CallbackAlertView setCallbackTaget:@"Error"
                                             message:@"This product is exits"
                                              target:self
                                             okTitle:@"OK"
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (void)insertNewProduct:(NSString *)productId name:(NSString *)productName price:(NSString *)price description:(NSString *)description {
    Product *newProduct = [[Product alloc] initWith:@{kProductID:productId,
                                                      kProductName:productName,
                                                      kProductPrice:price,
                                                      kProductDesc: description}];
    [[ProductManager sharedInstance] insert:newProduct];
}

- (void)updateProduct {
    [self showActivity];
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType]),
                             kParams: @{kProductID: _product.productId,
                                        kProductName: _product.name,
                                        kProductPrice: @(_product.price),
                                        kProductDesc: _product.productDesc}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_PRODUCT
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[ProductManager sharedInstance] update:_product];
                 [self.navigationController popViewControllerAnimated:YES];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             ShowMsgConnectFailed;
    }];
}

- (void)onRightBarButtonClicked {
    if(![Utils hasWritePermission:kProductTableName]) return;
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
    if ([[_productPriceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ||
        [[_productNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}


@end
