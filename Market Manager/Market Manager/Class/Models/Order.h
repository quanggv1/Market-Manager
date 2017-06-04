//
//  Order.h
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic, strong) NSString *date, *shopID, *ID;
@property (nonatomic, assign) NSInteger type;
- (instancetype)initWith:(NSDictionary *)data;
@end
