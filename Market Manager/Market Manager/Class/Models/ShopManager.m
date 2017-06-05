//
//  ShopManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopManager.h"
#import "Data.h"

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

- (void)delete:(Shop *)shop {
    for (Shop *item in shopList) {
        if(item.ID == shop.ID) {
            [shopList removeObject:item];
            break;
        }
    }
}

- (void)insert:(Shop *)shop {
    [shopList insertObject:shop atIndex:0];
}

- (void)update:(Shop *)shop {
    for (Shop *item in shopList) {
        if(item.ID == shop.ID) {
            NSMutableArray *newshopList = [shopList mutableCopy];
            [newshopList replaceObjectAtIndex:[shopList indexOfObject:item] withObject:shop];
            shopList = [NSMutableArray arrayWithArray:newshopList];
        }
    }
}

- (void)deleteAll {
    [shopList removeAllObjects];
}

- (NSArray *)getShopNameList {
    NSMutableArray *ShopNameList = [[NSMutableArray alloc] init];
    for (Shop *item in shopList) {
        [ShopNameList addObject:item.name];
    }
    return ShopNameList;
}

- (void)getShopProductsWithDate:(NSString *)date shop:(Shop *)theShop success:(void (^)(NSArray *products))callbackSuccess error:(void (^)())callbackError
{
    NSDictionary *params = @{kShopID:theShop.ID,
                             kDate: date,
                             kShopName: theShop.name,
                             kType: @([[ProductManager sharedInstance] getProductType])};
    
    [[Data sharedInstance] get:API_GETSHOP_PRODUCTS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSArray *shopProducts = [res objectForKey:kData];
            shopProducts = [[ProductManager sharedInstance] getShopProductsFromData:shopProducts];
            callbackSuccess(shopProducts);
        } else {
            callbackError();
        }
    } error:^{
        callbackError();
    }];
}
@end
