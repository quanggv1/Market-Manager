//
//  BaseViewController.h
//  Market Manager
//
//  Created by Quang on 2/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//
#import "AppDelegate.h"

@interface BaseViewController : UIViewController
@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (void)showActivity;
- (void)hideActivity;
- (void)showConfirmToBack;
- (void)restrictRotation:(BOOL)restriction;
@end
