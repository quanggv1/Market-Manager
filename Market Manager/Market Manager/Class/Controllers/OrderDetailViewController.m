//
//  OrderDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderProductTableViewCell.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@property (strong, nonatomic) NSMutableArray *productOrderList;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    Product *product1 = [[Product alloc] initWith:@{kProductName:@"potato", kProductOrder:@"3"}];
    _productOrderList = [[NSMutableArray alloc] initWithArray:@[product1, product1, product1]];
    [self download];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
//                 _products = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
//                 [_productTableView reloadData];
             } else {
//                 _products = nil;
//                 [_productTableView reloadData];
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
//             _products = nil;
//             [_productTableView reloadData];
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}


#pragma mark - TABLE DATASOUCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
    cell.product = _productOrderList[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TABLE DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}





@end
