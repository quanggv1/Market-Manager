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
#import "SupplyManager.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, OrderProductDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSMutableArray *productOrderList;
@property (weak, nonatomic) IBOutlet UITableView *productNameTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation OrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    
    _productNameTableView.delegate = self;
    _productNameTableView.dataSource = self;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self download];
    [self titleContents];
    [_collectionView reloadData];
}

- (void)viewWillLayoutSubviews {
    CGRect frame = _orderFormTableView.frame;
    frame.size.width = 70*self.titleContents.count;
    _orderFormTableView.frame = frame;
}

- (NSArray *)titleContents {
    if(!_titleContents) {
        _titleContents = [[NSMutableArray alloc] init];
        [_titleContents addObject:@"Order"];
        for (NSString *item in [[SupplyManager sharedInstance] getSupplyNameList]) {
            [_titleContents addObject:item];
        }
        [_titleContents addObject:@"Crate Q.ty"];
        [_titleContents addObject:@"Crate Type"];
    }
    return _titleContents;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if(_order.status == 2) {
//        _submitButton.enabled = NO;
//    }
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
                 [_productNameTableView reloadData];
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
    if (tableView == self.productNameTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderFormCell"];
        ((UILabel *)[cell viewWithTag:202]).text = ((Product *)_productOrderList[indexPath.row]).name;
        return cell;
    } else {
        OrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
        cell.product = _productOrderList[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _collectionView) {
        CGRect frame = _orderFormTableView.frame;
        frame.origin.x = _productNameTableView.frame.size.width - _collectionView.contentOffset.x;
        _orderFormTableView.frame = frame;
    } else {
        _orderFormTableView.contentOffset = scrollView.contentOffset;
        _productNameTableView.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - COLLECTION DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderDetailTitleCollectionViewCellID" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:203]).text = _titleContents[indexPath.row];
    return cell;
}

@end
