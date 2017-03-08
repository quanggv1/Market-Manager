//
//  OrderDetailViewController.h
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Order.h"
#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController
@property (weak, nonatomic) Order *order;
@end
