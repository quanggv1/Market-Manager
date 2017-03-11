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
        self.productDesc = ([data objectForKey:kProductDesc]) ? [NSString stringWithFormat:@"%@", [data objectForKey:kProductDesc]] : @"";
        self.productId = [NSString stringWithFormat:@"%@", [data objectForKey:kProductID]];
        self.price = [[data objectForKey:kProductPrice] floatValue];
        self.STake = [[data objectForKey:kProductSTake] integerValue];
        self.order = [[data objectForKey:kProductOrder] integerValue];
        self.shopProductID = [NSString stringWithFormat:@"%@", [data objectForKey:kShopProductID]];
        self.wh1 = [[data objectForKey:kWh1] integerValue];
        self.wh2 = [[data objectForKey:kWh2] integerValue];
        self.whTL = [[data objectForKey:kWhTL] integerValue];
        self.crateQty = [[data objectForKey:kCrateQty] integerValue];
        self.crateType = [[data objectForKey:kCrateType] integerValue];
        self.productOrderID = [NSString stringWithFormat:@"%@", [data objectForKey:kProductOrderID]];
    }
    return self;
}
@end
