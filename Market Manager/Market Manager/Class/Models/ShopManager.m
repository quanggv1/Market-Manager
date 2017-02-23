//
//  ShopManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopManager.h"

@implementation ShopManager {
    NSMutableArray *shopList;
}

+ (instancetype)sharedInstance {
    static ShopManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ShopManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setValueWith:(NSArray *)data {
    shopList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Shop *shop = [[Shop alloc] initWith:dictionary];
        [shopList addObject:shop];
    }
}

- (NSArray *)getShopList {
    return shopList;
}

@end
