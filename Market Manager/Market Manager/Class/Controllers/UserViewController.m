//
//  UserViewController.m
//  Market Manager
//
//  Created by quanggv on 2/16/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import "UserTableViewCell.h"
#import "UserDetailViewController.h"
#import "UserManager.h"
#import "AddNewUserViewController.h"

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *userDataSource;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [self download];

}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"User Management";
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":kUserTableName};
    [manager GET:API_GETDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UserManager sharedInstance] setValueWith:responseObject];
        _userDataSource = [[NSMutableArray alloc] initWithArray:[[UserManager sharedInstance] getUserList]];
        [_userTableView reloadData];
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    User *userDeleted = _userDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":kUserTableName,
                             @"params": @{@"idName":kUserID,
                                          @"idValue":userDeleted.ID}};
    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideActivity];
        [[UserManager sharedInstance] delete:userDeleted];
        [_userDataSource removeObjectAtIndex:indexPath.row];
        [_userTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
    }];
}

- (IBAction)onAddNewUser:(id)sender {
    [AddNewUserViewController showViewAt:self onSave:^(User *user) {
        [_userDataSource insertObject:user atIndex:0];
        [_userTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellUser];
    [cell initWith: [_userDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:SegueUserDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

#pragma mark - SEGUE
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueUserDetail]) {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.user = _userDataSource[_userTableView.indexPathForSelectedRow.row];
    }
}
@end
