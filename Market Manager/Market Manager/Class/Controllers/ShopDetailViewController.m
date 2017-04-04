//
//  ShopDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "Product.h"
#import "ShopProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "AddNewShopProductViewController.h"

@interface ShopDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@end

@implementation ShopDetailViewController {
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
    [super viewWillAppear :animated];
    self.navigationItem.title = _shop.name;
}

- (IBAction)addNewProduct:(id)sender {
    if(![Utils hasWritePermission:_shop.name notify:YES]) return;
    [AddNewShopProductViewController showViewAt:self onSave:^(Product *product) {
        [_products insertObject:product atIndex:0];
        [_productTableView reloadData];
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Product *product = _products[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType]),
                             kShopProductID: product.shopProductID};
    [manager GET:API_REMOVE_SHOP_PRODUCT
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [_products removeObjectAtIndex:indexPath.row];
                 [_productTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (void)downloadWith:(NSString *)stringDate{
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kShopID:_shop.ID,
                             kDate: stringDate,
                             kShopName: _shop.name,
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
    [manager GET:API_GETSHOP_PRODUCTS
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
            if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                _products = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
            } else {
                _products = nil;
                ShowMsgUnavaiableData;
            }
            [_productTableView reloadData];
            [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [self hideActivity];
            _products = nil;
            [_productTableView reloadData];
            ShowMsgConnectFailed;
        }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text
                       target:self
                     selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

- (IBAction)onSaveClicked:(id)sender {
    if (![Utils hasWritePermission:_shop.name notify:YES]) return;
    if (![searchDate isEqualToString:today]) return;
    [self showActivity];
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    for (Product *product in _products) {
        [updates addObject:@{kShopProductID: product.shopProductID,
                             kProductName: product.name,
                             kProductSTake: @(product.STake)}];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_SHOP_PRODUCTS
      parameters:@{kShopName:_shop.name,
                   kProduct: @([[ProductManager sharedInstance] getProductType]),
                   kParams: [Utils objectToJsonString:updates]}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 [CallbackAlertView setCallbackTaget:@""
                                             message:@"Data has been saved!"
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

#pragma mark - TABLE DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShopProduct];
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
    return [Utils hasWritePermission:_shop.name notify:NO];
}


@end
