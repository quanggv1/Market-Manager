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
@property (strong, nonatomic) NSMutableArray *orders;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteItem:) name:NotifyOrderDeletesItem object:nil];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_orders removeObjectAtIndex:indexPath.row];
    [_orderTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}


- (void)download {
    Order *order1 = [[Order alloc] initWith:@{@"name":@"order1", @"date":@"2017/02/21"}];
    Order *order2 = [[Order alloc] initWith:@{@"name":@"order2", @"date":@"2017/02/20"}];
    Order *order3 = [[Order alloc] initWith:@{@"name":@"order3", @"date":@"2017/02/19"}];
    Order *order4 = [[Order alloc] initWith:@{@"name":@"order4", @"date":@"2017/02/18"}];
    Order *order5 = [[Order alloc] initWith:@{@"name":@"order5", @"date":@"2017/02/17"}];
    
    _orders = [[NSMutableArray alloc] initWithArray:@[order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5,order1, order2, order3, order4, order5]];
    orderTableDataSource = _orders;
    [_orderTableView reloadData];
    
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    //    [manager GET:@"http://sotayit.com/service/mobile/systemsetting" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"%@", responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        //
    //    }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_orderSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _orderSearchTextField.text = date;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date contains %@", date];
    orderTableDataSource = [_orders filteredArrayUsingPredicate:predicate];
    [_orderTableView reloadData];
}

- (IBAction)onRefreshClicked:(id)sender {
    _orderSearchTextField.text = @"";
    orderTableDataSource = _orders;
    [_orderTableView reloadData];
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

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueOrderDetail]) {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.order = orderTableDataSource[_orderTableView.indexPathForSelectedRow.row];
    }
}

@end
