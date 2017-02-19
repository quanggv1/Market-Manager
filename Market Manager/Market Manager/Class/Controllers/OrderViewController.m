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
@end

@implementation OrderViewController

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
    Order *order1 = [[Order alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"order1",@"name", nil]];
    Order *order2 = [[Order alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"order2",@"name", nil]];
    Order *order3 = [[Order alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"order3",@"name", nil]];
    Order *order4 = [[Order alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"order4",@"name", nil]];
    Order *order5 = [[Order alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"order5",@"name", nil]];
    
    _orders = [[NSMutableArray alloc] initWithArray:@[order1, order2, order3, order4, order5]];
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

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellOrder];
    [cell initWith: [_orders objectAtIndex:indexPath.row]];
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
        vc.order = _orders[_orderTableView.indexPathForSelectedRow.row];
    }
}

@end
