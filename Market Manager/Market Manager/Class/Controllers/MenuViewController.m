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
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showActivity];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowHideMenu:)
                                                 name:NotifyShowHideMenu
                                               object:nil];
    
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
                  [[MenuCellProp alloc] initWith:@"User Management" image:@"ic_people_36pt"],
                  [[MenuCellProp alloc] initWith:@"Crate Management" image:@"ic_exit_to_app_36pt"],
                  [[MenuCellProp alloc] initWith:@"Log out" image:@"ic_exit_to_app_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_groupContainerViews addSubview:_productNavigationController.view];
    [self hideActivity];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onShowHideMenu:(NSNotification*)notification {
    _isMenuShow = !_isMenuShow;
    if(_isMenuShow) {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = _menuView.frame;
            frame.origin.x = 0;
            [_menuView setFrame:frame];
            _menuView.hidden = NO;
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = _menuView.frame;
            frame.origin.x -= frame.size.width;
            [_menuView setFrame:frame];
        } completion:^(BOOL finished) {
            _menuView.hidden = YES;
        }];
    }
}

#pragma mark - table
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
    [cell setMenuWith:[_menuData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self hideContainerViews];
    switch (indexPath.row) {
        case 0:
            [_groupContainerViews addSubview:_productNavigationController.view];
            break;
        case 1:
            [_groupContainerViews addSubview:_supplyNavigationController.view];
            break;
        case 2:
            [_groupContainerViews addSubview:_shopNavigationController.view];
            break;
        case 3:
            [_groupContainerViews addSubview:_orderNavigationController.view];
            break;
        case 4:
            [_groupContainerViews addSubview:_userNavigationController.view];
            break;
        case 5:
            [_groupContainerViews addSubview:_crateNavigationController.view];
            break;
        case 6:
            [[ProductManager sharedInstance] deleteAll];
            [[ShopManager sharedInstance] deleteAll];
            [[SupplyManager sharedInstance] deleteAll];
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
    [self onShowHideMenu:nil];
}

- (void)hideContainerViews {
    [_productNavigationController.view removeFromSuperview];
    [_shopNavigationController.view removeFromSuperview];
    [_supplyNavigationController.view removeFromSuperview];
    [_orderNavigationController.view removeFromSuperview];
    [_userNavigationController.view removeFromSuperview];
    [_crateNavigationController.view removeFromSuperview];
}


- (IBAction)onOutsideMenuClicked:(id)sender {
    [self onShowHideMenu:nil];
}




@end
