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
        self.name = [NSString stringWithFormat:@"%@", [data objectForKey:kProductName]];
        self.productDesc = [NSString stringWithFormat:@"%@", [data objectForKey:kProductDesc]];
        self.productId = [[data objectForKey:kProductID] integerValue];
        self.price = [[data objectForKey:kProductPrice] floatValue];
        self.STake = [[data objectForKey:kProductSTake] integerValue];
        self.order = [[data objectForKey:kProductOrder] integerValue];
    }
    return self;
}
@end
