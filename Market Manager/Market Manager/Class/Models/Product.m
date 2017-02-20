//
//  Product.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Product.h"

@implementation Product
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.name = [data objectForKey:@"name"];
        self.date = [data objectForKey:@"date"];
    }
    return self;
}
@end
