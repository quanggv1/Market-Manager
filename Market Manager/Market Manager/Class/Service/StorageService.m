//
//  StorageService.m
//  Canets
//
//  Created by Quang on 12/1/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "StorageService.h"

@implementation StorageService

+ (instancetype)sharedInstance
{
    static StorageService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StorageService alloc] init];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:[@(kStorageIPAdress) stringValue]]) {
            [[NSUserDefaults standardUserDefaults] setObject:SERVER_DEFAULT forKey:[@(kStorageIPAdress) stringValue]];
        }
    });
    return sharedInstance;
}

- (void)saveItem:(id)item forKey:(kInternalStorage)key {
    [[NSUserDefaults standardUserDefaults] setObject:item forKey:[@(key) stringValue]];
}

- (id)getItemByKey:(kInternalStorage)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[@(key) stringValue]];
}

@end
