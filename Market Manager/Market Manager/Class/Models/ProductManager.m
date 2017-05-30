//
//  ProductManager.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductManager.h"

@implementation ProductManager {
    NSMutableArray *products;
    kProductType _productType;
}

+ (instancetype)sharedInstance
{
    static ProductManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ProductManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setProducts:(NSArray *)data
{
    products = [[NSMutableArray alloc] initWithArray:[self getProductListWith:data]];
}


- (NSArray *)getProductsWithType:(kProductType)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Product *product in products) {
        if (product.type == type) {
            [array addObject:product];
        }
    }
    return array;
}

- (void)delete:(Product *)product
{
    for (Product *item in products) {
        if(item.productId == product.productId) {
            [products removeObject:item];
            break;
        }
    }
}

- (void)insert:(Product *)product
{
    [products insertObject:product atIndex:0];
}

- (void)update:(Product *)product
{
    for (Product *item in products) {
        if(item.productId == product.productId) {
            NSMutableArray *newProductList = [products mutableCopy];
            [newProductList replaceObjectAtIndex:[products indexOfObject:item] withObject:product];
            products = [NSMutableArray arrayWithArray:newProductList];
        }
    }
}

- (void)deleteAll
{
    [products removeAllObjects];
}

#pragma mark - Extend
- (NSArray *)getProductNameList {
    NSMutableArray *productNameList = [[NSMutableArray alloc] init];
    for (Product *item in products) {
        [productNameList addObject:item.name];
    }
    return productNameList;
}

- (NSString *)getProductIdBy:(NSString *)productName {
    for (Product *item in products) {
        if([item.name isEqualToString:productName]) {
            return item.productId;
        }
    }
    return nil;
}

- (void)setProductType:(kProductType)productType {
    _productType = productType;
}

- (kProductType)getProductType {
    return _productType;
}

- (NSArray *)getProductListWith:(NSArray *)data {
    NSMutableArray *productList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Product *product = [[Product alloc] initOriginProduct:dictionary];
        [productList addObject:product];
    }
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:nil];
    return [NSMutableArray arrayWithArray:[productList sortedArrayUsingDescriptors:@[sortDescriptor]]];
}

- (BOOL)exist:(NSString *)productName type:(NSInteger)type {
    for (Product *product in products) {
        if (product.type == type && [product.name isEqualToString:productName]) {
            return YES;
        }
    }
    return NO;
}
@end
