//
//  Crate.h
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crate : NSObject
@property (nonatomic, strong) NSString *name, *ID;
- (instancetype)initWith:(NSDictionary *)data;
@end
