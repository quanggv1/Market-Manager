//
//  UserDetailTableViewCell.h
//  Market Manager
//
//  Created by quanggv on 3/21/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "User.h"

@interface UserDetailTableViewCell : UITableViewCell
- (void)setUser:(User *)user;
- (void)setPermissionDict:(NSMutableDictionary *)permissionDict;
@end
