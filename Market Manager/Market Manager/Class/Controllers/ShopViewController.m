//
//  ShopViewController.m
//  Market Manager
//
//  Created by quanggv on 2/16/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopViewController.h"
#import "Shop.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"
#import "ShopManager.h"
#import "AddNewShopViewController.h"

@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *shopDataSource;
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    [self download];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.shopTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(download) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Shop Management";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:kShopTableName};
    [manager GET:API_GETDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[ShopManager sharedInstance] setValueWith:[responseObject objectForKey:kData]];
                 _shopDataSource = [[NSMutableArray alloc] initWithArray:[[ShopManager sharedInstance] getShopList]];
                 [_shopTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self.refreshControl endRefreshing];
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self.refreshControl endRefreshing];
             ShowMsgConnectFailed;
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    Shop *shopDeleted = _shopDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":kShopTableName,
                             @"params": @{@"idName":kShopID,
                                          @"idValue":shopDeleted.ID}};
    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideActivity];
        [[ShopManager sharedInstance] delete:shopDeleted];
        [_shopDataSource removeObjectAtIndex:indexPath.row];
        [_shopTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
    }];
}

- (IBAction)onAddNewShop:(id)sender {
    [AddNewShopViewController showViewAt:self onSave:^(Shop *shop) {
        [_shopDataSource insertObject:shop atIndex:0];
        [_shopTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}


#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShop];
    [cell initWith: [_shopDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SegueShopDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueShopDetail]) {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = _shopDataSource[_shopTableView.indexPathForSelectedRow.row];
    }
}
@end
