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

@interface ShopDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (strong, nonatomic) NSMutableArray *products;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLbl;
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopNameLbl.text = _shop.name;
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    [self download];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = _shop.name;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProduct:) name:NotifyShopProductUpdate object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateProduct:(NSNotification *)notify {
    NSIndexPath *indexPath = [notify.object objectForKey:@"index"];
    Product *product = [notify.object objectForKey:@"product"];
    [_products replaceObjectAtIndex:indexPath.row withObject:product];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    [_products removeObjectAtIndex:indexPath.row];
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)download {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"date":@"2017-03-01"};
    [manager GET:API_GETSHOP_PRODUCT_LIST parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response %@", responseObject);
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];

    Product *product = [[Product alloc] initWith:@{kProductName:@"Potato", kProductSTake: @"5", kProductID: @"1", kProductPrice: @"5.5"}];
    Product *product2 = [[Product alloc] initWith:@{kProductName:@"Potato", kProductSTake: @"5", kProductID: @"1", kProductPrice: @"5.5"}];
    _products = [[NSMutableArray alloc] initWithArray:@[product, product2, product, product]];
    [_productTableView reloadData];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date contains %@", date];
//    productTableDataSource = [_products filteredArrayUsingPredicate:predicate];
    [_productTableView reloadData];
}

- (IBAction)onRefreshClicked:(id)sender {
    _productSearchTextField.text = @"";
    [_productTableView reloadData];
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
