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

+ (NSString *)objectToJsonString:(id )object {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    return  [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

+ (NSString *) stringHTML:(NSDictionary *) products crates:(NSDictionary *)crates {
    NSMutableString *str = [NSMutableString new];
    
    [str appendString:@"<style> table, th, td {border: 1px solid black;}</style>"];
    [str appendString:@"<div>"];
    
    NSString *strName = [NSString stringWithFormat:@"<h2<b>INVOINCE</b></h2><P><h3>COMPANY NAME: %@</h3></P>", @"Cong ty co phan FPT"];
    [str appendString:strName];
    [str appendString:@"<br>"];
    NSString *str0 = [NSString stringWithFormat:@"<div><p style='text-align: left; padding-left: 10px;'>Ngày %@. tháng %@. năm %@</p></div>", @"13", @"3", @"2017"];
    [str appendString:str0];
    
    
    //product table
    [str appendString:@"<div>"];
    NSString *str1 = @"<table width=77% style='text-align: left;'><tr><th width=25%>Product Name</th><th width=20%>Quantity</th><th width=20%>Price</th><th>Total</th></tr>";
    [str appendString:str1];
    
    for(int i = 0; i < [products[@"total"] count]; i++) {
        NSString *str2 = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr><tr>", products[@"name"][i], products[@"quantity"][i], products[@"price"][i], products[@"total"][i]];
        [str appendString:str2];
    }
    
    NSString *str3 = [NSString stringWithFormat:@"<td colspan=3>Total</td><td><b>%d</b></td></tr></table></div><br><br>", 100];
    [str appendString:str3];
    
    [str appendString:@"</div>"];
    
    [str appendString:@"<br><br>"];
    
    //crate table
    [str appendString:@"<div>"];
    NSString *strA = @"<table width=77% style='text-align: left;'><tr><th width=25%>Crate type</th><th width=20%>Quantity</th><th width=20%>Price</th><th>Total</th></tr>";
    [str appendString:strA];
    
    for(int i = 0; i < [crates[@"total"] count]; i++) {
        NSString *strB = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr><tr>", crates[@"name"][i], crates[@"quantity"][i], crates[@"price"][i], crates[@"total"][i]];
        [str appendString:strB];
    }
    
    NSString *strC = [NSString stringWithFormat:@"<td colspan=3>Container charge</td><td><b>%d</b></td></tr></table></div><br><br>", 100];
    [str appendString:strC];
    
    NSString *strD = [NSString stringWithFormat:@"<div style='text-align: left; padding-left: 10px;'>Invoice Total charge:         <b>%d</b></div>", 470];
    [str appendString:strD];
    [str appendString:@"</div>"];
    
    return str;
}


@end
