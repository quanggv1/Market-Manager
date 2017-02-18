//
//  MenuViewController.m
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *groupContainerViews;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic) BOOL isMenuShow;
@property (nonatomic, strong) NSArray *menuData;
@property (weak, nonatomic) IBOutlet UIView *commodityView;
@property (weak, nonatomic) IBOutlet UIView *supplyView;
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UIView *shopView;
@property (weak, nonatomic) IBOutlet UIView *userView;

@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowHideMenu:)
                                                 name:NotifyShowHideMenu
                                               object:nil];
    _menuData = @[[[MenuCellProp alloc] initWith:@"Quan ly mat hang" image:@"ic_account_balance_wallet_36pt_3x"],
                  [[MenuCellProp alloc] initWith:@"Quan ly nguon hang" image:@"ic_search_36pt"],
                  [[MenuCellProp alloc] initWith:@"Quan ly shop" image:@"ic_history_36pt"],
                  [[MenuCellProp alloc] initWith:@"Quan ly order" image:@"ic_library_books_36pt"],
                  [[MenuCellProp alloc] initWith:@"Quan ly user" image:@"ic_library_books_36pt"],
                  [[MenuCellProp alloc] initWith:@"Log out" image:@"ic_library_books_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    [self setupUI];
}

- (void)setupUI {
    _menuView.hidden = YES;
    [self hideContainerViews];
    _commodityView.hidden = NO;
}

- (void)onShowHideMenu:(NSNotification*)notification {
    _menuView.hidden = NO;
    _isMenuShow = !_isMenuShow;
    if(_isMenuShow) {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = _menuView.frame;
            frame.origin.x = 0;
            [_menuView setFrame:frame];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect frame = _menuView.frame;
            frame.origin.x -= frame.size.width;
            [_menuView setFrame:frame];
        }];
    }
}

#pragma mark - table
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
            _commodityView.hidden = NO;
            break;
        case 1:
            _supplyView.hidden = NO;
            break;
        case 2:
            _shopView.hidden = NO;
            break;
        case 3:
            _orderView.hidden = NO;
            break;
        case 4:
            _userView.hidden = NO;
            break;
        case 5:
            [self dismissViewControllerAnimated:YES completion:nil];;
            break;
        default:
            break;
    }
    [self onShowHideMenu:nil];
}

- (void)hideContainerViews {
    _commodityView.hidden = YES;
    _supplyView.hidden = YES;
    _orderView.hidden = YES;
    _shopView.hidden = YES;
    _userView.hidden = YES;
}


- (IBAction)onOutsideMenuClicked:(id)sender {
    [self onShowHideMenu:nil];
}




@end
