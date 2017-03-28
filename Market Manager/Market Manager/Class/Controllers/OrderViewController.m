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

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) NSMutableArray *orderDataSource;
@property (weak, nonatomic) IBOutlet UITextField *orderSearchTextField;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifyOrderDeletesItem
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self download];
    self.navigationItem.title = [_shop.name stringByAppendingString:@" Orders"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifyOrderDeletesItem
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_orderDataSource removeObjectAtIndex:indexPath.row];
    [_orderTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                           withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kShopID:_shop.ID};
    [manager GET:API_GET_ORDERS
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
            if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                _orderDataSource = [NSMutableArray arrayWithArray:[[OrderManager sharedInstance] getOrderList:[responseObject objectForKey:kData]]];
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

- (IBAction)addNewOrder:(id)sender {
    if(![Utils hasWritePermission:_shop.name]) return;
    [self showActivity];
    Order *order = [[Order alloc] init];
    order.shopID = _shop.ID;
    order.date = [Utils stringTodayDateTime];
    order.status = kOrderNew;
    NSDictionary *params = @{kParams: @{kShopID: order.shopID,
                                          kDate: order.date,
                                        kStatus: @(order.status)}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_ADD_NEW_ORDER parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                NSDictionary *data = [responseObject objectForKey:kData];
                order.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
                [_orderDataSource insertObject:order atIndex:0];
                [_orderTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                       withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [CallbackAlertView setCallbackTaget:titleError
                                            message:msgAddNewOrderFailed
                                             target:self
                                            okTitle:btnOK
                                         okCallback:nil
                                        cancelTitle:nil
                                     cancelCallback:nil];
            }
            [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Order *order = _orderDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:kOrderTableName,
                             kParams: @{kIdName:kOrderID,
                                        kIdValue:order.ID}};
    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideActivity];
        if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
            [_orderDataSource removeObjectAtIndex:indexPath.row];
            [_orderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    return _orderDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
    [cell setOrder: [_orderDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([Utils hasWritePermission:_shop.name]) {
        Order *order = _orderDataSource[indexPath.row];
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
        if(![Utils hasWritePermission:_shop.name]) return;
        [self deleteItemAt:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueOrderDetail]) {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.order = _orderDataSource[_orderTableView.indexPathForSelectedRow.row];
        vc.shop = _shop;
    } else if([segue.identifier isEqualToString:SegueOrderForm]) {
        OrderFormViewController *vc = segue.destinationViewController;
        vc.order = _orderDataSource[_orderTableView.indexPathForSelectedRow.row];
        vc.shop = _shop;
    }
}

@end
