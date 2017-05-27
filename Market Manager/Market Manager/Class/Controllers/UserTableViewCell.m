//
//  UserTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserTableViewCell.h"

@interface UserTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) User *user;
@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(User *)user {
    if(!_user) {
        _user = user;
        _userName.text = _user.name;
        UIImage *image = [UIImage imageNamed: _user.isAdmin? @"ic_account_circle" : @"ic_card_membership"];
         _userImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

@end
