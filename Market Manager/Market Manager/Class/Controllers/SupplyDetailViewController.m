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
                             kWhName: _supply.name};
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
    [AddNewSupplyProductViewController showViewAt:self onSave:^(Product *product) {
        [_products insertObject:product atIndex:0];
        [_productTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (IBAction)onExportClicked:(id)sender {
    [CallbackAlertView setCallbackTaget:@"Message"
                                message:@"After export, your data will be refreshed. Are you sure to continue?"
                                 target:self
                                okTitle:@"OK"
                             okCallback:@selector(export)
                            cancelTitle:@"Cancel"
                         cancelCallback:nil];
}

- (void)export {
    if (!_products) return;
    if ([searchDate isEqualToString:today]) {
        [self showActivity];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:API_EXPORT_WAREHOUSE_PRODUCTS
          parameters:@{kWarehouseID:_supply.ID, kWhName: _supply.name}
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                     [self refreshData];
                     [self onSaveClicked:nil];
                 } else {
                     [self hideActivity];
                     ShowMsgSomethingWhenWrong;
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self hideActivity];
                 ShowMsgConnectFailed;
             }];
    } else {
        [CallbackAlertView setCallbackTaget:@"Message"
                                    message:@"This record has been exported!"
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    }
}

- (void)refreshData {
    for (Product *product in _products) {
        product.STake = product.whTotal;
        product.inQty = 0;
        product.outQty = 0;
    }
    [_productTableView reloadData];
}

- (IBAction)onSaveClicked:(id)sender {
    if (!_products) return;
    if ([searchDate isEqualToString:today]) {
        [self showActivity];
        NSMutableArray *updates = [[NSMutableArray alloc] init];
        for (Product *product in _products) {
            [updates addObject:@{kProductWareHouseID: product.productWhID,
                                 kProductSTake: @(product.STake),
                                 kWhInQuantity: @(product.inQty),
                                 kWhOutQuantity: @(product.outQty),
                                 kWhTotal: @(product.whTotal)}];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:API_UPDATE_WAREHOUSE_PRODUCTS
          parameters:@{kParams: [Utils objectToJsonString:updates]}
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                     [CallbackAlertView setCallbackTaget:titleSuccess
                                                 message:@"Saved"
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
    } else {
        [CallbackAlertView setCallbackTaget:@"Message"
                                    message:@"This record has been saved!"
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    }
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
//    [self performSegueWithIdentifier:SegueProductDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueProductDetail]) {
        ProductDetailViewController *vc = segue.destinationViewController;
        vc.product = _products[_productTableView.indexPathForSelectedRow.row];
    }
}




@end
