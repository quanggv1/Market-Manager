//
//  FunctionListViewController.m
//  Market Manager
//
//  Created by quanggv on 3/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "FunctionListViewController.h"
#import "MenuCell.h"
#import "ProductManager.h"
#import "ShopManager.h"
#import "SupplyManager.h"
#import "CrateManager.h"
#import "Crate.h"

@interface FunctionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *functionsTableView;
@property (nonatomic, strong) NSArray *functionList;
@property (assign, nonatomic) NSInteger numberOfFunction;
@property (weak, nonatomic) IBOutlet UINavigationBar *functionsNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarTitle;

@end

@implementation FunctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
    if([[ProductManager sharedInstance] getProductType] == kVegatables)
        self.navBarTitle.title = @"Vegatables";
    else if([[ProductManager sharedInstance] getProductType] == kMeats)
        self.navBarTitle.title = @"Meats";
    else
        self.navBarTitle.title = @"Foods";
    
    _functionList = @[[[MenuCellProp alloc] initWith:@"Products" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Ware House" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Shop" image:@"ic_store_36pt"],
                      [[MenuCellProp alloc] initWith:@"Market Need" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:kTitleOrderManagement image:@"ic_description_36pt"],
                  [[MenuCellProp alloc] initWith:@"Crate Management" image:@"ic_dns_36pt"]];
    _functionsTableView.delegate = self;
    _functionsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 0) ? 200 : 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _functionList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellFunctionList];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
        [(MenuCell *)cell setMenuWith:[_functionList objectAtIndex:indexPath.row - 1]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 1:
            if(![Utils hasReadPermission:kProductTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardProductNavigation] animated:YES completion:nil];
            break;
        case 2:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardSupplyNavigation] animated:YES completion:nil];
            break;
        case 3:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardShopNavigation] animated:YES completion:nil];
            break;
        case 4:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardReportSummaryQtyNeed] animated:YES completion:nil];
            break;
        case 5:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardOrderNavigation] animated:YES completion:nil];
            break;
        case 6:
            if(![Utils hasReadPermission:kCrateTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardCrateNavigation] animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)getData {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_DATA_DEFAULT
      parameters:@{kProduct: @([[ProductManager sharedInstance] getProductType])}
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 [[CrateManager sharedInstance] setValueWith:[data objectForKey:kCrateTableName]];
                 [[SupplyManager sharedInstance] setValueWith:[data objectForKey:kSupplyTableName]];
                 [[ShopManager sharedInstance] setValueWith:[data objectForKey:kShopTableName]];
                 [[ProductManager sharedInstance] setValueWith:[data objectForKey:kProductTableName]];
             } else {
                 [self showConfirmToBack];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self showConfirmToBack];
             [self hideActivity];
         }];
}

@end
