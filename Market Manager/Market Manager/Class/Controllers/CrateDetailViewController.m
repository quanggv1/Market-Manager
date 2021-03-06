//
//  CrateDetailViewController.m
//  Market Manager
//
//  Created by Quang on 4/2/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateDetailViewController.h"
#import "CrateManager.h"
#import "Crate.h"
#import "CrateDetailTableViewCell.h"
#import "Data.h"

@interface CrateDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *crates;
@property (nonatomic, weak) IBOutlet UITableView *cratesTableView;
@end

@implementation CrateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self addRefreshControll];
    _cratesTableView.delegate = self;
    _cratesTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.parentViewController.navigationItem.title = @"Crate manager";
}

- (void)addRefreshControll {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.cratesTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)getData {
    NSDictionary *params = @{kType: @"0"};
    
    [[Data sharedInstance] get:API_GET_CRATES_DETAIL data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            
            NSArray *crates = [res objectForKey:kData];
            
            crates = [[CrateManager sharedInstance] getCrateListForm:crates];
            
            self.crates = [NSMutableArray arrayWithArray:crates];
            [self.cratesTableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
        [self.refreshControl endRefreshing];
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onAddNewCrate:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add New Crate"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Crate Type";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * crateField = textfields[0];
        if(crateField.text.length == 0) {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"Please input Crate type"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
            
        } else {
            if([self isNewCrateExisted:crateField.text]) {
                [self addNewCrate: crateField.text];
            }
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isNewCrateExisted:(NSString *)crateType {
    for (Crate *crate in _crates) {
        if ([crate.name isEqualToString:crateType]) {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"This crate is existed!"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
            return NO;
        }
    }
    return YES;
}

- (void)addNewCrate:(NSString *)name {
    if(![Utils hasWritePermission:kCrateTableName notify:YES]) return;
    [self showActivity];
    Crate *crate = [[Crate alloc] init];
    crate.name = name;
    crate.price = 0;
    crate.crateDesc = @"";
    crate.type = @"0";
    
    NSDictionary *params = @{kTableName:@"crate_detail",
                             kParams: @{kCrateType: crate.name,
                                        kType: crate.type}};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 
                 crate.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
                 
                 [[CrateManager sharedInstance] insert:crate];
                 
                 [_crates insertObject:crate atIndex:0];
                 [_cratesTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (IBAction)onSaveClicked:(id)sender {
    if(![Utils hasWritePermission:kCrateTableName notify:YES]) return;
    if([_crates count] == 0) return;
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    for (Crate *crate in _crates) {
        [updates addObject:@{kCrateID: crate.ID,
                             kCrateType: crate.name,
                             kCratePrice: @(crate.price),
                             kCrateDesc: crate.crateDesc}];
    }
    NSDictionary *params = @{kParams: [Utils objectToJsonString:updates]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_CRATES_DETAIL
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 [CallbackAlertView setCallbackTaget:titleSuccess
                                             message:@"Your data has been saved!"
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             } else {
                 ShowMsgSomethingWhenWrong;;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    Crate *CrateDeleted = _crates[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:@"crate_detail",
                             kParams: @{kIdName:kCrateID,
                                        kIdValue:CrateDeleted.ID}};
    [manager GET:API_DELETEDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideActivity];
             [[CrateManager sharedInstance] delete:CrateDeleted];
             [_crates removeObjectAtIndex:indexPath.row];
             [_cratesTableView deleteRowsAtIndexPaths:@[indexPath]
                                     withRowAnimation:UITableViewRowAnimationFade];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
         }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CrateDetailTableViewCell *cell;
    UILabel *indexLabel;
    cell = [tableView dequeueReusableCellWithIdentifier:CellCrateDetail];
    [cell setCrate:_crates[indexPath.row]];
    indexLabel = [cell viewWithTag:201];
    indexLabel.text = @(indexPath.row + 1).stringValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![Utils hasWritePermission:kCrateTableName notify:NO]) return;
        [self deleteItemAt:indexPath];
    }
}


@end
