//
//  Product.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *productDesc;
@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *shopProductID;
@property (nonatomic, strong) NSString *productOrderID;
@property (nonatomic, strong) NSString *productWhID;
@property (nonatomic, strong) NSString *whID;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger STake, order, wh1, wh2, whTL, crateQty, crateType, outQty, inQty, whTotal, reportReceived, reportQuantityNeed, reportTotal, reportOrderQuantity;

@property (nonatomic, assign) float price;

- (instancetype)initWith:(NSDictionary *)data;
- (instancetype)initOriginProduct:(NSDictionary *)theDictionary;
- (instancetype)initShopProduct:(NSDictionary *)theDictionary;
- (instancetype)initWareHouseProduct:(NSDictionary *)theDictionary;
@end

