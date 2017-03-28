//
//  SupplyDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SummaryQtyNeedController.h"
#import "Product.h"
#import "SummaryQtyNeedTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "AddNewSupplyProductViewController.h"

@interface SummaryQtyNeedController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@end

@implementation SummaryQtyNeedController {
    NSString *searchDate;
    NSString *today;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    today = [[Utils dateFormatter] stringFromDate:[NSDate date]];
    _productSearchTextField.text = today;
    searchDate = today;
    [self downloadWith:today];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_products removeObjectAtIndex:indexPath.row];
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)downloadWith:(NSString *)date{
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             kDate: date
                             };
    [manager GET:API_REPORT_SUM_ORDER_EACHDAY
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 _products = [NSMutableArray arrayWithArray:[responseObject objectForKey:kData]];
                 [_productTableView reloadData];
             } else {
                 _products = nil;
                 [_productTableView reloadData];
                 ShowMsgUnavaiableData;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             _products = nil;
             [_productTableView reloadData];
             ShowMsgConnectFailed;
         }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

#pragma mark - TABLE DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SummaryQtyNeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSummaryQtyNeed];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
    cell.productName.text = [NSString stringWithFormat:@"%@",[_products[indexPath.row] objectForKey:@"productName"]];
    cell.quantityNeed.text = [NSString stringWithFormat:@"%@",[_products[indexPath.row] objectForKey:@"quantity_need"]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end
