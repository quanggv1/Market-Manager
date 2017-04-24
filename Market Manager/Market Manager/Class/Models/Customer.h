//
//  customer.h
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject
- (instancetype)initWith:(NSDictionary *)data;
@property (nonatomic, strong) NSString *ID, *name, *info;
@end
