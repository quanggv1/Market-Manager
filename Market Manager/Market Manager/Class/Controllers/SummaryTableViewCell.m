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
-(void)setProduct:(NSDictionary *)dict {
    _lbProductName.text         = [NSString stringWithFormat:@"%@", [dict objectForKey:kName]];
    _lbOrder.text               = [NSString stringWithFormat:@"%@", [dict objectForKey:kOrderQty]];
    _lbTotal.text               = [NSString stringWithFormat:@"%@", [dict objectForKey:kWhTotal]];
    _lbReceived.text            = [NSString stringWithFormat:@"%@", [dict objectForKey:@"received"]];
    _lbQuantityNeeded.text      = [NSString stringWithFormat:@"%@", [dict objectForKey:@"quantity_need"]];
    _lbCrateQty.text            = [NSString stringWithFormat:@"%@", [dict objectForKey:@"crate_qty"]];
    _lbCrateType.text           = [NSString stringWithFormat:@"%@", [dict objectForKey:@"crateType"]];
}

@end
