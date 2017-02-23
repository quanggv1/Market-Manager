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
- (void)setValueWith:(NSArray *)data;
- (NSArray *)getSupplyList;
@end
