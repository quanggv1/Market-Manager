//
//  DateTimePickerController.h
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateTimePickerController : UIViewController
- (void)setActionWith:(id)target selector:(SEL)selector date:(NSString *)date;
@end
