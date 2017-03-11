//
//  OrderProductTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderProductTableViewCell.h"
#import "RecommendListViewController.h"

@interface OrderProductTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productOrderLabel;
@property (weak, nonatomic) IBOutlet UITextField *wh1TextField;
@property (weak, nonatomic) IBOutlet UITextField *wh2TextField;
@property (weak, nonatomic) IBOutlet UITextField *whTLTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateQtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateTypeTextField;
@property (weak, nonatomic) Product *product;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id controller;
@end
@implementation OrderProductTableViewCell

- (id)controller {
    if(!_controller) {
        UIView *view = self;
        while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
            view = view.superview;
        }
        _controller = ((UITableView *)view).dataSource;
    }
    return _controller;
}

-(void)setProduct:(Product *)product {
    _product = product;
    _productNameLabel.text = _product.name;
    _productOrderLabel.text = @(_product.order).stringValue;
    _wh1TextField.text = @(_product.wh1).stringValue;
    _wh2TextField.text = @(_product.wh2).stringValue;
    _whTLTextField.text = @(_product.whTL).stringValue;
    _crateQtyTextField.text = @(_product.crateQty).stringValue;
    _crateTypeTextField.text = @(_product.crateType).stringValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _wh1TextField.delegate = self;
    _wh2TextField.delegate = self;
    _whTLTextField.delegate = self;
    _crateQtyTextField.delegate = self;
    _crateTypeTextField.delegate = self;
    [_crateTypeTextField addTarget:self
                              action:@selector(crateTypeTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
}

- (void)crateTypeTextFieldDidChange:(UITextField *)textField {
    [RecommendListViewController updateRecommedListWith:textField.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _crateTypeTextField) {
        [RecommendListViewController showRecommendListAt:self.controller viewSource:textField recommends:@[@"1", @"2", @"3"] onSelected:^(NSString *result) {
            [textField setText:result];
            [Utils hideKeyboard];
        }];
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _product.wh1 = [_wh1TextField.text integerValue];
    _product.wh2 = [_wh2TextField.text integerValue];
    _product.whTL = [_whTLTextField.text integerValue];
    _product.crateQty = [_crateQtyTextField.text integerValue];
    _product.crateType = [_crateTypeTextField.text integerValue];
}


@end
