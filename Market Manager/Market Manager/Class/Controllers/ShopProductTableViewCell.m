//
//  ShopProductTableViewCell.m
//  Market Manager
//
//  Created by Quang on 3/4/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopProductTableViewCell.h"

@implementation ShopProductTableViewCell {
    Product *_product;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _productSTakeTextField.delegate = self;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setProduct:(Product *)product {
    _product = product;
    _productNameLabel.text = product.name;
    _productPriceLabel.text = [NSString stringWithFormat:@"%.2f $", product.price];
    _productSTakeTextField.text = [NSString stringWithFormat:@"%ld", product.STake];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _product.STake = [_productSTakeTextField.text floatValue];
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    NSIndexPath *indexPath = [((UITableView *)view) indexPathForCell:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShopProductUpdate object:@{@"index": indexPath, @"product": _product}];
}

@end
