//
//  StorageService.h
//  Canets
//
//  Created by Quang on 12/1/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageService : NSObject
+ (instancetype)sharedInstance;
- (void)saveItem:(id)item forKey:(kInternalStorage)key;
- (id)getItemByKey:(kInternalStorage)key;
@end
