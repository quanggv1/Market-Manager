//
//  CustomerCell.m
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CustomerCell.h"

@interface CustomerCell()
@property (nonatomic, weak) IBOutlet UILabel *customerNameLable;
@property (nonatomic, weak) Customer *customer;
@end

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCustomer:(Customer *)customer {
    _customer = customer;
    [_customerNameLable setText: _customer.name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
