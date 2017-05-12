//
//  SupplyDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyDetailViewController.h"
#import "Product.h"
#import "SupplyProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "AddNewSupplyProductViewController.h"

@interface SupplyDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@end

@implementation SupplyDetailViewController {
    NSString *searchDate;
    NSString *today;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    today = [[Utils dateFormatter] stringFromDate:[NSDate date]];
    _productSearchTextField.text = today;
    searchDate = today;
    [self downloadWith:today];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = _supply.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_products removeObjectAtIndex:indexPath.row];
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)downloadWith:(NSString *)date{
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kWarehouseID:_supply.ID,
                             kDate: date,
                             kWhName: _supply.name,
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
    [manager GET:API_GET_WAREHOUSE_PRODUCTS
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 _products = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
                 
                 [_productTableView reloadData];
             } else {
                 _products = nil;
                 [_productTableView reloadData];
                 ShowMsgUnavaiableData;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             _products = nil;
             [_productTableView reloadData];
             ShowMsgConnectFailed;
         }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

- (IBAction)addNewProduct:(id)sender {
    if(![Utils hasWritePermission:_supply.name notify:YES]) return;
    [AddNewSupplyProductViewController showViewAt:self onSave:^(Product *product) {
        [_products addObject:product];
        [_productTableView reloadData];
    }];
}

- (IBAction)onExportClicked:(id)sender {

}

- (IBAction)onSaveClicked:(id)sender {
    if(![Utils hasWritePermission:_supply.name notify:YES]) return;
    if (!_products) return;
    if ([searchDate isEqualToString:today]) {
        [self showActivity];
        NSMutableArray *updates = [[NSMutableArray alloc] init];
        for (Product *product in _products) {
            [updates addObject:@{kProductWareHouseID: product.productWhID,
                                 kProductName: product.name,
                                 kProductSTake: @(product.STake),
                                 kWhInQuantity: @(product.inQty),
                                 kWhOutQuantity: @(product.outQty),
                                 kWhTotal: @(product.whTotal)}];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:API_UPDATE_WAREHOUSE_PRODUCTS
          parameters:@{kWhName: _supply.name,
                       kProduct: @([[ProductManager sharedInstance] getProductType]),
                       kParams: [Utils objectToJsonString:updates]}
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                     [CallbackAlertView setCallbackTaget:@""
                                                 message:@"Data has been saved"
                                                  target:self
                                                 okTitle:btnOK
                                              okCallback:nil
                                             cancelTitle:nil
                                          cancelCallback:nil];
                 } else {
                     ShowMsgSomethingWhenWrong;
                 }
                 [self hideActivity];
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self hideActivity];
                 ShowMsgConnectFailed;
        }];
    }
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Product *product = _products[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kProduct:@([[ProductManager sharedInstance] getProductType]),
                             kProductWareHouseID:product.productWhID};
    [manager GET:API_REMOVE_WAREHOUSE_PRODUCT
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [_products removeObjectAtIndex:indexPath.row];
                 [_productTableView reloadData];
             }
             else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

#pragma mark - TABLE DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupplyProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWarehouseProduct];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
    [cell setProduct:_products[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils hasWritePermission:_supply.name notify:NO];
}

@end
