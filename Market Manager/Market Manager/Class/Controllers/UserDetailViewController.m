//
//  UserDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserDetailViewController.h"
#import "ShopManager.h"
#import "SupplyManager.h"
#import "UserDetailTableViewCell.h"

@interface UserDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
@property (assign, nonatomic) NSInteger numberOfSection;
@property (strong, nonatomic) NSMutableArray *shops, *warehouses;
@property (strong, nonatomic) NSMutableDictionary *cratePermision, *productPermission;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfoTableView.dataSource = self;
    _userInfoTableView.delegate = self;
//    _userNameLbl.text = _user.name;
    _shops = [[NSMutableArray alloc] init];
    _warehouses = [[NSMutableArray alloc] init];


    NSArray *readPermission = [NSJSONSerialization JSONObjectWithData:[_user.readPermission dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSArray *writePermission = [NSJSONSerialization JSONObjectWithData:[_user.writePermission dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *shopNameList = [[ShopManager sharedInstance] getShopNameList];
    for (NSString *shopName in shopNameList) {
        NSString *isReadOnly = [readPermission containsObject:shopName] ? @"1" : @"0";
        NSString *isWritable = [writePermission containsObject:shopName] ? @"1" : @"0";
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:isReadOnly, kReadPermission, isWritable, kWritePermission, shopName, @"name", nil];
        [_shops addObject:dict];
    }
    
    NSArray *warehouseNameList = [[SupplyManager sharedInstance] getSupplyNameList];
    for (NSString *warehouseName in warehouseNameList) {
        NSString *isReadOnly = [readPermission containsObject:warehouseName] ? @"1" : @"0";
        NSString *isWritable = [writePermission containsObject:warehouseName] ? @"1" : @"0";
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:isReadOnly, kReadPermission, isWritable, kWritePermission, warehouseName, @"name", nil];
        [_warehouses addObject:dict];
    }
    
    NSString *isProductReadOnly = [readPermission containsObject:kProductTableName] ? @"1" : @"0";
    NSString *isProductWritable = [writePermission containsObject:kProductTableName] ? @"1" : @"0";
    _productPermission = [NSMutableDictionary dictionaryWithObjectsAndKeys:isProductReadOnly, kReadPermission, isProductWritable, kWritePermission, kProductTableName, @"name", nil];
    
    NSString *isCrateReadOnly = [readPermission containsObject:kCrateTableName] ? @"1" : @"0";
    NSString *isCrateWritable = [writePermission containsObject:kCrateTableName] ? @"1" : @"0";
    _cratePermision = [NSMutableDictionary dictionaryWithObjectsAndKeys:isCrateReadOnly, kReadPermission, isCrateWritable, kWritePermission, kCrateTableName, @"name", nil];
    
    
    _numberOfSection = _user.isAdmin ? 1 : 6;
    [_userInfoTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableDatasource) name:NotifyUpdateProfile object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTableDatasource {
    _numberOfSection = _user.isAdmin ? 1 : 6;
    [_userInfoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    [self showActivity];
    NSMutableArray *readPermission = [[NSMutableArray alloc] init];
    NSMutableArray *writePermission = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _shops) {
        if([[dict objectForKey:kReadPermission] isEqualToString:@"1"]) {
            [readPermission addObject:[dict objectForKey:@"name"]];
        }
        if([[dict objectForKey:kWritePermission] isEqualToString:@"1"]) {
            [writePermission addObject:[dict objectForKey:@"name"]];
        }
    }
    for (NSDictionary *dict in _warehouses) {
        if([[dict objectForKey:kReadPermission] isEqualToString:@"1"]) {
            [readPermission addObject:[dict objectForKey:@"name"]];
        }
        if([[dict objectForKey:kWritePermission] isEqualToString:@"1"]) {
            [writePermission addObject:[dict objectForKey:@"name"]];
        }
    }
    
    if([[_productPermission objectForKey:kReadPermission] isEqualToString:@"1"]) {
        [readPermission addObject:[_productPermission objectForKey:@"name"]];
    }
    
    if([[_productPermission objectForKey:kWritePermission] isEqualToString:@"1"]) {
        [writePermission addObject:[_productPermission objectForKey:@"name"]];
    }
    
    if([[_cratePermision objectForKey:kReadPermission] isEqualToString:@"1"]) {
        [readPermission addObject:[_cratePermision objectForKey:@"name"]];
    }
    
    if([[_cratePermision objectForKey:kWritePermission] isEqualToString:@"1"]) {
        [writePermission addObject:[_cratePermision objectForKey:@"name"]];
    }
    
    
    NSDictionary *params = @{kParams:@{kUserID: _user.ID,
                                       kUserAdmin: @(_user.isAdmin),
                                       kWritePermission: [Utils objectToJsonString:writePermission],
                                       kReadPermission: [Utils objectToJsonString:readPermission],
                                       kUserPassword: _user.password
                                       }};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_USERINFO
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [CallbackAlertView setBlock:titleSuccess
                                     message:@"This profile has been saved"
                                     okTitle:btnOK
                                     okBlock:^{
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                 cancelTitle:nil
                                 cancelBlock:nil];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _numberOfSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0) ? 130 : 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 4:
            return _shops.count;
        case 5:
            return _warehouses.count;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 2:
            return @"Products";
        case 3:
            return @"Crates";
        case 4:
            return @"Shops";
        case 5:
            return @"Ware Houses";
        default:
            return @"";
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
            [((UserDetailTableViewCell *)cell) setUser:_user];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoHeaderCell"];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userPermissionCell"];
            [((UserDetailTableViewCell *)cell) setPermissionDict:_productPermission];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userPermissionCell"];
            [((UserDetailTableViewCell *)cell) setPermissionDict:_cratePermision];
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userPermissionCell"];
            [((UserDetailTableViewCell *)cell) setPermissionDict:_shops[indexPath.row]];
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:@"userPermissionCell"];
            [((UserDetailTableViewCell *)cell) setPermissionDict:_warehouses[indexPath.row]];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
