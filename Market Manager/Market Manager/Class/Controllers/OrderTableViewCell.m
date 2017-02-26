//
//  OrderTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderPopOverViewController.h"

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *dateOrderLabel;
@property (weak, nonatomic) Order *order;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(Order *)order {
    _order = order;
    _orderName.text = _order.name;
    _dateOrderLabel.text = _order.date;
}


@end
