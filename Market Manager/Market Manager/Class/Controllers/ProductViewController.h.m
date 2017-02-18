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

@interface ProductViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (strong, nonatomic) NSMutableArray *products;
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productTableView.delegate = self;
    _productTableView.dataSource = self;
    [self download];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteItem:) name:NotifyProductDeletesItem object:nil];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_products removeObjectAtIndex:indexPath.row];
    [_productTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}


- (void)download {
    Product *product1 = [[Product alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"product1",@"name", nil]];
    Product *product2 = [[Product alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"product2",@"name", nil]];
    Product *product3 = [[Product alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"product3",@"name", nil]];
    Product *product4 = [[Product alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"product4",@"name", nil]];
    Product *product5 = [[Product alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"product5",@"name", nil]];
    
    _products = [[NSMutableArray alloc] initWithArray:@[product1, product2, product3, product4, product5]];
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

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProduct];
    [cell initWith: [_products objectAtIndex:indexPath.row]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueProductDetail]) {
        ProductDetailViewController *vc = segue.destinationViewController;
        vc.product = _products[_productTableView.indexPathForSelectedRow.row];
    }
}



@end
