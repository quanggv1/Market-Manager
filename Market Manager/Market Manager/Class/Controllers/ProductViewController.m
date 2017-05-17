//
//  CommodityViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 2/15/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductViewController.h"
#import "Product.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"
#import "ProductManager.h"
#import "Data.h"

@interface ProductViewController ()
<UITableViewDelegate,
    UITableViewDataSource,
    UIPopoverPresentationControllerDelegate,
    UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (strong, nonatomic) NSMutableArray *productTableDataSource;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _productSearchTextField.delegate = self;
    [self download];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.productTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(reload)
                  forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    [_productSearchTextField addTarget:self
                                action:@selector(searchByName)
                      forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reload {
    [self download];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = kTitleProduct;
    [self reloadProductTableView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    Product *productDeleted = _productTableDataSource[indexPath.row];
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType]),
                             kProductID:productDeleted.productId};
    
    [[Data sharedInstance] get:API_REMOVE_PRODUCT data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [[ProductManager sharedInstance] delete:productDeleted];
            [_productTableDataSource removeObjectAtIndex:indexPath.row];
            [_productTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)searchByName{
    NSString *searchString = _productSearchTextField.text;
    if(searchString && searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchString];
        NSArray *products = [[ProductManager sharedInstance] getProductList];
        _productTableDataSource = [NSMutableArray arrayWithArray:[products filteredArrayUsingPredicate:predicate]];
        [_productTableView reloadData];
    } else {
        [self reloadProductTableView];
    }
}

- (void)reloadProductTableView {
    NSArray *products = [[ProductManager sharedInstance] getProductList];
    _productTableDataSource = [NSMutableArray arrayWithArray:products];
    [_productTableView reloadData];
}

- (IBAction)onSearch:(id)sender {
    [_productSearchTextField becomeFirstResponder];
}

- (IBAction)onRefreshClicked:(id)sender {
    [Utils hideKeyboard];
    _productSearchTextField.text = @"";
    [self reloadProductTableView];
}

- (IBAction)onAddNewProduct:(id)sender {
    if(![Utils hasWritePermission:kProductTableName notify:YES]) return;
    [self performSegueWithIdentifier:SegueProductDetail sender:self];
}

- (void)download {
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType])};
    [[Data sharedInstance] get:API_GET_PRODUCTS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSArray *products = [res objectForKey:kData];
            [[ProductManager sharedInstance] setValueWith:products];
            products = [[ProductManager sharedInstance] getProductList];
            _productTableDataSource = [[NSMutableArray alloc] initWithArray:products];
        } else {
            _productTableDataSource = nil;
            ShowMsgSomethingWhenWrong;
        }
        [self.refreshControl endRefreshing];
        [_productTableView reloadData];
    } error:^{
        [self.refreshControl endRefreshing];
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProduct];
    UILabel *index = [cell viewWithTag:201];
    index.text = @(indexPath.row + 1).stringValue;
    [cell initWith: [_productTableDataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SegueProductDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueProductDetail]) {
        ProductDetailViewController *vc = segue.destinationViewController;
        if(_productTableView.indexPathForSelectedRow) {
            vc.product = _productTableDataSource[_productTableView.indexPathForSelectedRow.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils hasWritePermission:kProductTableName notify:NO];
}

@end
