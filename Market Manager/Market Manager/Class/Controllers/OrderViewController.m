//
//  orderManagerViewController.m
//  Market Manager
//
//  Created by Quang on 2/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderViewController.h"
#import "Order.h"
#import "OrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderManager.h"
#import "OrderFormViewController.h"
#import "SummaryViewController.h"
#import "ProductManager.h"
#import "Data.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) NSMutableArray *orders;
@property (weak, nonatomic) IBOutlet UITextField *orderSearchTextField;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self downloadData];
    self.navigationItem.title = [_shop.name stringByAppendingString:@" orders"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)downloadData
{
    NSDictionary *params = @{kShopID:_shop.ID,
                             kType: @([[ProductManager sharedInstance] getProductType])};

    [[Data sharedInstance] get:API_GET_ORDERS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSArray *orders = [res objectForKey:kData];
            orders = [[OrderManager sharedInstance] getOrderList:orders];
            self.orders = [NSMutableArray arrayWithArray:orders];
            [_orderTableView reloadData];
        } else {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:msgConnectFailed
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        }
    } error:^{
        [CallbackAlertView setCallbackTaget:titleError
                                    message:msgConnectFailed
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    }];
}

- (BOOL)checkCreatedOrderToday
{
    for (Order *order in self.orders) {
        if ([order.date isEqualToString:[Utils stringTodayDateTime]]) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)addNewOrder:(id)sender {
    if (![Utils hasWritePermission:_shop.name notify:YES]) return;
    
    BOOL isCreatedOrderToday = [self checkCreatedOrderToday];
    
    if (isCreatedOrderToday) {
        [CallbackAlertView setCallbackTaget:nil
                                    message:msgOrderLimited
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    } else {
        [self createOrder];
    }
    
}

- (void)createOrder
{
    Order *order = [[Order alloc] init];
    order.shopID = _shop.ID;
    order.date = [Utils stringTodayDateTime];
    order.status = kOrderNew;
    NSDictionary *params = @{kParams: @{kShopID: order.shopID,
                                        kDate: order.date,
                                        kStatus: @(order.status)},
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
    [[Data sharedInstance] get:API_ADD_NEW_ORDER data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == kResSuccess) {
            NSDictionary *data = [res objectForKey:kData];
            order.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
            [_orders insertObject:order atIndex:0];
            [_orderTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Order *order = _orders[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:kOrderTableName,
                             kParams: @{kIdName:kOrderID,
                                        kIdValue:order.ID}};
    [manager GET:API_DELETEDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideActivity];
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [_orders removeObjectAtIndex:indexPath.row];
                 [_orderTableView deleteRowsAtIndexPaths:@[indexPath]
                                        withRowAnimation:UITableViewRowAnimationFade];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgSomethingWhenWrong
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
    [cell setOrder: [_orders objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([Utils hasWritePermission:_shop.name notify:YES]) {
        Order *order = _orders[indexPath.row];
        switch (order.status) {
            case 0:
                [self performSegueWithIdentifier: SegueOrderForm sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier: SegueOrderDetail sender:self];
                break;
            default:
                break;
        }
    }
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueOrderDetail]) {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.order = _orders[_orderTableView.indexPathForSelectedRow.row];
        vc.shop = _shop;
    } else if([segue.identifier isEqualToString:SegueOrderForm]) {
        OrderFormViewController *vc = segue.destinationViewController;
        vc.order = _orders[_orderTableView.indexPathForSelectedRow.row];
        vc.shop = _shop;
    }
}

@end
