//
//  OrderDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderProductTableViewCell.h"
#import "ProductManager.h"
#import "SupplyManager.h"
#import "SummaryViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSMutableArray *productOrderList;
@property (weak, nonatomic) IBOutlet UITableView *productNameTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTableConstraintWidth;
@end

@implementation OrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    
    _productNameTableView.delegate = self;
    _productNameTableView.dataSource = self;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self download];
    [self titleContents];
    [_collectionView reloadData];
}

- (void)viewWillLayoutSubviews {
    [_orderTableConstraintWidth setConstant: _collectionView.contentSize.width];
}

- (NSArray *)titleContents {
    if(!_titleContents) {
        _titleContents = [[NSMutableArray alloc] init];
        [_titleContents addObject:@"Order"];
        for (NSString *item in [[SupplyManager sharedInstance] getSupplyNameList]) {
            [_titleContents addObject:item];
        }
        [_titleContents addObject:@"Crate Q.ty"];
        [_titleContents addObject:@"Crate Type"];
    }
    return _titleContents;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if(_order.status == 2) {
//        _submitButton.enabled = NO;
//    }
    self.navigationItem.title = [NSString stringWithFormat:@"ID: %@ %@", _order.ID, _order.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kOrderID:_order.ID,
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
    [manager GET:API_GET_ORDER_DETAIL
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 _productOrderList = [[NSMutableArray alloc] init];
                 for (NSDictionary *item in [responseObject objectForKey:kData]) {
                     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:item];
                     [_productOrderList addObject:dict];
                 }
                 [_orderFormTableView reloadData];
                 [_productNameTableView reloadData];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgSomethingWhenWrong
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

- (IBAction)onSubmit:(id)sender {
    NSDictionary *params = @{kProduct:@([[ProductManager sharedInstance] getProductType]),
                             kParams: [Utils objectToJsonString:_productOrderList],
                             kOrderID: _order.ID,
                             kShopID: _shop.ID,
                             @"whNameList": [[SupplyManager sharedInstance] getSupplyNameList]};
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_ORDER_DETAIL
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [CallbackAlertView setCallbackTaget:titleSuccess
                                             message:@""
                                              target:self
                                             okTitle:btnOK
                                          okCallback:@selector(onSubmited)
                                         cancelTitle:nil
                                      cancelCallback:nil];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (void)onSubmited {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onShowReport:(id)sender {
    [self performSegueWithIdentifier: SegueReportOrderForm sender:self];
}


#pragma mark - TABLE DATASOUCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.productNameTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderFormCell"];
        NSString *strIndex = @(indexPath.row + 1).stringValue;
        NSString *strProductName = [_productOrderList[indexPath.row] objectForKey:kProductName];
        ((UILabel *)[cell viewWithTag:201]).text = strIndex;
        ((UILabel *)[cell viewWithTag:202]).text = strProductName;
        return cell;
    } else {
        OrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
        [cell setProductDic: _productOrderList[indexPath.row]];
        return cell;
    }
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SCROLLVIEW DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _collectionView) {
        CGRect frame = _orderFormTableView.frame;
        frame.origin.x = _productNameTableView.frame.size.width - _collectionView.contentOffset.x;
        _orderFormTableView.frame = frame;
    } else {
        _orderFormTableView.contentOffset = scrollView.contentOffset;
        _productNameTableView.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - COLLECTION DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderDetailTitleCollectionViewCellID" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:203]).text = _titleContents[indexPath.row];
    return cell;
}

#pragma mark - SEGUE DELEGATE 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SummaryViewController *vc = segue.destinationViewController;
    vc.order = _order;
}

@end
