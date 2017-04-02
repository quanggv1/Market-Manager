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
    [self showActivity];
    _menuData = @[[[MenuCellProp alloc] initWith:@"Vegatables & others" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Meats" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Food Service" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:@"User Management" image:@"ic_people_36pt"],
                  [[MenuCellProp alloc] initWith:@"Log out" image:@"ic_exit_to_app_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    _menuTable.rowHeight = UITableViewAutomaticDimension;
    _menuTable.estimatedRowHeight = 80;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideActivity];
}



#pragma mark - table
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuData.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenuBanner];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        return cell;
    } else {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
        [cell setMenuWith:[_menuData objectAtIndex:indexPath.row - 1]];
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 1:
            [[ProductManager sharedInstance] setProductType:kVegatables];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 2:
            [[ProductManager sharedInstance] setProductType:kMeats];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 3:
            [[ProductManager sharedInstance] setProductType:kFoods];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];;
            break;
        case 4:
            if(![Utils hasReadPermission:kUserTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardUserNavigation] animated:YES completion:nil];
            break;
        case 5:
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
}

@end
