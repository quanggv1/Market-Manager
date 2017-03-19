//
//  SummaryViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 3/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SummaryViewController.h"
#import "ProductManager.h"
#import "SummaryTableViewCell.h"
#import "InvoiceViewController.h"
@interface SummaryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *productOrderList;
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
- (IBAction)gotoInvoice:(id)sender;


@end

@implementation SummaryViewController
@synthesize preferredFocusedView = _preferredFocusedView;
- (void)viewDidLoad {
    [super viewDidLoad];
    _productOrderList = [NSMutableArray new];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    [self download];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Report order";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueInvoiceOrderForm]) {
        InvoiceViewController *invoice = segue.destinationViewController;
        invoice.order = self.order;
    }
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kOrderID:_order.ID};
    [manager GET:API_REPORT_ORDER_EACHDAY
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
#pragma mark - TABLE DATASOUCE
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
    cell.product = _productOrderList[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (IBAction)gotoInvoice:(id)sender {
    [self performSegueWithIdentifier:SegueInvoiceOrderForm sender:self];
}
@end
