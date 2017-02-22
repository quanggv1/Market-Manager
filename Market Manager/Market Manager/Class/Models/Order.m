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
        self.name = [data objectForKey:@"name"];
        self.date = [data objectForKey:@"date"];
    }
    return self;
}
@end
