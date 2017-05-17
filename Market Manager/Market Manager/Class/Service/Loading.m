//
//  Loading.m
//  Market Manager
//
//  Created by quanggv on 5/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Loading.h"
#import "ActivityView.h"

static ActivityView *activityView;
@implementation Loading
+ (instancetype)shareInstance {
    static Loading *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Loading alloc] init];
        activityView = [[ActivityView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (void)show {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    [topController.view addSubview:activityView];
    [activityView show];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0f]];
}

- (void)hide {
    [activityView hide];
    [activityView removeFromSuperview];
}

@end
