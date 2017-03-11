//
//  CrateManager.h
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Crate.h"

@interface CrateManager : NSObject
+ (instancetype)sharedInstance;
- (void)setValueWith:(NSArray *)data;
- (NSArray *)getCrateList;
- (void)delete:(Crate *)crate;
- (void)insert:(Crate *)crate;
- (void)update:(Crate *)crate;
@end
