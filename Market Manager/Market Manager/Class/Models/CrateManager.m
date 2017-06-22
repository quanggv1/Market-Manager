//
//  CrateManager.m
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateManager.h"

@implementation CrateManager {
    NSMutableArray *crateList;
}

+ (instancetype)sharedInstance {
    static CrateManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CrateManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setValueWith:(NSArray *)data {
    crateList = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Crate *crate = [[Crate alloc] initWith:dictionary];
        [crateList addObject:crate];
    }
}

- (NSArray *)getCrateList {
    return crateList;
}

- (void)delete:(Crate *)crate {
    for (Crate *item in crateList) {
        if(item.ID == crate.ID) {
            [crateList removeObject:item];
            break;
        }
    }
}

- (void)insert:(Crate *)crate {
    [crateList insertObject:crate atIndex:0];
}

- (void)update:(Crate *)crate {
    for (Crate *item in crateList) {
        if(item.ID == crate.ID) {
            NSMutableArray *newCrateList = [crateList mutableCopy];
            [newCrateList replaceObjectAtIndex:[crateList indexOfObject:item] withObject:crate];
            crateList = [NSMutableArray arrayWithArray:newCrateList];
        }
    }
}

- (NSArray *)getCrateNameList {
    NSMutableArray *crateNames = [[NSMutableArray alloc] init];
    for (Crate *item in crateList) {
        if ([item.type isEqualToString:@"0"]) {
            [crateNames addObject:item.name];
        }
    }
    return crateNames;
}

- (NSArray *)getCrateListForm:(NSArray *)data {
    NSMutableArray *crates = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Crate *crate = [[Crate alloc] initWith:dictionary];
        [crates addObject:crate];
    }
    return crates;
}

@end
