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
        self.name = [data objectForKey:@"productName"];
        self.productDesc = [data objectForKey:@"description"];
        self.productId = [[data objectForKey:@"productID"] integerValue];
        self.price = [[data objectForKey:@"price"] floatValue];
    }
    return self;
}
@end
