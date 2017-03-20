//
//  UserDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableUser;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameLbl.text = _user.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
