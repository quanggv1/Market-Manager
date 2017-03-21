//
//  UserDetailTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 3/21/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserDetailTableViewCell.h"

@interface UserDetailTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) NSMutableDictionary *permissionDict;
@property (weak, nonatomic) IBOutlet UIButton *readCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *writeCheckbox;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UISwitch *adminstrationSwitch;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation UserDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _passwordField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    _userNameField.text = user.name;
    _passwordField.text = user.password;
    [_adminstrationSwitch setOn:(user.isAdmin) ? YES : NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _user.password = textField.text;
}

- (IBAction)onAdminstrationSwitched:(id)sender {
    _user.isAdmin = _adminstrationSwitch.isOn;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyUpdateProfile object:nil];
}

- (void)setPermissionDict:(NSMutableDictionary *)permissionDict {
    _permissionDict = permissionDict;
    _nameLabel.text = [_permissionDict objectForKey:@"name"];
    
    [_readCheckbox setSelected: [[NSString stringWithFormat:@"%@", [_permissionDict objectForKey:kReadPermission]] isEqualToString:@"1"]];
    [_writeCheckbox setSelected: [[NSString stringWithFormat:@"%@", [_permissionDict objectForKey:kWritePermission]] isEqualToString:@"1"]];
}

- (IBAction)onCheckBoxClicked:(id)sender {
    if(sender == _readCheckbox) {
        [_readCheckbox setSelected:!_readCheckbox.isSelected];
        [_permissionDict setValue:_readCheckbox.isSelected ? @"1" : @"0" forKey:kReadPermission];
    } else {
        [_writeCheckbox setSelected:!_writeCheckbox.isSelected];
        [_permissionDict setValue:_writeCheckbox.isSelected ? @"1" : @"0" forKey:kWritePermission];
    }
}
@end
