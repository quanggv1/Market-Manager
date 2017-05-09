//
//  Data.h
//  Market Manager
//
//  Created by quanggv on 5/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject
+ (instancetype)sharedInstance;
- (void)get:(NSString *)url target:(id)target data:(id)data success:(void(^)(id res))successCallback error:(void(^)())errorCacllback;

@end
