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
#import "InvoiceViewController.h"
#import "Data.h"
#import "ShopManager.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView            *orderFormTableView;
@property (weak, nonatomic) IBOutlet UIButton               *submitButton;
@property (weak, nonatomic) IBOutlet UITableView            *productNameTableView;
@property (weak, nonatomic) IBOutlet UICollectionView       *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *orderTableConstraintWidth;
@property (weak, nonatomic) IBOutlet UIPickerView           *productsPicker;
@property (weak, nonatomic) IBOutlet UIView                 *productsPickerView;

@property (strong, nonatomic) NSMutableArray    *products;
@property (strong, nonatomic) NSArray           *shopProducts;
@property (strong, nonatomic) NSMutableArray    *shopProductsNotOrdered;
@end

@implementation OrderDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    _orderFormTableView.dataSource      = self;
    _orderFormTableView.delegate        = self;
    
    _productNameTableView.delegate      = self;
    _productNameTableView.dataSource    = self;
    
    _collectionView.delegate            = self;
    _collectionView.dataSource          = self;
    
    [self download];
    [self titleContents];
    [_collectionView reloadData];
}

- (void)viewWillLayoutSubviews
{
    [_orderTableConstraintWidth setConstant: _collectionView.contentSize.width];
}

- (NSArray *)titleContents
{
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_submitButton setUserInteractionEnabled:([[ProductManager sharedInstance] getProductType] != kFoods)];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _shop.name, _order.date];
}

#pragma mark -- add new product
- (IBAction)onAddClicked:(id)sender
{
    if (!_productNameTableView.hidden) return
    [self getShopProducts];
}

- (void)getShopProducts
{
    if (_shopProducts) {
        [self updateProductPickerDatasource];
    } else {
        [[ShopManager sharedInstance] getShopProductsWithDate:[Utils stringTodayDateTime] shop:_shop success:^(NSArray *products) {
            _shopProducts = products;
            [self updateProductPickerDatasource];
         } error:nil];
    }
}

- (void)updateProductPickerDatasource
{
    _shopProductsNotOrdered = [[NSMutableArray alloc] init];
    for (Product *originProduct in _shopProducts) {
        BOOL isExisted = NO;
        for (NSDictionary *product in _products) {
            if ([originProduct.name isEqualToString: [product objectForKey:kName]]) {
                isExisted = YES;
            }
        }
        if (!isExisted) {
            [_shopProductsNotOrdered addObject:originProduct];
        }
    }
    if (_shopProductsNotOrdered.count == 0) {
        [CallbackAlertView setCallbackTaget:nil message:@"" target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil];
        return;
    }
    [self showProductsWillBeAdded];
}

- (void)showProductsWillBeAdded
{
    [_productsPickerView setHidden: NO];
    [_productsPicker reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _shopProductsNotOrdered.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Product *product = _shopProductsNotOrdered[row];
    return [NSString stringWithFormat:@"%@          %.2f $", product.name, product.price];
}

- (IBAction)onPickerSelected:(id)sender
{
    NSInteger index = [_productsPicker selectedRowInComponent:0];
    Product *product = _shopProductsNotOrdered[index];
    [self addNewOrderDetail: product];
    
}

- (IBAction)onPickerCancel:(id)sender
{
    [_productsPickerView setHidden: YES];
}

- (void)addNewOrderDetail:(Product *)product
{
    NSDictionary *params = @{kParams: @{kOrderID:_order.ID,
                                        kProductID: product.productId}};
    
    [[Data sharedInstance] get:API_ADD_NEW_ORDER_DETAIL data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            NSDictionary *result = [res objectForKey:kData];
            NSMutableDictionary *product = [NSMutableDictionary dictionaryWithDictionary:result];
            [_products addObject:product];
            [_productNameTableView reloadData];
            [_productsPickerView setHidden: YES];
            [_orderFormTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark ---------

- (void)download
{
    NSDictionary *params = @{kOrderID:_order.ID};
    [[Data sharedInstance] get:API_GET_ORDER_DETAIL data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            _products = [[NSMutableArray alloc] init];
            for (NSDictionary *item in [res objectForKey:kData]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:item];
                [_products addObject:dict];
            }
            [_orderFormTableView reloadData];
            [_productNameTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onSubmit:(id)sender
{
    NSDictionary *params = @{kType:@([[ProductManager sharedInstance] getProductType]),
                             kParams: [Utils objectToJsonString:_products],
                             kId: _order.ID,
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
                                          okCallback:nil
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

#pragma mark - TABLE DATASOUCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productNameTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderFormCell"];
        NSString *strIndex = @(indexPath.row + 1).stringValue;
        NSString *strProductName = [_products[indexPath.row] objectForKey:kName];
        ((UILabel *)[cell viewWithTag:201]).text = strIndex;
        ((UILabel *)[cell viewWithTag:202]).text = strProductName;
        return cell;
    } else {
        OrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
        [cell setProductDic: _products[indexPath.row]];
        return cell;
    }
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SCROLLVIEW DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([[ProductManager sharedInstance] getProductType] == kFoods) return 1;
    return _titleContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderDetailTitleCollectionViewCellID" forIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:203]).text = _titleContents[indexPath.row];
    return cell;
}

#pragma mark - SEGUE DELEGATE

@end
