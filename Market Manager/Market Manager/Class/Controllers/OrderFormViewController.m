//
//  OrderFormViewController.m
//  Market Manager
//
//  Created by Quang on 3/11/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderFormViewController.h"
#import "ProductManager.h"
#import "OrderFormTableViewCell.h"

@interface OrderFormViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *products;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@end

@implementation OrderFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    [self download];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = [NSString stringWithFormat:@"ID: %@ %@", _order.ID, _order.date];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kShopID:_shop.ID,
                             kDate: [Utils stringTodayDateTime],
                             kShopName: _shop.name};
    [manager GET:API_GETSHOP_PRODUCTS
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 _products = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
                 [_productTableView reloadData];
             } else {
                 _products = nil;
                 [_productTableView reloadData];
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
            _products = nil;
            [_productTableView reloadData];
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
    for (Product *product in _products) {
        if(product.order > 0) {
            [orders addObject:@{kProductID: product.productId,
                                kOrderQty: @(product.order),
                                kProductSTake: @(product.STake),
                                kOrderID: _order.ID}];
        }
    }
    if(orders.count == 0) {
        [CallbackAlertView setCallbackTaget:titleError
                                    message:@"Order form is empty"
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return;
    }

    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kParams:[self objectToJson:orders],
                             kOrderID: _order.ID};
    [manager GET:API_ADD_NEW_ORDER
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
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

-(NSString *)objectToJson:(id )object
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    return  [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellNewOrder];
    [cell setProduct:_products[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated:NO];
}




@end
