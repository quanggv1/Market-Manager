//
//  Crate.m
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Crate.h"

@implementation Crate
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.ID = [NSString stringWithFormat:@"%@",[data objectForKey:kCrateID]];
        self.name = [NSString stringWithFormat:@"%@",[data objectForKey:kCrateType]];
        self.qtyIn = [[data objectForKey:kCrateIn] integerValue];
        self.qtyOut = [[data objectForKey:kCrateOut] integerValue];
        self.total = [[data objectForKey:kCrateTotal] integerValue];
        self.price = [[data objectForKey:@"price"] floatValue];
        self.crateDesc = [NSString stringWithFormat:@"%@",[data objectForKey:kCrateDesc]];
        self.provider = [NSString stringWithFormat:@"%@", [data objectForKey:kCrateProvider]];
    }
    return self;
}

@end
