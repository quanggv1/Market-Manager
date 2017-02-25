//
//  ShopViewController.m
//  Market Manager
//
//  Created by quanggv on 2/16/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopViewController.h"
#import "Shop.h"
#import "ShopTableViewCell.h"
#import "ShopDetailViewController.h"

@interface ShopViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *shops;
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopTableView.delegate = self;
    _shopTableView.dataSource = self;
    [self download];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifyShopDeletesItem
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_shops removeObjectAtIndex:indexPath.row];
    [_shopTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)download {
    Shop *shop1 = [[Shop alloc] initWith:@{@"name":@"shop1"}];
    Shop *shop2 = [[Shop alloc] initWith:@{@"name":@"shop2"}];
    Shop *shop3 = [[Shop alloc] initWith:@{@"name":@"shop3"}];
    Shop *shop4 = [[Shop alloc] initWith:@{@"name":@"shop4"}];
    Shop *shop5 = [[Shop alloc] initWith:@{@"name":@"shop5"}];
    _shops = [[NSMutableArray alloc] initWithArray:@[shop1, shop2, shop3, shop4, shop5]];
    [_shopTableView reloadData];
    
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
    return _shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellShop];
    [cell initWith: [_shops objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:SegueShopDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueShopDetail]) {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = _shops[_shopTableView.indexPathForSelectedRow.row];
    }
}
@end
