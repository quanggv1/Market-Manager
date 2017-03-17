//
//  SummaryTableViewCell.m
//  Market Manager
//
//  Created by Hanhnn1 on 3/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SummaryTableViewCell.h"

@implementation SummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setProduct:(Product *)product {
    _product = product;
    _lbProductName.text = _product.name;
    _lbOrder.text = @(_product.order).stringValue;
    _lbTotal.text = @(_product.reportTotal).stringValue;
    _lbReceived.text = @(_product.reportReceived).stringValue;
    _lbQuantityNeeded.text = @(_product.reportQuantityNeed).stringValue;
    _lbCrateQty.text = @(_product.crateQty).stringValue;
    _lbCrateType.text = @(_product.crateType).stringValue;
}

@end
