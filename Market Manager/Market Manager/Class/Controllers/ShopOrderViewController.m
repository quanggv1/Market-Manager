//
//  ShopOrderViewController.m
//  Market Manager
//
//  Created by Quang on 3/4/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopOrderViewController.h"
#import "ShopManager.h"
#import "ShopTableViewCell.h"
#import "OrderViewController.h"

@interface ShopOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (strong, nonatomic) NSArray *shopDataSource;
@end

@implementation ShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    _shopDataSource = [[ShopManager sharedInstance] getShopList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = kTitleOrder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *shopName = ((Shop *)_shopDataSource[_shopTableView.indexPathForSelectedRow.row]).name;
    if([Utils hasReadPermission:shopName]) {
        [self performSegueWithIdentifier:SegueShowOrder sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueShowOrder]) {
        OrderViewController *vc = segue.destinationViewController;
        vc.shop = _shopDataSource[_shopTableView.indexPathForSelectedRow.row];
    }
}

@end
