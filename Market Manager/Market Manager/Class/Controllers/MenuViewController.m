//
//  MenuViewController.m
//  Canets
//
//  Created by Quang on 12/3/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "ProductManager.h"
#import "ShopManager.h"
#import "SupplyManager.h"
#import "CrateManager.h"
#import "Crate.h"
#import "Data.h"

@interface MenuViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) NSArray *menuData;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _menuData = @[[[MenuCellProp alloc] initWith:@"Vegetables & others" image:@"ic_shopping_cart_36pt"],
                  [[MenuCellProp alloc] initWith:@"Meats" image:@"ic_swap_vertical_circle_36pt"],
                  [[MenuCellProp alloc] initWith:@"Food Service" image:@"ic_store_36pt"],
                  [[MenuCellProp alloc] initWith:@"User Management" image:@"ic_people_36pt"]];
    _menuTable.delegate = self;
    _menuTable.dataSource = self;
    
    [self donwloadData];
}

- (void)donwloadData
{
    NSDictionary *params = @{kProduct: @([[ProductManager sharedInstance] getProductType])};
    [[Data sharedInstance] get:API_GET_DATA_DEFAULT
                          data:params
                       success:^(id res) {
                           if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
                               NSDictionary *data = [res objectForKey:kData];
                               [[CrateManager sharedInstance] setValueWith:[data objectForKey:kCrateTableName]];
                               [[SupplyManager sharedInstance] setWarehouses:[data objectForKey:kSupplyTableName]];
                               [[ShopManager sharedInstance] setValueWith:[data objectForKey:kShopTableName]];
                               [[ProductManager sharedInstance] setProducts:[data objectForKey:kProductTableName]];
                           } else {
                               [self showConfirmToBack];
                           }
                       } error:^{
                           [self showConfirmToBack];
                       }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = kAppName;
    [self restrictRotation:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self restrictRotation:NO];
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellMenu];
    [cell setMenuWith:[_menuData objectAtIndex:indexPath.row]];
    UIImage *banner;
    switch (indexPath.row) {
        case 0:
            banner = [UIImage imageNamed:@"vegetable-banner.jpg"];
            break;
        case 1:
            banner = [UIImage imageNamed:@"meat-banner.jpg"];
            break;
        case 2:
            banner = [UIImage imageNamed:@"food-banner.jpg"];
            break;
        default:
            banner = [UIImage imageNamed:@"user-banner.jpg"];
            break;
    }
    [cell.banner setImage:banner];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
            if(![Utils hasReadPermission:kVegePermission] || ![Utils hasWritePermission:kVegePermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kVegetables];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 1:
            if(![Utils hasReadPermission:kMeatPermission] || ![Utils hasWritePermission:kMeatPermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kMeats];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];
            break;
        case 2:
            if(![Utils hasReadPermission:kFoodPermission] || ![Utils hasWritePermission:kFoodPermission notify:YES]) return;
            [[ProductManager sharedInstance] setProductType:kFoods];
            [self performSegueWithIdentifier:SegueShowFunctionList sender:self];;
            break;
        case 3:
            if(![Utils hasReadPermission:kUserTableName]) return;
            [self performSegueWithIdentifier:@"showUsers" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark - IBAction
- (IBAction)onLogoutClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you ready want to log out?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Yes, log out"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    actionSheet.tag = 100;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100 && buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}





@end
