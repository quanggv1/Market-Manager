//
//  Utils.m
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "Utils.h"

static ActivityView* activityView;
@implementation Utils
+ (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (UIViewController *)topViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

+ (void)showActivity {
    if (!activityView) {
        UIViewController *topViewController = [self topViewController];
        activityView = [[ActivityView alloc] initWithFrame:topViewController.view.frame];
        [topViewController.view addSubview:activityView];
    }
    [activityView show];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0f]];
}

+ (void)hideActivity {
    if (activityView) {
        [activityView hide];
    }
}


@end
