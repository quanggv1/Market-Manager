//
//  SupplyManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyManager.h"

@implementation SupplyManager {
    NSMutableArray *warehouses;
    NSString *warehouseName;
}

+ (instancetype)sharedInstance {
    static SupplyManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SupplyManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setWarehouses:(NSArray *)data {
    warehouses = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Supply *supply = [[Supply alloc] initWith:dictionary];
        [warehouses addObject:supply];
    }
}

- (NSArray *)getWarehouses {
    return warehouses;
}

- (void)delete:(Supply *)supply {
    for (Supply *item in warehouses) {
        if(item.ID == supply.ID) {
            [warehouses removeObject:item];
            break;
        }
    }
}

- (void)insert:(Supply *)supply {
    [warehouses insertObject:supply atIndex:0];
}

- (void)update:(Supply *)supply {
    for (Supply *item in warehouses) {
        if(item.ID == supply.ID) {
            NSMutableArray *newsupplyList = [warehouses mutableCopy];
            [newsupplyList replaceObjectAtIndex:[warehouses indexOfObject:item] withObject:supply];
            warehouses = [NSMutableArray arrayWithArray:newsupplyList];
        }
    }
}

- (void)deleteAll {
    [warehouses removeAllObjects];
}

- (NSArray *)getSupplyNameList {
    NSMutableArray *SupplyNameList = [[NSMutableArray alloc] init];
    for (Supply *item in warehouses) {
        [SupplyNameList addObject:item.name];
    }
    return SupplyNameList;
}

#pragma mark - Extend
- (BOOL)exist:(NSString *)warehouseName
{
    for (Supply *supply in warehouses) {
        if ([supply.name isEqualToString:warehouseName]) {
            return YES;
        }
    }
    return NO;
}

- (void)setCurrentWarehouseName:(NSString *)name
{
    warehouseName = name;
}

- (NSString *)getCurrentWarehouseName
{
    return warehouseName;
}

@end
