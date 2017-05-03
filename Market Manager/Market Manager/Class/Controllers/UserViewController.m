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
#import "ProductManager.h"
#import "ShopManager.h"
#import "SupplyManager.h"
#import "CrateManager.h"
#import "Crate.h"


@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *userDataSource;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = @"User Management";
    [self getData];
}

- (void)getData {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_DATA_DEFAULT
      parameters:@{kProduct: @([[ProductManager sharedInstance] getProductType])}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[SupplyManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kSupplyTableName]];
                 [[ShopManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kShopTableName]];
                 [self getUserData];
             } else {
                 [self hideActivity];
                 [self showConfirmToBack];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self showConfirmToBack];
             [self hideActivity];
         }];
}

- (void)getUserData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_USERS
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * task, id  responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[UserManager sharedInstance] setValueWith:[responseObject objectForKey:kData]];
                 _userDataSource = [[NSMutableArray alloc] initWithArray:[[UserManager sharedInstance] getUserList]];
                 [_userTableView reloadData];
             } else {
                 [self showConfirmToBack];;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self showConfirmToBack];
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    User *userDeleted = _userDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_REMOVE_USER
      parameters:@{kUserID: userDeleted.ID}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[UserManager sharedInstance] delete:userDeleted];
                 [_userDataSource removeObjectAtIndex:indexPath.row];
                 [_userTableView deleteRowsAtIndexPaths:@[indexPath]
                                       withRowAnimation:UITableViewRowAnimationFade];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (IBAction)onAddNewUser:(id)sender {
    [AddNewUserViewController showViewAt:self onSave:^(User *user) {
        [_userDataSource insertObject:user atIndex:0];
        [_userTableView reloadData];
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
