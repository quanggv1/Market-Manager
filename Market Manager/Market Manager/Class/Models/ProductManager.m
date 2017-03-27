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
    kProductType *_productType;
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
    productList = [[NSMutableArray alloc] initWithArray:[self getProductListWith:data]];
}

- (NSArray *)getProductListWith:(NSArray *)data {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Product *product = [[Product alloc] initWith:dictionary];
        [products addObject:product];
    }
    return products;
}

- (NSArray *)getProductList {
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedArray = [productList sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
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

- (void)deleteAll {
    [productList removeAllObjects];
}

- (NSArray *)getProductNameList {
    NSMutableArray *productNameList = [[NSMutableArray alloc] init];
    for (Product *item in productList) {
        [productNameList addObject:item.name];
    }
    return productNameList;
}

- (NSString *)getProductIdBy:(NSString *)productName {
    for (Product *item in productList) {
        if([item.name isEqualToString:productName]) {
            return item.productId;
        }
    }
    return nil;
}

- (void)setProductType:(kProductType *)productType {
    _productType = productType;
}

- (kProductType *)getProductType {
    return _productType;
}
@end
