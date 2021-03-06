//
//  User.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)initWith:(NSDictionary *)data {
    self = [super init];
    if(self) {
        self.name = [NSString stringWithFormat:@"%@",[data objectForKey:kUserName]];
        self.ID = [NSString stringWithFormat:@"%@",[data objectForKey:kUserID]];
        self.password = [NSString stringWithFormat:@"%@",[data objectForKey:kUserPassword]];
        self.isAdmin = [[data objectForKey:kUserAdmin] integerValue];
        self.readPermission = [NSString stringWithFormat:@"%@",[data objectForKey:kReadPermission]];
        self.writePermission = [NSString stringWithFormat:@"%@",[data objectForKey:kWritePermission]];
    }
    return self;
}
@end
