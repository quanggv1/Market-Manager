//
//  SupplyViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 2/15/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyViewController.h"
#import "Supply.h"
#import "SupplyTableViewCell.h"
#import "SupplyDetailViewController.h"
#import "AddNewSupplyViewController.h"
#import "SupplyManager.h"

@interface SupplyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;
@property (strong, nonatomic) NSMutableArray *supplyDataSource;

@end

@implementation SupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _supplyTableView.delegate = self;
    _supplyTableView.dataSource = self;
    
    [self download];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.supplyTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(download) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Ware House";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_supplyDataSource removeObjectAtIndex:indexPath.row];
    [_supplyTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":kSupplyTableName};
    [manager GET:API_GETDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == 200) {
                 [[SupplyManager sharedInstance] setValueWith:[responseObject objectForKey:kData]];
                 _supplyDataSource = [[NSMutableArray alloc] initWithArray:[[SupplyManager sharedInstance] getSupplyList]];
                 [_supplyTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self.refreshControl endRefreshing];
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
             [self.refreshControl endRefreshing];
    }];
    [_supplyTableView reloadData];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Supply *supply = _supplyDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kSupplyName:supply.name};
    [manager GET:API_REMOVE_WAREHOUSE
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[SupplyManager sharedInstance] delete:supply];
                 [_supplyDataSource removeObjectAtIndex:indexPath.row];
                 [_supplyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onAddNewSupply:(id)sender {
    if(![Utils hasWritePermission:kSupplyTableName]) return;
    [AddNewSupplyViewController showViewAt:self onSave:^(Supply *supply) {
        [_supplyDataSource insertObject:supply atIndex:0];
        [_supplyTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _supplyDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSupply];
    [cell initWith: [_supplyDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *whName = ((Supply *)_supplyDataSource[_supplyTableView.indexPathForSelectedRow.row]).name;
    if([Utils hasReadPermission:whName]) {
        [self performSegueWithIdentifier:SegueSupplyDetail sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueSupplyDetail]) {
        SupplyDetailViewController *vc = segue.destinationViewController;
        vc.supply = _supplyDataSource[_supplyTableView.indexPathForSelectedRow.row];
    }
}



@end
