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

@end
