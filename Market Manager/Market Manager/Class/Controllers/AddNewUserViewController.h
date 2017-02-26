//
//  AddNewUserViewController.h
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "User.h"
#import "BaseViewController.h"
typedef void(^SaveCallback)(User *User);

@interface AddNewUserViewController : BaseViewController
@property (strong, nonatomic)SaveCallback saveCallback;
+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback;
@end
