//
//  SupplyDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyDetailViewController.h"
#import "Product.h"
#import "SupplyProductTableViewCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "Data.h"
#import "ShopManager.h"
#import "WhExpectedTableViewCell.h"
#import "SupplyManager.h"
#import "SupplyPalletViewController.h"

@interface SupplyDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView    *productTableView;
@property (weak, nonatomic) IBOutlet UITextField    *productSearchTextField;
@property (nonatomic, weak) IBOutlet UIPickerView   *productsPicker;
@property (nonatomic, weak) IBOutlet UIView         *productsPickerView;
@property (nonatomic, weak) IBOutlet UIView         *stockTakeView;
@property (nonatomic, weak) IBOutlet UIView         *expectedView;
@property (nonatomic, weak) IBOutlet UIButton       *buttonShowExpected;
@property (nonatomic, weak) IBOutlet UIButton       *buttonShowStockTake;

@property (weak, nonatomic) IBOutlet UITableView            *expectedTableView;
@property (weak, nonatomic) IBOutlet UITableView            *productNameTableView;
@property (weak, nonatomic) IBOutlet UICollectionView       *titleCollectionView;

@property (nonatomic, strong) NSMutableArray    *pickerData;
@property (nonatomic, weak) ProductManager      *productManager;
@property (nonatomic, strong) NSMutableArray    *productsExpected;
@property (nonatomic, strong) NSMutableArray    *titleContents;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *whExpectedTableConstraintWidth;
@end

@implementation SupplyDetailViewController {
    NSString *searchDate;
    NSString *today;
}

- (void)viewWillLayoutSubviews
{
    [_whExpectedTableConstraintWidth setConstant: _titleCollectionView.contentSize.width];
}

- (IBAction)onShowExpected:(id)sender
{
    if (_buttonShowExpected.isSelected) return;
    [self showStockTakeView:NO];
}

- (IBAction)onShowStockTake:(id)sender
{
    if (_buttonShowStockTake.isSelected) return;
    [self showStockTakeView:YES];
}

- (void)showStockTakeView:(BOOL)show
{
    _buttonShowExpected.selected     = !show;
    _buttonShowStockTake.selected    = show;
    
    _stockTakeView.hidden   = !show;
    _expectedView.hidden    = show;
    
    [self.navigationItem.rightBarButtonItem setEnabled:show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _productTableView.delegate          = self;
    _productTableView.dataSource        = self;
    _productSearchTextField.delegate    = self;
    _productsPicker.delegate            = self;
    _productsPicker.dataSource          = self;
    
    _productManager = [ProductManager sharedInstance];
    
    today = [[Utils dateFormatter] stringFromDate:[NSDate date]];
    _productSearchTextField.text = today;
    searchDate = today;
    
    [self downloadWith:today];
    [self getTitleContent];
    [self showStockTakeView:YES];
    
    [[SupplyManager sharedInstance] setCurrentWarehouseName:_supply.name];
}

- (void)getTitleContent
{
    _titleContents = [[NSMutableArray alloc] init];
    for (NSString *item in [[ShopManager sharedInstance] getShopNameList]) {
        [_titleContents addObject:item];
    }
    [_titleCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = _supply.name;
}

- (void)deleteItem:(NSNotification *)notificaion
{
    NSIndexPath *indexPath = [notificaion object];
    [_products removeObjectAtIndex:indexPath.row];
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}


- (void)downloadWith:(NSString *)date
{
    NSDictionary *params = @{kWarehouseID:_supply.ID,
                             kDate: date,
                             kWhName: _supply.name,
                             kType: @([[ProductManager sharedInstance] getProductType])};
    
    [[Data sharedInstance] get:API_GET_WAREHOUSE_PRODUCTS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            NSArray *products = [res objectForKey:kData];
            products = [[ProductManager sharedInstance] getWarehouseProductsFromData:products];
            _products = [NSMutableArray arrayWithArray:products];
            [_productTableView reloadData];
        } else {
            _products = nil;
            [_productTableView reloadData];
        }
        [self getProductsExpected:date];
    } error:^{
        _products = nil;
        [_productTableView reloadData];
        ShowMsgConnectFailed;
    }];
}

- (void)getProductsExpected:(NSString *)date
{
    NSDictionary *params = @{kDate: date,
                             kWarehouseID: _supply.ID,
                             kType: @([[ProductManager sharedInstance] getProductType])};
    
    [[Data sharedInstance] get:API_GET_WAREHOUSE_EXPECTED data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == 200) {
            _productsExpected = [[NSMutableArray alloc] init];
            NSArray *products = [res objectForKey:kData];
            for (NSDictionary *item in products) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:item];
                [_productsExpected addObject:dict];
            }
            [_productNameTableView reloadData];
            [_expectedTableView reloadData];
        } else {
            _productsExpected = [[NSMutableArray alloc] init];
            [_productNameTableView reloadData];
            [_expectedTableView reloadData];
        }
    } error:^{
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

- (IBAction)onSaveClicked:(id)sender
{
    if(![Utils hasWritePermission:_supply.name notify:YES]) return;
    if (!_products) return;
    if ([searchDate isEqualToString:today]) {
        
        NSMutableArray *updates = [[NSMutableArray alloc] init];
        for (Product *product in _products) {
            [updates addObject:@{kProductWareHouseID: product.productWhID,
                                 kProductName: product.name,
                                 kProductSTake: @(product.STake),
                                 kWhInQuantity: @(product.inQty),
                                 kWhOutQuantity: @(product.outQty),
                                 kWhTotal: @(product.whTotal)}];
        }
        
        NSDictionary *params = @{kWhName: _supply.name,
                                 kType: @([[ProductManager sharedInstance] getProductType]),
                                 kParams: [Utils objectToJsonString:updates]};
        
        [[Data sharedInstance] get:API_UPDATE_WAREHOUSE_PRODUCTS data:params success:^(id res) {
            if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
                [CallbackAlertView setCallbackTaget:@""
                                            message:@"Data has been saved"
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
}

- (void)deleteItemAt:(NSIndexPath *)indexPath
{
    
    Product *product = _products[indexPath.row];
    
    NSDictionary *params = @{kProductWareHouseID:product.productWhID};
    
    [[Data sharedInstance] get:API_REMOVE_WAREHOUSE_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [_products removeObjectAtIndex:indexPath.row];
            [_productTableView reloadData];
        }
        else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == _productTableView) ? _products.count : _productsExpected.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _productTableView) {
        SupplyProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWarehouseProduct];
        
        UILabel *indexLabel = [cell viewWithTag:kIndexTag];
        [indexLabel setText:@(indexPath.row + 1).stringValue];
        [cell setProduct:_products[indexPath.row]];
        
        return cell;
    } else if (tableView == _productNameTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWarehouseExpectedName];
        
        UILabel *indexLabel = [cell viewWithTag:kIndexTag];
        UILabel *productNameLabel = [cell viewWithTag:kContentTag];
        
        [indexLabel setText: @(indexPath.row + 1).stringValue];
        [productNameLabel setText: [_productsExpected[indexPath.row] objectForKey:kName]];
        
        return cell;
    } else {
        WhExpectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWarehouseExpectedProducts];
        [cell setTheDictionary:_productsExpected[indexPath.row]];
        return cell;
    }
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == _productTableView) {
//        [self performSegueWithIdentifier:@"showProductDetail" sender:self];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView == _productTableView) && [Utils hasWritePermission:_supply.name notify:NO];
}

#pragma mark - COLLECTION DATASOURCE

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellWarehouseExpectedTitleCollection forIndexPath:indexPath];
    
    UILabel *descriptionLabel   = [cell viewWithTag:kContentTag];
    descriptionLabel.text       = _titleContents[indexPath.row];
    
    return cell;
}

#pragma mark - SCROLLVIEW DELEGATE
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _titleCollectionView) {
        CGRect frame = _expectedTableView.frame;
        frame.origin.x = _productNameTableView.frame.size.width - _titleCollectionView.contentOffset.x;
        _expectedTableView.frame = frame;
    } else {
        _expectedTableView.contentOffset = scrollView.contentOffset;
        _productNameTableView.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - Add new products
- (IBAction)onAddClicked:(id)sender
{
    if (![Utils hasWritePermission:_supply.name notify:YES]) return;
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
                                    message:@"Warehouse has already include all products"
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

    
    NSDictionary *params = @{kType:@([[ProductManager sharedInstance] getProductType]),
                             kParams: @{kSupplyID: _supply.ID,
                                        kProductID: product.productId}};

    [[Data sharedInstance] get:API_ADD_NEW_WAREHOUSE_PRODUCT data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == 200) {
            product.productWhID = [NSString stringWithFormat:@"%@", [[res objectForKey:kData] objectForKey:kInsertID]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showProductDetail"]) {
        SupplyPalletViewController *vc = segue.destinationViewController;
        NSInteger index = [_productTableView indexPathForSelectedRow].row;
        Product *product = _products[index];
        vc.wh_pd_ID = product.productWhID;
    }
}

@end
