//
//  ProductManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductManager.h"

@implementation ProductManager {
    NSMutableArray *productList;
}

+ (instancetype)sharedInstance {
    static ProductManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setValueWith:(NSArray *)data {
    productList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Product *product = [[Product alloc] initWith:dictionary];
        [productList addObject:product];
    }
}

- (NSArray *)getProductList {
    return productList;
}

- (void)delete:(Product *)product {
    for (Product *item in productList) {
        if(item.productId == product.productId) {
            [productList removeObject:item];
            break;
        }
    }
}

- (void)insert:(Product *)product {
    [productList insertObject:product atIndex:0];
}

- (void)update:(Product *)product {
    for (Product *item in productList) {
        if(item.productId == product.productId) {
            NSMutableArray *newProductList = [productList mutableCopy];
            [newProductList replaceObjectAtIndex:[productList indexOfObject:item] withObject:product];
            productList = [NSMutableArray arrayWithArray:newProductList];
        }
    }
}
@end
