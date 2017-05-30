//
//  SupplyManager.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Supply.h"

@interface SupplyManager : NSObject
+ (instancetype)sharedInstance;
- (void)setWarehouses:(NSArray *)data;
- (NSArray *)getWarehouses;
- (void)delete:(Supply *)supply;
- (void)insert:(Supply *)supply;
- (void)update:(Supply *)supply;
- (void)deleteAll;
- (NSArray *)getSupplyNameList;
- (BOOL)exist:(NSString *)warehouseName;
@end
