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

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifyProductDeletesItem
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    Product *productDeleted = _productTableDataSource[indexPath.row];
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":@"product",
                             @"params": @{@"idName":[NSString stringWithFormat:@"%ld", productDeleted.productId],
                                          @"idValue":@"1"}};
    [manager GET:@"http://localhost:5000/deleteData" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideActivity];
        [[ProductManager sharedInstance] delete:productDeleted];
        [_productTableDataSource removeObjectAtIndex:indexPath.row];
        [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
    }];
}

- (void)searchByName:(NSString* )name {
    if(name && name.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains %@", name];
        _productTableDataSource = [NSMutableArray arrayWithArray:[[[ProductManager sharedInstance] getProductList] filteredArrayUsingPredicate:predicate]];
    } else {
        _productTableDataSource = [NSMutableArray arrayWithArray:[[ProductManager sharedInstance] getProductList]];
    }
    [_productTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (IBAction)onSearch:(id)sender {
    [Utils hideKeyboard];
    [self searchByName:[_productSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

- (IBAction)onRefreshClicked:(id)sender {
    [Utils hideKeyboard];
    _productSearchTextField.text = @"";
    [self searchByName:@""];
}

- (IBAction)onAddNewProduct:(id)sender {
    [self showActivity];
//    Product *newProduct = [Product alloc] initWith:@{@"productName":@"kakak",
//                                                     @"price":@"134004",
//                                                     @"description": @"test description"}
    NSDictionary *params = @{@"tableName":@"product",
                             @"params": @{@"productName":@"kakak",
                                          @"price":@"134004",
                                          @"description": @"test description"}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://localhost:5000/insertData" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self hideActivity];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self hideActivity];
            }];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"tableName":@"product"};
    [manager GET:@"http://localhost:5000/getData" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[ProductManager sharedInstance] setValueWith:responseObject];
        _productTableDataSource = [[NSMutableArray alloc] initWithArray:[[ProductManager sharedInstance] getProductList]];
        [_productTableView reloadData];
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
    }];

    
//    [manager GET:@"http://localhost:5000/updateData" parameters:@{@"tableName":@"product", @"params": @{@"productID":@"1", @"description": @"test description"}} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //
//    }];
    
//    [manager GET:@"http://localhost:5000/insertData" parameters:@{@"tableName":@"product", @"params": @{@"productName":@"kakak",@"price":@"134004", @"description": @"test description"}} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //
//    }];
    
//    [manager GET:@"http://localhost:5000/deleteData" parameters:@{@"tableName":@"product", @"params": @{@"idName":@"productID",@"idValue":@"1",@"price":@"134004", @"description": @"test description"}} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //
//    }];
//

}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProduct];
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

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueProductDetail]) {
        ProductDetailViewController *vc = segue.destinationViewController;
        vc.product = _productTableDataSource[_productTableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - TEXTFIELD DELEGATE
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self searchByName:[_productSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

@end
