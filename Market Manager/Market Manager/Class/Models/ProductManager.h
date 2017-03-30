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
- (void)setValueWith:(NSArray *)data;
- (NSArray *)getProductList;
- (void)delete:(Product *)product;
- (void)insert:(Product *)product;
- (void)update:(Product *)product;
- (void)deleteAll;
- (NSArray *)getProductNameList;
- (NSArray *)getProductListWith:(NSArray *)data;
- (NSString *)getProductIdBy:(NSString *)productName;
- (void)setProductType:(kProductType)productType;
- (kProductType)getProductType;
@end
