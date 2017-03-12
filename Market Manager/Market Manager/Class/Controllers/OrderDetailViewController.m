//
//  OrderDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderProductTableViewCell.h"
#import "ProductManager.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, OrderProductDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSMutableArray *productOrderList;
@end

@implementation OrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    [self download];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_order.status == 2) {
        _submitButton.enabled = NO;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"ID: %@ %@", _order.ID, _order.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kOrderID:_order.ID};
    [manager GET:API_GET_ORDER_DETAIL
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 _productOrderList = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
                 [_orderFormTableView reloadData];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgSomethingWhenWrong
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

- (IBAction)onSubmit:(id)sender {
    NSMutableArray *orders = [[NSMutableArray alloc] init];
    for (Product *product in _productOrderList) {
        [orders addObject: @{kWh1: @(product.wh1),
                             kWh2: @(product.wh2),
                             kWhTL: @(product.whTL),
                             kCrateQty: @(product.crateQty),
                             kCrateType: @(product.crateType),
                             kProductOrderID: product.productOrderID,
                             kProductID: product.productId,
                             kProductSTake: @(product.STake)}];
    }
    
    NSDictionary *params = @{kParams: [Utils objectToJsonString:orders],
                             kOrderID: _order.ID,
                             kShopID: _shop.ID};
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_ORDER_DETAIL
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [CallbackAlertView setCallbackTaget:titleSuccess
                                             message:@""
                                              target:self
                                             okTitle:btnOK
                                          okCallback:@selector(onSubmited)
                                         cancelTitle:nil
                                      cancelCallback:nil];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgSomethingWhenWrong
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

- (void)onSubmited {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TABLE DATASOUCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
    cell.product = _productOrderList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TABLE DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)textFieldDidEndEditingFinish:(OrderProductTableViewCell *)cell textField:(UITextField *)textField :(completion)complete{
    NSString *whName;
    if(textField == cell.wh1TextField) {
        whName = @"wh1";
    } else if(textField == cell.wh2TextField) {
        whName = @"wh2";
        
    } else if (textField == cell.whTLTextField) {
        whName = @"wh3";
    }
    [self showActivity];
    NSDictionary *params = @{kParams: @{kSupplyName: whName, kProductID:@"24"
                                        }};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_CHECK_TOTAL_WAREHOUSE_PRODUCTS
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 NSLog(@"response %@", responseObject);
                 complete(YES);
             } else {
                 [CallbackAlertView setCallbackTaget:@"Error"
                                             message:@"Quantity is smaller than total"
                                              target:self
                                             okTitle:@"OK"
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             complete(NO);
             [CallbackAlertView setCallbackTaget:@"Error"
                                         message:@"Can't connect to server"
                                          target:self
                                         okTitle:@"OK"
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

@end
