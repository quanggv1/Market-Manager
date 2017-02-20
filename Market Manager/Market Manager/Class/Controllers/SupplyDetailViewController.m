//
//  SupplyDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyDetailViewController.h"
#import "Product.h"
#import "ProductCell.h"
#import "ProductDetailViewController.h"

@interface SupplyDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *supplyNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *supplyImageView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UITextField *productSearchTextField;
@property (strong, nonatomic) NSMutableArray *products;
@end

@implementation SupplyDetailViewController{
    NSArray *productTableDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _supplyNameLbl.text = _supply.name;
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

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_products removeObjectAtIndex:indexPath.row];
    productTableDataSource = _products;
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)download {
    Product *product1 = [[Product alloc] initWith:@{@"name":@"product1", @"date":@"2017/02/01"}];
    Product *product2 = [[Product alloc] initWith:@{@"name":@"product2", @"date":@"2017/02/02"}];
    Product *product3 = [[Product alloc] initWith:@{@"name":@"product3", @"date":@"2017/02/02"}];
    Product *product4 = [[Product alloc] initWith:@{@"name":@"product4", @"date":@"2017/02/03"}];
    Product *product5 = [[Product alloc] initWith:@{@"name":@"product5", @"date":@"2017/02/01"}];
    
    _products = [[NSMutableArray alloc] initWithArray:@[product1, product2, product3, product4, product5]];
    productTableDataSource = _products;
    [_productTableView reloadData];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    //    [manager GET:@"http://sotayit.com/service/mobile/systemsetting" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"%@", responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        //
    //    }];
}

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_productSearchTextField.text target:self selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _productSearchTextField.text = date;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date contains %@", date];
    productTableDataSource = [_products filteredArrayUsingPredicate:predicate];
    [_productTableView reloadData];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return productTableDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProduct];
    [cell initWith: [productTableDataSource objectAtIndex:indexPath.row]];
    return cell;
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
        vc.product = _products[_productTableView.indexPathForSelectedRow.row];
    }
}




@end
