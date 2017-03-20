//
//  MenuViewController.h
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
@interface MenuViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) User *user;
@end
