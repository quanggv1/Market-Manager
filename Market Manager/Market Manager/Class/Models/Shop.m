//
//  Shop.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Shop.h"

@implementation Shop
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.name = [NSString stringWithFormat:@"%@", [data objectForKey:@"shopName"]];
        self.ID = [NSString stringWithFormat:@"%@", [data objectForKey:@"shopID"]];
        self.shopDesc = [NSString stringWithFormat:@"%@", [data objectForKey:@"description"]];
    }
    return self;
}
@end
