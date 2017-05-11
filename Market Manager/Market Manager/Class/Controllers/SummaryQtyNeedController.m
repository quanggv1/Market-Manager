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
#import "Data.h"

@interface SummaryQtyNeedController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;
@property (strong, nonatomic) NSMutableArray *titleList;
@property (strong, nonatomic) NSMutableArray *productList;
@end

@implementation SummaryQtyNeedController {
    NSString *searchDate;
    NSString *today;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    
    _titleCollectionView.dataSource = self;
    _titleCollectionView.delegate = self;
    
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
    
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)downloadWith:(NSString *)date{
    NSDictionary *params = @{kDate: date,
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
    [[Data sharedInstance] get:API_REPORT_SUM_ORDER_EACHDAY data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            _titleList = [NSMutableArray arrayWithArray:[[res objectForKey:kData] objectForKey:@"titles"]];
            _productList = [NSMutableArray arrayWithArray:[[res objectForKey:kData] objectForKey:@"list"]];
            [_productTableView reloadData];
            [_titleCollectionView reloadData];
        } else {
            _productList = nil;
            [_productTableView reloadData];
            ShowMsgUnavaiableData;
        }
    } error:^{
        _productList = nil;
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
    return _productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SummaryQtyNeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSummaryQtyNeed];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
//    cell.productName.text = [NSString stringWithFormat:@"%@",[_products[indexPath.row] objectForKey:@"productName"]];
//    cell.quantityNeed.text = [NSString stringWithFormat:@"%@",[_products[indexPath.row] objectForKey:@"quantity_need"]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - COLLECTIONVIEW DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qtyNeedReportTitleCollectionId" forIndexPath:indexPath];
    UILabel *contentLabel = [cell viewWithTag:kContentTag];
    contentLabel.text = _titleList[indexPath.row];
    return cell;
}
@end
