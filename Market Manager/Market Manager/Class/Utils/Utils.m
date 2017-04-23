//
//  Utils.m
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "Utils.h"
#import "DateTimePickerController.h"
#import "UserManager.h"
#import "User.h"

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

+ (NSString *) stringHTML:(NSDictionary *) products crates:(NSDictionary *)crates productSum:(float)pdSum crateSum:(float)crSum {
    float invoiceSum = pdSum + crSum;
    NSMutableString *str = [NSMutableString new];
    
    [str appendString:@"<style> table, th, td {border: 0px solid black;}</style>"];
    [str appendString:@"<div>"];
    
    NSString *strName = [NSString stringWithFormat:@"<h2<b>INVOINCE</b></h2><P><h3>SELL COMPANY'S NAME: %@</h3></P>", @"Cong ty co phan FPT"];
    [str appendString:strName];
    [str appendString:@"<p><h3>BUY COMPANY'S NAME:</h3></p>"];
    [str appendString:@"<br>"];
    NSString *str0 = [NSString stringWithFormat:@"<div><p style='text-align: left; padding-left: 10px;'>Date: %@</p></div>", [self stringTodayDateTime]];
    [str appendString:str0];
    
    
    //product table
    [str appendString:@"<div>"];
    NSString *str1 = @"<table width=77% style='text-align: left;'><tr><th width=25%>Product Name</th><th width=20%>Quantity</th><th width=20%>Price</th><th>Total</th></tr>";
    [str appendString:str1];
    
    for(int i = 0; i < [products[@"total"] count]; i++) {
        NSString *str2 = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr><tr>", products[@"name"][i], products[@"quantity"][i], products[@"price"][i], products[@"total"][i]];
        [str appendString:str2];
    }
    
    NSString *str3 = [NSString stringWithFormat:@"<td colspan=3>Total</td><td><b>%.2f</b></td></tr></table></div><br><br>", pdSum];
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
    
    NSString *strC = [NSString stringWithFormat:@"<td colspan=3>Container charge</td><td><b>%.2f</b></td></tr></table></div><br><br>", crSum];
    [str appendString:strC];
    
    NSString *strD = [NSString stringWithFormat:@"<div style='text-align: left; padding-left: 10px;'>Invoice Total charge:         <b>%.2f</b></div>", invoiceSum];
    [str appendString:strD];
    [str appendString:@"</div>"];
    
    return str;
}

+ (BOOL)hasReadPermission:(NSString *)side {
    User *tempUser = [[UserManager sharedInstance] getTempUser];
    if (tempUser.isAdmin || [tempUser.readPermission containsString:side]) {
        return YES;
    }
    [CallbackAlertView setBlock:titleError message:msgPermissionFailed okTitle:btnOK okBlock:nil cancelTitle:nil cancelBlock:nil];
    return NO;}

+ (BOOL)hasWritePermission:(NSString *)side notify:(BOOL)isShow {
    User *tempUser = [[UserManager sharedInstance] getTempUser];
    if (tempUser.isAdmin || [tempUser.writePermission containsString:side]) {
        return YES;
    }
    if (isShow) {
        [CallbackAlertView setBlock:titleError message:msgPermissionFailed okTitle:btnOK okBlock:nil cancelTitle:nil cancelBlock:nil];

    }
    return NO;
}

//* Get title with key */

+ (NSString *)getTitle {
    if([[ProductManager sharedInstance] getProductType] == kVegetables)
        return @"Vegatables";
    else if([[ProductManager sharedInstance] getProductType] == kMeats)
        return @"Meats";
    else
        return @"Foods";
}

+ (NSArray *)getFunctionList {
    if([[ProductManager sharedInstance] getProductType] == kFoods)
        return @[[[MenuCellProp alloc] initWith:kTitleProduct image:@"ic_shopping_cart_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleWH image:@"ic_swap_vertical_circle_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleOrder image:@"ic_description_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleCustomer image:@"ic_description_36pt"]];
    else
        return @[[[MenuCellProp alloc] initWith:kTitleProduct image:@"ic_shopping_cart_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleWH image:@"ic_swap_vertical_circle_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleShop image:@"ic_store_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleMarketNeed image:@"ic_store_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleOrder image:@"ic_description_36pt"],
                 [[MenuCellProp alloc] initWith:kTitleCrate image:@"ic_dns_36pt"]];
}

+ (void)showDetailBy:(NSString *)name at:(UIViewController *)view {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    UIViewController *detailCtrl;
    if ([name isEqualToString:kTitleProduct] && [Utils hasReadPermission:kProductTableName]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:StoryboardProductNavigation];
    } else if ([name isEqualToString:kTitleWH]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:StoryboardSupplyNavigation];
    } else if ([name isEqualToString:kTitleShop]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:StoryboardShopNavigation];
    } else if ([name isEqualToString:kTitleMarketNeed]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:SBReportSummaryQtyNeed];
    } else if ([name isEqualToString:kTitleOrder]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:StoryboardOrderNavigation];
    } else if ([name isEqualToString:kTitleCrate] && [Utils hasReadPermission:kCrateTableName]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:StoryboardCrateNavigation];
    } else if ([name isEqualToString:kTitleCustomer]) {
        detailCtrl = [mainSB instantiateViewControllerWithIdentifier:SBCustomerNavID];
    }
    if (detailCtrl) {
        [view presentViewController:detailCtrl animated:YES completion:nil];
    }
}


@end
