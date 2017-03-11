//
//  OrderFormTableViewCell.m
//  Market Manager
//
//  Created by Quang on 3/11/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderFormTableViewCell.h"

@interface OrderFormTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) Product *product;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *stockTakeTF;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@property (weak, nonatomic) IBOutlet UITextField *noteTF;
@end
@implementation OrderFormTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderTF.delegate = self;
    _noteTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(Product *)product {
    _product = product;
    _productNameLabel.text = _product.name;
    _stockTakeTF.text = @(_product.STake).stringValue;
    _orderTF.text = @(_product.order).stringValue;
    _noteTF.text = _product.productDesc;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _product.order = [_orderTF.text integerValue];
    _product.productDesc = _noteTF.text;
    _orderTF.text = @(_product.order).stringValue;
}


@end
