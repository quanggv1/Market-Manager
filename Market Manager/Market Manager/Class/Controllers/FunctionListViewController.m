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
    
    self.navBarTitle.title = [Utils getTitle];
    
    _functionList = [Utils getFunctionList];
    _functionsTableView.delegate = self;
    _functionsTableView.dataSource = self;
    _functionsTableView.rowHeight = UITableViewAutomaticDimension;
    _functionsTableView.estimatedRowHeight = 80;
    
    [_functionsTableView setContentInset:UIEdgeInsetsMake(220, 0, 0, 0)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _functionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
    [cell setMenuWith:[_functionList objectAtIndex:indexPath.row]];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            if(![Utils hasReadPermission:kProductTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardProductNavigation] animated:YES completion:nil];
            break;
        case 1:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardSupplyNavigation] animated:YES completion:nil];
            break;
        case 2:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardShopNavigation] animated:YES completion:nil];
            break;
        case 3:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardReportSummaryQtyNeed] animated:YES completion:nil];
            break;
        case 4:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardOrderNavigation] animated:YES completion:nil];
            break;

        case 5:
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
