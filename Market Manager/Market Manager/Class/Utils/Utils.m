//
//  Utils.m
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "Utils.h"
#import "DateTimePickerController.h"

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

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return df;
}

+ (NSString *)stringTodayDateTime {
    return [[Utils dateFormatter] stringFromDate:[NSDate date]];
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
