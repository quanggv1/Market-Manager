//
//  UserDetailViewController.h
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "User.h"
#import "BaseViewController.h"

@interface UserDetailViewController : BaseViewController
@property (weak, nonatomic) User *user;
@end
