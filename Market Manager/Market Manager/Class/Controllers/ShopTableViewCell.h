//
//  ShopTableViewCell.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Shop.h"
#import "Customer.h"

@interface ShopTableViewCell : UITableViewCell
- (void)setShop:(Shop *)shop;
- (void)setCustomer:(Customer *)customer;
@end
