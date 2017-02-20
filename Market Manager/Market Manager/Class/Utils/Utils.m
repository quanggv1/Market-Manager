//
//  Utils.m
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "Utils.h"
#import "DateTimePickerController.h"

static ActivityView* activityView;
static DateTimePickerController *dateTimePickerController;

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
        activityView = [[ActivityView alloc] initWithFrame:[self topViewController].view.frame];
    }
    [[self topViewController].view addSubview:activityView];
    [activityView show];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0f]];
}

+ (void)hideActivity {
    if (activityView) {
        [activityView hide];
    }
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd"];
    return df;
}

+ (void)showDatePickerWith:(NSString *)date target:(id)target selector:(SEL)selector {
    if (!dateTimePickerController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
        dateTimePickerController = [storyboard instantiateViewControllerWithIdentifier:StoryboardDatePicker];
        [dateTimePickerController setActionWith:target selector:selector date:date];
    }
    [[self topViewController].view addSubview:dateTimePickerController.view];
}

+ (void)hideDatePicker {
    [dateTimePickerController.view removeFromSuperview];
    dateTimePickerController = nil;
}


@end
