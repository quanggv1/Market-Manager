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
#import "Data.h"

@interface FunctionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray       *functionList;
@property (assign, nonatomic) NSInteger     numberOfFunction;
@property (weak, nonatomic) IBOutlet UINavigationBar    *functionsNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem   *navBarTitle;
@property (weak, nonatomic) IBOutlet UIImageView        *banner;
@property (weak, nonatomic) IBOutlet UITableView        *functionsTableView;
@end

@implementation FunctionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    
    _functionList = [Utils getFunctionList];
    _functionsTableView.delegate = self;
    _functionsTableView.dataSource = self;
    [_banner setImage:[Utils getBanner]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = [Utils getTitle];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
    [cell setMenuWith:_functionList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MenuCell *cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cellSelected.menuTitle.text;
    [Utils showDetailBy:title at:self];
}

- (void)getData {
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType])};
    [[Data sharedInstance] get:API_GET_DATA_DEFAULT
                          data:params
                       success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSDictionary *data = [res objectForKey:kData];
            [[CrateManager sharedInstance] setValueWith:[data objectForKey:kCrateTableName]];
            [[SupplyManager sharedInstance] setValueWith:[data objectForKey:kSupplyTableName]];
            [[ShopManager sharedInstance] setValueWith:[data objectForKey:kShopTableName]];
            [[ProductManager sharedInstance] setValueWith:[data objectForKey:kProductTableName]];
        } else {
            [self showConfirmToBack];
        }
    } error:^{
        [self showConfirmToBack];
    }];
}

@end
