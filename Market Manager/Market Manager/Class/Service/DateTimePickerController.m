//
//  DateTimePickerController.m
//  Canets
//
//  Created by Quang on 11/30/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "DateTimePickerController.h"

@interface DateTimePickerController ()
@property (nonatomic, assign) id target;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) SEL selector;
@property (strong, nonatomic) NSString *date;
@end

@implementation DateTimePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils hideKeyboard];
    NSDate *dateSetting = [[Utils dateFormatter] dateFromString:_date];
    dateSetting = (dateSetting) ? dateSetting : [NSDate date];
    [_datePicker setDate: dateSetting];
}

- (IBAction)onPickerSelected:(UIDatePicker *)sender {
    if (self.target == nil || self.selector == nil) return;
    if ([self.target respondsToSelector:self.selector]) {
        [self.target performSelector:self.selector withObject:sender.date afterDelay:0.0];
    }
}

- (IBAction)onOutsidePickerClicked:(id)sender {
    [Utils hideDatePicker];
}

- (void)setActionWith:(id)target selector:(SEL)selector date:(NSString *)date{
    self.target = target;
    self.selector = selector;
    self.date = date;
}

@end
