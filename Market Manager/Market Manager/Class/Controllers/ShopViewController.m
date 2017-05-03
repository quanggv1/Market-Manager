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

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_SHOPS
      parameters:nil
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
    Shop *deletedShop = _shopDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_REMOVE_SHOP
      parameters:@{kShopID: deletedShop.ID}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[ShopManager sharedInstance] delete:deletedShop];
                 [_shopDataSource removeObjectAtIndex:indexPath.row];
                 [_shopTableView deleteRowsAtIndexPaths:@[indexPath]
                                       withRowAnimation:UITableViewRowAnimationFade];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             ShowMsgConnectFailed;
             [self hideActivity];
         }];
}

- (IBAction)onAddNewShop:(id)sender {
    if(![Utils hasWritePermission:kShopTableName notify:YES]) return;
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
    [cell setShop:[_shopDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *shopName = ((Shop *)_shopDataSource[_shopTableView.indexPathForSelectedRow.row]).name;
    if([Utils hasReadPermission:shopName]) {
        [self performSegueWithIdentifier:SegueShopDetail sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils hasWritePermission:kShopTableName notify:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueShopDetail]) {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = _shopDataSource[_shopTableView.indexPathForSelectedRow.row];
    }
}
@end
