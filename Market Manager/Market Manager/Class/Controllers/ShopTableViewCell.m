//
//  ShopTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopTableViewCell.h"

@interface ShopTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) Shop *shop;
@property (weak, nonatomic) Customer *customer;
@end

@implementation ShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShop:(Shop *)shop {
    _shop = shop;
    _shopName.text = _shop.name;
}

- (void)setCustomer:(Customer *)customer {
    _customer = customer;
    _shopName.text = _customer.name;
}




@end
