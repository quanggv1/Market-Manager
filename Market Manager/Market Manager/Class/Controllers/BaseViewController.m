//
//  BaseViewController.m
//  Market Manager
//
//  Created by Quang on 2/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityView.h"

@interface BaseViewController ()<UIPreviewInteractionDelegate>
@end

@implementation BaseViewController{
    ActivityView *activityView_;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    activityView_ = [[ActivityView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:activityView_];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    [Utils hideKeyboard];
}

- (void)showActivity {
    [activityView_ show];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0f]];
}

- (void)hideActivity {
    [activityView_ hide];
}

- (IBAction)onMenuClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - POPOVER DELEGATE
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

- (void)showConfirmToBack {
    [CallbackAlertView setBlock:nil
                        message:msgLoadDataFailed
                        okTitle:btnOK
                        okBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    cancelTitle:nil
                    cancelBlock:nil];
}

- (void)restrictRotation:(BOOL)restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}


@end
