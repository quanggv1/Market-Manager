//
//  OrderFormViewController.h
//  Market Manager
//
//  Created by Quang on 3/11/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Shop.h"
#import "Order.h"

@interface OrderFormViewController : BaseViewController
@property (weak, nonatomic) Shop *shop;
@property (weak, nonatomic) Order *order;
@end
