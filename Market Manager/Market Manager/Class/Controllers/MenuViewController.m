//
//  MenuViewController.m
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "ProductManager.h"
#import "ShopManager.h"
#import "SupplyManager.h"
#import "CrateManager.h"
#import "Crate.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *groupContainerViews;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic) BOOL isMenuShow;
@property (nonatomic, strong) NSArray *menuData;

@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) UINavigationController *productNavigationController;
@property (strong, nonatomic) UINavigationController *shopNavigationController;
@property (strong, nonatomic) UINavigationController *supplyNavigationController;
@property (strong, nonatomic) UINavigationController *orderNavigationController;
@property (strong, nonatomic) UINavigationController *userNavigationController;
@property (strong, nonatomic) UINavigationController *crateNavigationController;
@property (assign, nonatomic) NSInteger numberOfFunction;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showActivity];
    NSLog(@"user %@", _user.name);
    _productNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardProductNavigation];
    _shopNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardShopNavigation];
    _supplyNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardSupplyNavigation];
    _orderNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardOrderNavigation];
    _userNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardUserNavigation];
    _crateNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardCrateNavigation];

    _menuData = @[[[MenuCellProp alloc] initWith:@"Products" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Ware House" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Shop" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:kTitleOrderManagement image:@"ic_description_36pt"],
                  [[MenuCellProp alloc] initWith:@"Crate Management" image:@"ic_dns_36pt"],
                  [[MenuCellProp alloc] initWith:@"User Management" image:@"ic_people_36pt"],
                  [[MenuCellProp alloc] initWith:@"Log out" image:@"ic_exit_to_app_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    _menuTable.rowHeight = UITableViewAutomaticDimension;
    _menuTable.estimatedRowHeight = 80;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.menuTable;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadCrate) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    [self downloadCrate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideActivity];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)downloadCrate {
    [self showActivity];
    _numberOfFunction = 2;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_DATA_DEFAULT
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[CrateManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kCrateTableName]];
                 [[SupplyManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kSupplyTableName]];
                 [[ShopManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kShopTableName]];
                 [[ProductManager sharedInstance] setValueWith:[[responseObject objectForKey:kData] objectForKey:kProductTableName]];
                 _numberOfFunction = _menuData.count + 1;
                 [_menuTable reloadData];
             } else {
                 ShowMsgUnavaiableData;
             }
             [self hideActivity];
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             ShowMsgConnectFailed;
             [self hideActivity];
             [self.refreshControl endRefreshing];
         }];
}

#pragma mark - table
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfFunction;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenuBanner];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        return cell;
    } else {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
        NSInteger index = (indexPath.row == _numberOfFunction - 1) ? (_menuData.count - 1) : (indexPath.row - 1);
        [cell setMenuWith:[_menuData objectAtIndex:index]];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 1:
            if(_numberOfFunction == 2) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if(![Utils hasReadPermission:kProductTableName]) return;
                [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardProductNavigation] animated:YES completion:nil];
            }
            
            break;
        case 2:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardSupplyNavigation] animated:YES completion:nil];
            break;
        case 3:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardShopNavigation] animated:YES completion:nil];
            break;
        case 4:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardOrderNavigation] animated:YES completion:nil];;
            break;
        case 5:
            if(![Utils hasReadPermission:kCrateTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardCrateNavigation] animated:YES completion:nil];
            break;
        case 6:
            if(![Utils hasReadPermission:kUserTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardUserNavigation] animated:YES completion:nil];
            break;
        case 7:
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
}





@end
