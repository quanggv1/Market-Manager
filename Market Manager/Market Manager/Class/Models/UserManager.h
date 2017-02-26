//
//  UserManager.h
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "User.h"

@interface UserManager : NSObject
+ (instancetype)sharedInstance;
- (void)setValueWith:(NSArray *)data;
- (NSArray *)getUserList;
- (void)delete:(User *)user;
- (void)insert:(User *)User;
- (void)update:(User *)user;
- (void)deleteAll;
@end
