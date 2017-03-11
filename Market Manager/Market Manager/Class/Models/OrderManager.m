//
//  OrderManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderManager.h"

@implementation OrderManager {
    NSMutableArray *orderList;
}

+ (instancetype)sharedInstance {
    static OrderManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OrderManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setValueWith:(NSArray *)data {
    orderList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Order *order = [[Order alloc] initWith:dictionary];
        [orderList addObject:order];
    }
}

- (NSArray *)getOrderList {
    return orderList;
}

- (NSArray *)getOrderList:(NSArray *)array {
    NSMutableArray *orders = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        Order *order = [[Order alloc] initWith:dictionary];
        [orders addObject:order];
    }
    return orders;
}
@end
