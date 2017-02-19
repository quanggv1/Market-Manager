//
//  UserViewController.m
//  Market Manager
//
//  Created by quanggv on 2/16/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserViewController.h"
#import "user.h"
#import "userTableViewCell.h"
#import "userDetailViewController.h"

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    [self download];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteItem:) name:NotifyUserDeletesItem object:nil];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_users removeObjectAtIndex:indexPath.row];
    [_userTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)download {
    User *user1 = [[User alloc] initWith:@{@"name":@"user1"}];
    User *user2 = [[User alloc] initWith:@{@"name":@"user2"}];
    User *user3 = [[User alloc] initWith:@{@"name":@"user3"}];
    User *user4 = [[User alloc] initWith:@{@"name":@"user4"}];
    User *user5 = [[User alloc] initWith:@{@"name":@"user5"}];
    _users = [[NSMutableArray alloc] initWithArray:@[user1, user2, user3, user4, user5]];
    [_userTableView reloadData];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    //    [manager GET:@"http://sotayit.com/service/mobile/systemsetting" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"%@", responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        //
    //    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellUser];
    [cell initWith: [_users objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:SegueUserDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueUserDetail]) {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.user = _users[_userTableView.indexPathForSelectedRow.row];
    }
}
@end
