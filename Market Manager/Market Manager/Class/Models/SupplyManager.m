//
//  SupplyManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyManager.h"

@implementation SupplyManager {
    NSMutableArray *supplyList;
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

- (void)setValueWith:(NSArray *)data {
    supplyList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Supply *supply = [[Supply alloc] initWith:dictionary];
        [supplyList addObject:supply];
    }
}

- (NSArray *)getSupplyList {
    return supplyList;
}

- (void)delete:(Supply *)supply {
    for (Supply *item in supplyList) {
        if(item.ID == supply.ID) {
            [supplyList removeObject:item];
            break;
        }
    }
}

- (void)insert:(Supply *)supply {
    [supplyList insertObject:supply atIndex:0];
}

- (void)update:(Supply *)supply {
    for (Supply *item in supplyList) {
        if(item.ID == supply.ID) {
            NSMutableArray *newsupplyList = [supplyList mutableCopy];
            [newsupplyList replaceObjectAtIndex:[supplyList indexOfObject:item] withObject:supply];
            supplyList = [NSMutableArray arrayWithArray:newsupplyList];
        }
    }
}

- (void)deleteAll {
    [supplyList removeAllObjects];
}

- (NSArray *)getSupplyNameList {
    NSMutableArray *SupplyNameList = [[NSMutableArray alloc] init];
    for (Supply *item in supplyList) {
        [SupplyNameList addObject:item.name];
    }
    return SupplyNameList;
}

@end
