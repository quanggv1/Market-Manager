//
//  User.h
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *name, *ID, *password, *readPermission, *writePermission;
@property (nonatomic, assign) NSUInteger isAdmin;
- (instancetype)initWith:(NSDictionary *)data;
@end
