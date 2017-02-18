//
//  Shop.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (nonatomic, strong) NSString *name;
- (instancetype)initWith:(NSDictionary *)data;
@end
