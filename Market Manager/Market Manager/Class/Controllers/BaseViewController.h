//
//  BaseViewController.h
//  Market Manager
//
//  Created by Quang on 2/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

@interface BaseViewController : UIViewController
@property (strong, nonatomic) UIRefreshControl *refreshControl;
- (void)showActivity;
- (void)hideActivity;
@end
