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
#import "AddNewShopProductViewController.h"

@interface ShopDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLbl;
@end

@implementation ShopDetailViewController {
    NSString *searchDate;
    NSString *today;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopNameLbl.text = _shop.name;
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    today = [[Utils dateFormatter] stringFromDate:[NSDate date]];
    _productSearchTextField.text = today;
    searchDate = today;
    [self downloadWith:today];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear :animated];
    self.navigationItem.title = _shop.name;
}

- (IBAction)addNewProduct:(id)sender {
    [AddNewShopProductViewController showViewAt:self onSave:^(Product *product) {
        [_products insertObject:product atIndex:0];
        [_productTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [self showActivity];
    Product *product = _products[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":kShopProductTableName,
                             @"params": @{@"idName":kShopProductID,
                                          @"idValue":product.shopProductID}};
    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:kCode] integerValue] == 200) {
            [_products removeObjectAtIndex:indexPath.row];
            [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                     withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        }
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadWith:(NSString *) stringDate{
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kShopID:_shop.ID, kDate: stringDate, kShopName: _shop.name};
    [manager GET:API_GETSHOP_PRODUCT_LIST
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             
            if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                _products = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductListWith:[responseObject objectForKey:kData]]];
                [_productTableView reloadData];
            } else {
                _products = nil;
                [_productTableView reloadData];
                [CallbackAlertView setCallbackTaget:titleError
                                            message:@"Unavaiable data for this day"
                                             target:self
                                            okTitle:btnOK
                                         okCallback:nil
                                        cancelTitle:nil
                                     cancelCallback:nil];
            }
            [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
            [self hideActivity];
            _products = nil;
            [_productTableView reloadData];
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"Can't connect to server"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
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

- (IBAction)onRefreshClicked:(id)sender {
    _productSearchTextField.text = @"";
    [_productTableView reloadData];
}

- (IBAction)onExport:(id)sender {
    if (!_products) return;
    if ([searchDate isEqualToString:today]) {
        [self showActivity];
        NSMutableArray *updates = [[NSMutableArray alloc] init];
        for (Product *product in _products) {
            [updates addObject:@{kShopProductID: product.shopProductID, kProductSTake: @(product.STake)}];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{kShopName:_shop.name, kShopID: _shop.ID, kDate: searchDate, @"params":updates};
        [manager GET:API_EXPORT_SHOP_PRODUCTS parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                [CallbackAlertView setCallbackTaget:@"Successfully!" message:@"Exported" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
            } else {
                [CallbackAlertView setCallbackTaget:@"Error" message:@"Export failed!" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
            }
            [self hideActivity];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideActivity];
            [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        }];
    } else {
        [CallbackAlertView setCallbackTaget:@"Message" message:@"This record has been exported!" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }
}

#pragma mark - TABLE DATASOURCE
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShopProduct];
    [cell setProduct:_products[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:SegueProductDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueProductDetail]) {
        ProductDetailViewController *vc = segue.destinationViewController;
        vc.product = _products[_productTableView.indexPathForSelectedRow.row];
    }
}


@end
