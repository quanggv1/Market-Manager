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
#import "OrderTableViewCell.h"
#import "InvoiceViewController.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView    *orderTableView;
@property (weak, nonatomic) IBOutlet UITextField    *orderSearchTextField;

@property (nonatomic, strong)   NSMutableArray      *orders;
@property (nonatomic, weak)     ProductManager      *productManager;
@property (nonatomic, assign)   NSInteger           productType;
@property (nonatomic, weak)     Order               *orderSelected;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderDetail:) name:NotifyShowOrderDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderReport:) name:NotifyShowOrderReport object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderInvoice:) name:NotifyShowOrderInvoice object:nil];
}

- (void)showOrderDetail:(NSNotification *)object
{
    _orderSelected = [object object];
    if([Utils hasWritePermission:_shop.name notify:YES]) {
        [self performSegueWithIdentifier: SegueOrderDetail sender:self];
    }
}

- (void)showOrderReport:(NSNotification *)object
{
    _orderSelected = [object object];
    if([Utils hasWritePermission:_shop.name notify:YES]) {
        [self performSegueWithIdentifier: SegueReportOrderForm sender:self];
    }
}

- (void)showOrderInvoice:(NSNotification *)object
{
    _orderSelected = [object object];
    if([Utils hasWritePermission:_shop.name notify:YES]) {
        [self performSegueWithIdentifier: SegueInvoiceOrderForm sender:self];
    }
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
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    
    UILabel *indexLbl   = [cell viewWithTag:kIndexTag];
    UILabel *dateLbl    = [cell viewWithTag:202];
    NSInteger index     = indexPath.row;
    Order *order        = _orders[index];
    
    [dateLbl setText:order.date];
    [indexLbl setText:@(indexPath.row + 1).stringValue];
    
    [cell setOrder:order];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        vc.order = _orderSelected;
        vc.shop = _shop;
    } else if([segue.identifier isEqualToString:SegueInvoiceOrderForm]) {
        InvoiceViewController *invoice = segue.destinationViewController;
        invoice.order = _orderSelected;
    } else {
        SummaryViewController *vc = segue.destinationViewController;
        vc.order = _orderSelected;
    }
}

@end
