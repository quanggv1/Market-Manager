//
//  Supply.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Supply.h"

@implementation Supply
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.name = [NSString stringWithFormat:@"%@", [data objectForKey:kSupplyName]];
        self.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kSupplyID]];
        self.supplyDesc = [NSString stringWithFormat:@"%@", [data objectForKey:kSupplyDesc]];
    }
    return self;
}
@end
