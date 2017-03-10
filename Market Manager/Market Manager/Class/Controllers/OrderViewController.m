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

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) NSMutableArray *orderDataSource;
@property (weak, nonatomic) IBOutlet UITextField *orderSearchTextField;
@end

@implementation OrderViewController{
    NSArray *orderTableDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    [self download];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifyOrderDeletesItem
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = _shop.name;
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
    [_orderTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kShopID:_shop.ID};
    [manager GET:API_GET_ORDERS parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_orderSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _orderSearchTextField.text = date;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date contains %@", date];
    orderTableDataSource = [_orderDataSource filteredArrayUsingPredicate:predicate];
    [_orderTableView reloadData];
}

- (IBAction)onRefreshClicked:(id)sender {
    _orderSearchTextField.text = @"";
    orderTableDataSource = _orderDataSource;
    [_orderTableView reloadData];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [_orderDataSource removeObjectAtIndex:indexPath.row];
    [_orderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self showActivity];
//    Order *order = _orderDataSource[indexPath.row];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *params = @{@"tableName":kOrderTableName,
//                             @"params": @{@"idName":kOrderID,
//                                          @"idValue":Order.ID}};
//    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self hideActivity];
//        [[OrderManager sharedInstance] delete:Order];
//        [_OrderDataSource removeObjectAtIndex:indexPath.row];
//        [_OrderTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self hideActivity];
//    }];
}

#pragma mark - TABLE DATASOURCE
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    [cell initWith: [orderTableDataSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:SegueOrderDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueOrderDetail]) {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.order = orderTableDataSource[_orderTableView.indexPathForSelectedRow.row];
    }
}

@end
