//
//  ShopDetailViewController.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Shop.h"
#import "BaseViewController.h"

@interface ShopDetailViewController : BaseViewController
@property (weak, nonatomic) Shop *shop;
@property (strong, nonatomic) NSMutableArray *products;
@end
