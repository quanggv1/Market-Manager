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
        self.productWhID = [NSString stringWithFormat:@"%@", [data objectForKey:kProductWareHouseID]];
        self.outQty = [[data objectForKey:kWhOutQuantity] integerValue];
        self.inQty = [[data objectForKey:kWhInQuantity] integerValue];
        self.whTotal = [[data objectForKey:kWhTotal] integerValue];
        self.reportQuantityNeed = [[data objectForKey:@"quantity_need"] integerValue];
        self.reportTotal = [[data objectForKey:@"total"] integerValue];
        self.reportReceived = [[data objectForKey:@"received"] integerValue];
        self.reportOrderQuantity = [[data objectForKey:@"order_quantity"] integerValue];
    }
    return self;
}

- (instancetype)initOriginProduct:(NSDictionary *)theDictionary
{
    self = [super init];
    if (self) {
        self.name = [NSString stringWithFormat:@"%@", [theDictionary objectForKey:kName]];
        
        id description = [theDictionary objectForKey:kDescription];
        self.productDesc = (description) ? [NSString stringWithFormat:@"%@", description] : @"";
        
        self.price = [[theDictionary objectForKey:kPrice] floatValue];
        self.productId = [NSString stringWithFormat:@"%@", [theDictionary objectForKey:kId]];
        self.type = [[theDictionary objectForKey:kType] integerValue];
    }
    return self;
}

- (instancetype)initShopProduct:(NSDictionary *)theDictionary
{
    self = [super init];
    if (self) {
        
        self.productId = [NSString stringWithFormat:@"%@", [theDictionary objectForKey:kId]];
        self.name = [NSString stringWithFormat:@"%@", [theDictionary objectForKey:kName]];
        
//        id description = [theDictionary objectForKey:kDescription];
//        self.productDesc = (description) ? [NSString stringWithFormat:@"%@", description] : @"";
        
        self.price = [[theDictionary objectForKey:kPrice] floatValue];
        self.STake = [[theDictionary objectForKey:kProductSTake] integerValue];
    }
    return self;
}

@end
