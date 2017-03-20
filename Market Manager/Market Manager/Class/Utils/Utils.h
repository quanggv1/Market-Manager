//
//  Utils.h
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (void)hideKeyboard;
+ (NSDateFormatter *)dateFormatter;
+ (NSString *)stringTodayDateTime;
+ (void)showDatePickerWith:(NSString *)date target:(id)target selector:(SEL)selector;
+ (void)hideDatePicker;
+ (NSString *)objectToJsonString:(id )object;
+ (NSString *) stringHTML:(NSDictionary *) products crates:(NSDictionary *)crates productSum:(float)pdSum crateSum:(float)crSum;
@end
