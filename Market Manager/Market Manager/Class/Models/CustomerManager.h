//
//  CustomerManager.h
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerManager : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)getListForm:(NSDictionary *)data;
@end
