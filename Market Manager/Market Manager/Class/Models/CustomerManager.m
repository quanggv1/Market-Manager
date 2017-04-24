//
//  CustomerManager.m
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CustomerManager.h"
#import "Customer.h"

@implementation CustomerManager
+ (instancetype)sharedInstance {
    static CustomerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CustomerManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (NSArray *)getListForm:(NSDictionary *)data {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in data) {
        Customer *customer = [[Customer alloc] initWith:dictionary];
        [list addObject:customer];
    }
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    return [NSMutableArray arrayWithArray:[list sortedArrayUsingDescriptors:@[sortDescriptor]]];
}

@end
