//
//  ProductManager.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Product.h"

@interface ProductManager : NSObject
+ (instancetype)sharedInstance;

- (void)setProducts:(NSArray *)data;
- (NSArray *)getProductsWithType:(kProductType)type;
- (void)delete:(Product *)product;
- (void)insert:(Product *)product;
- (void)update:(Product *)product;
- (void)deleteAll;

- (NSArray *)getProductNameList;
- (NSArray *)getProductListWith:(NSArray *)data;
- (NSString *)getProductIdBy:(NSString *)productName;
- (void)setProductType:(kProductType)productType;
- (kProductType)getProductType;
- (BOOL)exist:(NSString *)productName type:(NSInteger)type;
- (NSArray *)getShopProductsFromData:(NSArray *)theArray;
- (NSArray *)getWarehouseProductsFromData:(NSArray *)theArray;
@end
