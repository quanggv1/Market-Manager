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
#import "Data.h"

@interface SummaryQtyNeedController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *indexTable;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) NSArray *productList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productTableWidthConstraint;
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
    
    _indexTable.dataSource = self;
    _indexTable.delegate = self;
    
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
            _titleList = [[res objectForKey:kData] objectForKey:@"titles"];
            _productList = [[res objectForKey:kData] objectForKey:@"list"];
            [_productTableView reloadData];
            [_titleCollectionView reloadData];
            [_indexTable reloadData];
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

- (IBAction)onCalendarClicked:(id)sender
{
    [Utils showDatePickerWith:_productSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected
{
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

#pragma mark - TABLE DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _productTableView) {
        SummaryQtyNeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSummaryQtyNeed];
        [cell setProductContent:_productList[indexPath.row] titles:_titleList];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qtyNeedReportIndexCellId"];
        UILabel *indexLabel = [cell viewWithTag:kIndexTag];
        indexLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        return cell;
    }
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - COLLECTIONVIEW DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qtyNeedReportTitleCollectionId" forIndexPath:indexPath];
    UILabel *contentLabel = [cell viewWithTag:kContentTag];
    NSString *title = _titleList[indexPath.row];
    title = [self updateTitle:title];
    contentLabel.text = title;
    return cell;
}

- (NSString *)updateTitle:(NSString *)title
{
    if ([title isEqualToString:@"productName"]) {
        return @"Product";
    } else if ([title isEqualToString:@"total"]) {
        return @"Total order";
    } else if ([title isEqualToString:@"stockTake"]) {
        return @"Total S.take";
    } else if ([title isEqualToString:@"marketNeed"]) {
        return @"Market needed";
    } else {
        return title;
    }
}

#pragma mark - SCROLLVIEW DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _titleCollectionView) {
        CGRect frame = _productTableView.frame;
        frame.origin.x = _indexTable.frame.size.width - _titleCollectionView.contentOffset.x;
        _productTableView.frame = frame;
    } else {
        _productTableView.contentOffset = scrollView.contentOffset;
        _indexTable.contentOffset = scrollView.contentOffset;
    }
}

- (void)viewWillLayoutSubviews {
    [_titleCollectionView setContentOffset:CGPointMake(0, 0)];
    [_productTableWidthConstraint setConstant: _titleCollectionView.contentSize.width];
}

@end
