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
#import "Data.h"

@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *shops;
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Shop Management";
}

- (void)loadData
{
    _shops = [[NSMutableArray alloc] initWithArray:[[ShopManager sharedInstance] getShopList]];
    [_shopTableView reloadData];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath
{
    Shop *deletedShop = _shops[indexPath.row];
    NSDictionary *params = @{kShopID: deletedShop.ID,
                             kShopName: deletedShop.name};
    
    [[Data sharedInstance] get:API_REMOVE_SHOP data:params success:^(id res) {
        if([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [[ShopManager sharedInstance] delete:deletedShop];
            [self loadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onAddNewShop:(id)sender
{
    if(![Utils hasWritePermission:kShopTableName notify:YES]) return;
    [AddNewShopViewController showViewAt:self onSave:^(Shop *shop) {
        [self loadData];
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShop];
    [cell setShop:[_shops objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *shopName = ((Shop *)_shops[indexPath.row]).name;
    if([Utils hasReadPermission:shopName]) {
        [self performSegueWithIdentifier:SegueShopDetail sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utils hasWritePermission:kShopTableName notify:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SegueShopDetail]) {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = _shops[_shopTableView.indexPathForSelectedRow.row];
    }
}

@end
