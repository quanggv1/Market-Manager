//
//  ShopDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "Product.h"
#import "ShopProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "Data.h"
#import "ShopManager.h"

@interface ShopDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView    *productTableView;
@property (weak, nonatomic) IBOutlet UITextField    *productSearchTextField;
@property (weak, nonatomic) IBOutlet UIPickerView   *productsPicker;
@property (weak, nonatomic) IBOutlet UIView         *productsPickerView;
@property (strong, nonatomic) NSMutableArray *pickerData;
@property (weak, nonatomic) ProductManager *productManager;
@end

@implementation ShopDetailViewController
{
    NSString *searchDate;
    NSString *today;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _productManager = [ProductManager sharedInstance];
    
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    _productsPicker.delegate = self;
    _productsPicker.dataSource = self;
    
    today = [[Utils dateFormatter] stringFromDate:[NSDate date]];
    _productSearchTextField.text = today;
    searchDate = today;
    [self downloadWith:today];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear :animated];
    self.navigationItem.title = _shop.name;
}

- (void)deleteItemAt:(NSIndexPath *)indexPath
{
    Product *product = _products[indexPath.row];
    NSDictionary *params = @{kId: product.shopProductID};
    
    [[Data sharedInstance] get:API_REMOVE_SHOP_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [_products removeObjectAtIndex:indexPath.row];
            [_productTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)downloadWith:(NSString *)stringDate
{
    [[ShopManager sharedInstance] getShopProductsWithDate:stringDate shop:_shop success:^(NSArray *products) {
        _products = [NSMutableArray arrayWithArray:products];
        [_productTableView reloadData];
    } error:^{
        _products = nil;
        [_productTableView reloadData];
    }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text
                       target:self
                     selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

- (IBAction)onSaveClicked:(id)sender {
    
    if (![Utils hasWritePermission:_shop.name notify:YES]) return;
    if (![searchDate isEqualToString:today]) return;
    
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    for (Product *product in _products) {
        [updates addObject:@{kId: product.shopProductID,
                             kName: product.name,
                             kProductSTake: @(product.STake)}];
    }
    
    NSDictionary *params = @{kShopName:_shop.name,
                             kProduct: @([[ProductManager sharedInstance] getProductType]),
                             kParams: [Utils objectToJsonString:updates]};
    
    [[Data sharedInstance] get:API_UPDATE_SHOP_PRODUCTS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            [CallbackAlertView setCallbackTaget:@""
                                        message:@"Data has been saved!"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShopProduct];
    ((UILabel *)[cell viewWithTag:201]).text = @(indexPath.row + 1).stringValue;
    [cell setProduct:_products[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils hasWritePermission:_shop.name notify:NO];
}

#pragma mark - Add new products
- (IBAction)onAddClicked:(id)sender
{
    if (![Utils hasWritePermission:_shop.name notify:YES]) return;
    if (![searchDate isEqualToString:today]) return;
    
    _pickerData = [[NSMutableArray alloc] init];
    NSArray *allProducts = [_productManager getProductsWithType:[_productManager getProductType]];
    for (Product *originProduct in allProducts) {
        BOOL isExisted = NO;
        for (Product *product in _products) {
            if ([originProduct.name isEqualToString: product.name]) {
                isExisted = YES;
            }
        }
        if (!isExisted) {
            [_pickerData addObject:originProduct];
        }
    }
    if (_pickerData.count > 0) {
        [_productsPicker reloadAllComponents];
        [_productsPickerView setHidden:NO];
    } else {
        [CallbackAlertView setCallbackTaget:@""
                                    message:@"Shop has already include all products"
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Product *product = _pickerData[row];
    return [NSString stringWithFormat:@"%@          %.2f $", product.name, product.price];
}

- (IBAction)onPickerSelected:(id)sender
{
    Product *product = _pickerData[[_productsPicker selectedRowInComponent:0]];
    
    NSDictionary *params = @{kType: @([[ProductManager sharedInstance] getProductType]),
                             kParams: @{kShopID: _shop.ID,
                                        kProductID: product.productId}};
    
    [[Data sharedInstance] get:API_ADD_NEW_SHOP_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == 200) {
            product.shopProductID = [NSString stringWithFormat:@"%@", [[res objectForKey:kData] objectForKey:kInsertID]];
            [_products insertObject:product atIndex:0];
            [_productTableView reloadData];
            [_productsPickerView setHidden:YES];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onPickerCancel:(id)sender
{
    [_productsPickerView setHidden:YES];
}


@end
