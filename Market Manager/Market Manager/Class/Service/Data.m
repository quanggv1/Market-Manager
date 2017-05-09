//
//  Data.m
//  Market Manager
//
//  Created by quanggv on 5/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Data.h"
#import "Loading.h"

@implementation Data
+ (instancetype)sharedInstance
{
    static Data *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Data alloc] init];
    });
    return sharedInstance;
}

- (void)get:(NSString *)url data:(id)data success:(void(^)(id res))successCallback error:(void(^)())errorCacllback {
    [[Loading shareInstance] show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [[manager requestSerializer] setTimeoutInterval:5];
    [manager GET:url
      parameters:data
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             successCallback(responseObject);
             [[Loading shareInstance] hide];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             errorCacllback();
             [[Loading shareInstance] hide];
         }];
}


@end
