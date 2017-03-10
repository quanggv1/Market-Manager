//
//  Product.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, strong) NSString *productId, *name, *productDesc, *crateType, *shopID, *shopProductID;
@property (nonatomic, assign) NSInteger STake, order, wh1, wh2, whTL, crateQty;
@property (nonatomic, assign) float price;
- (instancetype)initWith:(NSDictionary *)data;
@end

