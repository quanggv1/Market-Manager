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
#import "CustomerManager.h"
#import "Customer.h"

@interface ShopOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (strong, nonatomic) NSArray *shopDataSource;
@end

@implementation ShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    
    if ([[ProductManager sharedInstance] getProductType] == kFoods) {
        [self getData];
    } else {
        _shopDataSource = [[ShopManager sharedInstance] getShopList];
        [_shopTableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = kTitleOrder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_CUSTOMERS
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * task, id  responseObject) {
             NSInteger statusCode = [[responseObject objectForKey:kCode] integerValue];
             if (statusCode == kResSuccess) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 CustomerManager *manager = [CustomerManager sharedInstance];
                 _shopDataSource = [manager getListForm:data];
                 [_shopTableView reloadData];
             } else {
                 [self showConfirmToBack];;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self showConfirmToBack];
         }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shopDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShop];
    if ([[ProductManager sharedInstance] getProductType] == kFoods) {
        [cell setCustomer:[_shopDataSource objectAtIndex:indexPath.row]];
    } else {
        [cell setShop:[_shopDataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[ProductManager sharedInstance] getProductType] == kFoods) {
        [self performSegueWithIdentifier:SegueShowOrder sender:self];
    } else {
        Shop *shop = _shopDataSource[_shopTableView.indexPathForSelectedRow.row];
        NSString *shopName = shop.name;
        if([Utils hasReadPermission:shopName]) {
            [self performSegueWithIdentifier:SegueShowOrder sender:self];
        }
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
