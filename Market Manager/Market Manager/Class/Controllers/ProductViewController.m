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

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UITableView    *productTableView;
@property (nonatomic, weak) IBOutlet UISearchBar    *searchBar;
@property (nonatomic, strong) NSMutableArray        *products;

@property (nonatomic, weak) ProductManager *productManager;
@end

@implementation ProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    _searchBar.delegate = self;
    
    _productManager = [ProductManager sharedInstance];
}

- (NSArray *)getProducts
{
    return [_productManager getProductsWithType:[_productManager getProductType]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = kTitleProduct;
    
    self.products = [NSMutableArray arrayWithArray:[self getProducts]];
    [_productTableView reloadData];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath {
    Product *product = _products[indexPath.row];
    NSDictionary *params = @{kProductID:product.productId};
    
    [[Data sharedInstance] get:API_REMOVE_PRODUCT data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [[ProductManager sharedInstance] delete:product];
            [_products removeObjectAtIndex:indexPath.row];
            [_productTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - SearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [Utils hideKeyboard];
    self.products = [NSMutableArray arrayWithArray:[self getProducts]];
    [_productTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText && searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchText];
        NSArray *originProducts = [self getProducts];
        _products = [NSMutableArray arrayWithArray:[originProducts filteredArrayUsingPredicate:predicate]];
    } else {
        _products = [NSMutableArray arrayWithArray:[self getProducts]];
    }
    [_productTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
#pragma mark ----------------

- (IBAction)onAddNewProduct:(id)sender
{
    if(![Utils hasWritePermission:kProductTableName notify:YES]) return;
    [self performSegueWithIdentifier:SegueProductDetail sender:self];
}


#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProduct];
    UILabel *index = [cell viewWithTag:kIndexTag];
    index.text = @(indexPath.row + 1).stringValue;
    [cell initWith: [_products objectAtIndex:indexPath.row]];
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
            vc.product = _products[_productTableView.indexPathForSelectedRow.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Utils hasWritePermission:kProductTableName notify:NO];
}

@end
