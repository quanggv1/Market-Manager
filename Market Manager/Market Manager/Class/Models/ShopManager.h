//
//  ShopManager.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Shop.h"

@interface ShopManager : NSObject
+ (instancetype)sharedInstance;
- (void)setValueWith:(NSArray *)data;
- (NSArray *)getShopList;
@end
