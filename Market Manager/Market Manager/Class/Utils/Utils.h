//
//  Utils.h
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductManager.h"
#import "MenuCell.h"

@interface Utils : NSObject
+ (void)hideKeyboard;
+ (NSDateFormatter *)dateFormatter;
+ (NSString *)stringTodayDateTime;
+ (void)showDatePickerWith:(NSString *)date target:(id)target selector:(SEL)selector;
+ (void)hideDatePicker;
+ (NSString *)objectToJsonString:(id )object;
+ (NSString *) stringHTML:(NSDictionary *) products crates:(NSDictionary *)crates productSum:(float)pdSum crateSum:(float)crSum;
+ (BOOL)hasReadPermission:(NSString *)side;
+ (BOOL)hasWritePermission:(NSString *)side notify:(BOOL)isShow;
+ (NSString *)getTitle;
+ (NSArray *)getFunctionList;
+ (void)showDetailBy:(NSString *)name at:(UIViewController *)view;
+ (UIImage *)getBanner;
+ (NSString *)trim:(NSString *)text;
@end
