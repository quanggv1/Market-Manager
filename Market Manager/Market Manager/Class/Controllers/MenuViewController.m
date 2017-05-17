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
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) NSArray *menuData;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _menuData = @[[[MenuCellProp alloc] initWith:@"Vegetables & others" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Meats" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Food Service" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:@"User Management" image:@"ic_people_36pt"],
                  [[MenuCellProp alloc] initWith:@"Log out" image:@"ic_exit_to_app_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    _menuTable.rowHeight = UITableViewAutomaticDimension;
    _menuTable.estimatedRowHeight = 80;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Supermarket";
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
    [cell setMenuWith:[_menuData objectAtIndex:indexPath.row]];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            if(![Utils hasReadPermission:kVegePermission] || ![Utils hasWritePermission:kVegePermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kVegetables];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 1:
            if(![Utils hasReadPermission:kMeatPermission] || ![Utils hasWritePermission:kMeatPermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kMeats];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 2:
            if(![Utils hasReadPermission:kFoodPermission] || ![Utils hasWritePermission:kFoodPermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kFoods];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];;
            break;
        case 3:
            if(![Utils hasReadPermission:kUserTableName]) return;
            [self performSegueWithIdentifier:@"showUsers" sender:self];
            break;
        case 4:
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
}

@end
