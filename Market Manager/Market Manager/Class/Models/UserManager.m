//
//  UserManager.m
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager {
    NSMutableArray *userList;
}

+ (instancetype)sharedInstance {
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setValueWith:(NSArray *)data {
    userList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        User *user = [[User alloc] initWith:dictionary];
        [userList addObject:user];
    }
}

- (NSArray *)getUserList {
    return userList;
}

- (void)delete:(User *)user {
    for (User *item in userList) {
        if(item.ID == user.ID) {
            [userList removeObject:item];
            break;
        }
    }
}

- (void)insert:(User *)User {
    [userList insertObject:User atIndex:0];
}

- (void)update:(User *)user {
    for (User *item in userList) {
        if(item.ID == user.ID) {
            NSMutableArray *newUserList = [userList mutableCopy];
            [newUserList replaceObjectAtIndex:[userList indexOfObject:item] withObject:user];
            userList = [NSMutableArray arrayWithArray:newUserList];
        }
    }
}

- (void)deleteAll {
    [userList removeAllObjects];
}

@end
