//
//  SupplyProductTableViewCell.m
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyProductTableViewCell.h"

@interface SupplyProductTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *stocktakeField;
@property (weak, nonatomic) IBOutlet UITextField *inQuantityField;
@property (weak, nonatomic) IBOutlet UITextField *outQuantityField;
@property (weak, nonatomic) IBOutlet UITextField *totalField;
@property (weak, nonatomic) Product *product;
@end

@implementation SupplyProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _stocktakeField.delegate = self;
    _inQuantityField.delegate = self;
    _outQuantityField.delegate = self;
    _totalField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(Product *)product {
    _product = product;
    _stocktakeField.text = @(_product.STake).stringValue;
    _inQuantityField.text = @(_product.inQty).stringValue;
    _outQuantityField.text = @(_product.outQty).stringValue;
    _totalField.text = @(_product.whTotal).stringValue;
    _productNameLabel.text = _product.name;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _product.inQty = [_inQuantityField.text integerValue];
    _product.outQty = [_outQuantityField.text integerValue];
    _product.whTotal = _product.STake + _product.inQty - _product.outQty;
    _totalField.text = @(_product.whTotal).stringValue;
    _inQuantityField.text = @(_product.inQty).stringValue;
    _outQuantityField.text = @(_product.outQty).stringValue;
}

@end
