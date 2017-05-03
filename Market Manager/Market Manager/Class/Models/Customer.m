//
//  customer.m
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Customer.h"

@implementation Customer
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.ID = [NSString stringWithFormat:@"%@",[data objectForKey:kCustomerID]];
        self.name = [NSString stringWithFormat:@"%@",[data objectForKey:kCustomerName]];
        self.info = [NSString stringWithFormat:@"%@",[data objectForKey:kCustomerInfo]];
    }
    return self;
}
@end
