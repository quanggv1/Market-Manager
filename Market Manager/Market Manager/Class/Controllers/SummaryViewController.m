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
#import "Data.h"

@interface SummaryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *products;
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@end

@implementation SummaryViewController
@synthesize preferredFocusedView = _preferredFocusedView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    [self download];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Report order";
}


#pragma mark - Navigation

- (void)download
{
    NSDictionary *params = @{kOrderID: _order.ID,
                             kType: @([[ProductManager sharedInstance] getProductType])};
    
    [[Data sharedInstance] get:API_REPORT_ORDER_EACHDAY data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            _products = [res objectForKey:kData];
            [_orderFormTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOUCE
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
    [cell setProduct:_products[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
