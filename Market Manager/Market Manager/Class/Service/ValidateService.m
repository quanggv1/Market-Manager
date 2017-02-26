//
//  ValidateService.m
//  Canets
//
//  Created by Quang on 12/2/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "ValidateService.h"

@implementation ValidateService

+ (NSString *)validEmail:(NSString*)emailString {
    if([emailString length]==0){
        return @"Required";
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return @"Vui lòng nhập đúng email";
    } else {
        return @"";
    }
}

+ (NSString *)validPhone:(NSString*)phoneString {
    if([phoneString length]==0){
        return @"Required";
    }
    NSString *regExPattern = @"^[0-9]{10,14}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:phoneString options:0 range:NSMakeRange(0, [phoneString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return @"Vui lòng nhập đúng số điện thoại";
    } else {
        return @"";
    }
}

+ (NSString *)validName:(NSString*)nameString {
    if([nameString length]==0){
        return @"Required";
    }
    NSString *regExPattern = @"^[a-z0-9_-]{3,15}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:nameString options:0 range:NSMakeRange(0, [nameString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return @"Please input username correct";
    } else {
        return @"";
    }
}

+ (NSString *)validPassword:(NSString*)passwordString {
    if([passwordString length]==0){
        return @"Required";
    }
    NSString *regExPattern = @"^.{5,}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:passwordString options:0 range:NSMakeRange(0, [passwordString length])];
    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return @"Passwords must be at least 5 characters";
    } else {
        return @"";
    }
}
@end
