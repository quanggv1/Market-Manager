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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailProductRightBarButton;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productNameTextField.text = _product.name;
    _productPriceTextField.text = [NSString stringWithFormat:@"%.2f", _product.price];
    _descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)onProductDetailSave:(id)sender {
    
}

- (IBAction)onRightBarButtonClicked:(id)sender {
    if ([_detailProductRightBarButton.title isEqualToString:@"Edit"]) {
        [_detailProductRightBarButton setTitle:@"Cancel"];
    } else {
        [_detailProductRightBarButton setTitle:@"Edit"];
    }
}


@end
