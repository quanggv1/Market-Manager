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
        self.name = [data objectForKey:@"name"];
    }
    return self;
}
@end
