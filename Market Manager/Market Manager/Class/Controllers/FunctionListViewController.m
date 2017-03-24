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
//    
//    [self.functionsNavigationBar setBackgroundImage:[UIImage imageNamed:@"market.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    if([[ProductManager sharedInstance] getProductType] == kVegatables)
        self.navBarTitle.title = @"Vegatables";
    else
        self.navBarTitle.title = @"Meats";
    
    _functionList = @[[[MenuCellProp alloc] initWith:@"Products" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Ware House" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Shop" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:kTitleOrderManagement image:@"ic_description_36pt"],
                  [[MenuCellProp alloc] initWith:@"Crate Management" image:@"ic_dns_36pt"]];
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
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardOrderNavigation] animated:YES completion:nil];;
            break;
        case 4:
            if(![Utils hasReadPermission:kCrateTableName]) return;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:StoryboardCrateNavigation] animated:YES completion:nil];
            break;
        default:
            break;
    }
}
@end
