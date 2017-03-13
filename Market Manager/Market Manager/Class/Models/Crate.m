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
        self.name = [NSString stringWithFormat:@"%@",[data objectForKey:kCrateName]];
        self.receivedQty = [[data objectForKey:kCrateReceived] integerValue];
        self.returnedQty = [[data objectForKey:kCrateReturned] integerValue];
    }
    return self;
}

@end
