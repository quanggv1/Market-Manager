//
//  orderManagerViewController.m
//  Market Manager
//
//  Created by Quang on 2/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderViewController.h"
#import "Order.h"
#import "OrderDetailViewController.h"
#import "OrderManager.h"
#import "SummaryViewController.h"
#import "ProductManager.h"
#import "Data.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView    *orderTableView;
@property (weak, nonatomic) IBOutlet UITextField    *orderSearchTextField;

@property (strong, nonatomic) NSMutableArray    *orders;
@property (nonatomic, weak) ProductManager      *productManager;
@property (nonatomic, assign) NSInteger         productType;
@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _orderTableView.delegate        = self;
    _orderTableView.dataSource      = self;
    
    _productManager     = [ProductManager sharedInstance];
    _productType        = [_productManager getProductType];
    
    [self getOrders];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = [_shop.name stringByAppendingString:@" orders"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getOrders
{
    NSDictionary *params = @{kShopID:_shop.ID,
                             kType: @([_productManager getProductType])};

    [[Data sharedInstance] get:API_GET_ORDERS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSArray *orders = [res objectForKey:kData];
            orders = [[OrderManager sharedInstance] getOrderList:orders];
            self.orders = [NSMutableArray arrayWithArray:orders];
            [_orderTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
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

- (IBAction)addNewOrder:(id)sender
{
    if (![Utils hasWritePermission:_shop.name notify:YES]) return;
    
    BOOL isCreatedOrderToday = [self checkCreatedOrderToday];
    
    if (isCreatedOrderToday) {
        [CallbackAlertView setCallbackTaget:@""
                                    message:msgOrderLimited
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return;
    }
    
    [self createOrder];
}

- (void)createOrder
{
    Order *order    = [[Order alloc] init];
    order.shopID    = _shop.ID;
    order.date      = [Utils stringTodayDateTime];
    order.type      = _productType;
    
    NSDictionary *params = @{kParams: @{kShopID: order.shopID,
                                        kDate: order.date,
                                        kType: @(order.type)},
                             kProduct: @(_productType)};
    
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

- (void)deleteItemAt:(NSIndexPath *)indexPath
{
    Order *order            = _orders[indexPath.row];
    NSDictionary *params    = @{kId: order.ID};
    
    [[Data sharedInstance] get:API_REMOVE_ORDER data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [_orders removeObjectAtIndex:indexPath.row];
            [_orderTableView reloadData];;
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    
    UILabel *indexLbl   = [cell viewWithTag:kIndexTag];
    UILabel *dateLbl    = [cell viewWithTag:202];
    NSInteger index     = indexPath.row;
    Order *order        = _orders[index];
    
    [dateLbl setText:order.date];
    [indexLbl setText:@(indexPath.row + 1).stringValue];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([Utils hasWritePermission:_shop.name notify:YES]) {
        [self performSegueWithIdentifier: SegueOrderDetail sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utils hasWritePermission:_shop.name notify:NO];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SegueOrderDetail]) {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.order = _orders[_orderTableView.indexPathForSelectedRow.row];
        vc.shop = _shop;
    }
}

@end
