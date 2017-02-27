//
//  OrderDropDownListViewController.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDropDownListViewController.h"
#import "ProductManager.h"
#import "ShopManager.h"
#import "Product.h"
#import "Shop.h"
#import "SupplyManager.h"

@interface OrderDropDownListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderDropdownTableView;
@end

@implementation OrderDropDownListViewController {
    NSArray *orderDropdownDatasource;
    NSArray *recommendList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderDropdownTableView.dataSource = self;
    _orderDropdownTableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Utils hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onSelected:(OnSelectedCell)callback {
    _onSelectedCell = callback;
}

- (void)updateRecommedListWith:(NSString *)keySearch {
    if(!keySearch || keySearch.length == 0) {
        orderDropdownDatasource = recommendList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", keySearch];
        orderDropdownDatasource = [NSMutableArray arrayWithArray:[recommendList filteredArrayUsingPredicate:predicate]];
    }
    [_orderDropdownTableView reloadData];
}

- (void)setRecommendList:(NSString *)name {
    if([name isEqualToString:kProductTableName]) {
        recommendList = [[ProductManager sharedInstance] getProductNameList];
    } else if([name isEqualToString:kShopTableName]) {
        recommendList = [[ShopManager sharedInstance] getShopNameList];
    } else if([name isEqualToString:kSupplyTableName]) {
        recommendList = [[SupplyManager sharedInstance] getSupplyNameList];
    }
    orderDropdownDatasource = [recommendList subarrayWithRange:NSMakeRange(0, (recommendList.count >= 10) ? 9 : recommendList.count)];
    [self reloadData];
}

- (void)reloadData {
    [_orderDropdownTableView reloadData];
    self.preferredContentSize = CGSizeMake(150, 35*orderDropdownDatasource.count + 35);
}


#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderDropdownDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = orderDropdownDatasource[indexPath.row];
    return cell;
}

#pragma mark - TABLE DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _onSelectedCell(orderDropdownDatasource[indexPath.row]);
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
