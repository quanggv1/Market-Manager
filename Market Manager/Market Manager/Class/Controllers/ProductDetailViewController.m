//
//  ProductDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductDetailViewController.h"

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
        _productNameTextField.text = _product.name;
        _productPriceTextField.text = [NSString stringWithFormat:@"%.2f", _product.price];
        _descriptionTextView.text = _product.productDesc;
        _descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarButtonClicked)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        [self setEditing:NO];
    } else {
        [self setEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onProductDetailSave:(id)sender {
    if (![self checkData]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *productName = [_productNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *price = [_productPriceTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *description = _descriptionTextView.text;
        if(_product) {
            _product.name = productName;
            _product.price = [price floatValue];
            _product.productDesc = description;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyProductUpdateItem object:_product];
        } else {
            NSDictionary *newProductDic = @{@"productName":productName,
                                            @"price":price,
                                            @"description": description};
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyProductAddNewItem object:newProductDic];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onRightBarButtonClicked {
    if ([rightBarButton.title isEqualToString:@"Edit"]) {
        [self setEditing:YES];
        [rightBarButton setTitle:@"Cancel"];
    } else {
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
