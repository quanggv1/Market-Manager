//
//  Order.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Order.h"

@implementation Order
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kId]];
        self.date = [NSString stringWithFormat:@"%@",[data objectForKey:kDate]];
        self.type = [[data objectForKey:kType] integerValue];
    }
    return self;
}
@end
