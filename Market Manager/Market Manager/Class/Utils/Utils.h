//
//  Utils.h
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityView.h"

@interface Utils : NSObject
+ (void)hideKeyboard;
+ (void)showActivity;
+ (void)hideActivity;
+ (NSDateFormatter *)dateFormatter;
+ (void)showDatePickerWith:(NSString *)date target:(id)target selector:(SEL)selector;
+ (void)hideDatePicker;
@end
