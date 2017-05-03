//
//  CrateViewController.m
//  Market Manager
//
//  Created by quanggv on 2/16/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateViewController.h"
#import "Crate.h"
#import "CrateTableViewCell.h"
#import "CrateManager.h"

@interface CrateViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *crateDataSource;
@property (weak, nonatomic) IBOutlet UITableView *crateTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@end

@implementation CrateViewController {
    NSString *searchDate, *today;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControl];
    _crateDataSource = [[NSMutableArray alloc] init];
    _crateTableView.delegate = self;
    _crateTableView.dataSource = self;
    
    today = [Utils stringTodayDateTime];
    searchDate = today;
    _searchField.text = today;
    [self getData];
}

- (void)addRefreshControl {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.crateTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(getData)
                  forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)getData {
    [self downloadWith:searchDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Crate Management";
}

- (void)downloadWith:(NSString *)date {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_CRATES
      parameters:@{kDate: date}
        progress:nil
         success:^(NSURLSessionDataTask *  task, id   responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 NSArray *crates = [responseObject objectForKey:kData];
                 crates = [[CrateManager sharedInstance] getCrateListForm:crates];
                 _crateDataSource = [[NSMutableArray alloc] initWithArray:crates];
             } else {
                 _crateDataSource = [[NSMutableArray alloc] init];
                 ShowMsgUnavaiableData;
             }
             [self.refreshControl endRefreshing];
             [_crateTableView reloadData];
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self.refreshControl endRefreshing];
             _crateDataSource = [[NSMutableArray alloc] init];
             [_crateTableView reloadData];
             ShowMsgConnectFailed;
         }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    Crate *CrateDeleted = _crateDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:kCrateTableName,
                             kParams: @{kIdName:kCrateID,
                                        kIdValue:CrateDeleted.ID}};
    [manager GET:API_DELETEDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideActivity];
             [_crateDataSource removeObjectAtIndex:indexPath.row];
             [_crateTableView reloadData];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
         }];
}

- (IBAction)onAddNewCrate:(id)sender {
    if(![Utils hasWritePermission:kCrateTableName notify:YES]) return;
    if (![today isEqualToString:searchDate]) return;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add New Provider"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Crate Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action) {
                                    NSArray * textfields = alertController.textFields;
                                    UITextField * crateField = textfields[0];
                                    if(crateField.text.length == 0) {
                                        [CallbackAlertView setCallbackTaget:titleError
                                                                    message:@"Please input Crate"
                                                                     target:self
                                                                    okTitle:btnOK
                                                                 okCallback:nil
                                                                cancelTitle:nil
                                                             cancelCallback:nil];
                                    } else {
                                        if([self isNewProviderExisted:crateField.text]) {
                                            [self addNewCrate: crateField.text];
                                        }
                                    }
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isNewProviderExisted:(NSString *)newProviderName {
    for (Crate *crate in _crateDataSource) {
        if ([crate.provider isEqualToString:newProviderName]) {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"This provider is existed!"
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

- (void)addNewCrate:(NSString *)provider {
    [self showActivity];
    Crate *crate = [[Crate alloc] init];
    crate.provider = provider;
    NSDictionary *params = @{kTableName:kCrateTableName,
                             kParams: @{kCrateProvider:crate.provider}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
            if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                NSDictionary *data = [responseObject objectForKey:kData];
                crate.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
                [_crateDataSource addObject:crate];
                [_crateTableView reloadData];
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
    if([_crateDataSource count] == 0 || ![searchDate isEqualToString:today]) return;
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    for (Crate *crate in _crateDataSource) {
        [updates addObject:@{kCrateID: crate.ID,
                             kCrateProvider: crate.provider,
                             kCrateIn: @(crate.qtyIn),
                             kCrateOut: @(crate.qtyOut),
                             kCrateTotal: @(crate.total)}];
    }
    NSDictionary *params = @{kParams: [Utils objectToJsonString:updates]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_CRATES
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

- (IBAction)onCalendarClicked:(id)sender {
    [Utils showDatePickerWith:_searchField.text
                       target:self
                     selector:@selector(onDatePickerSelected:)];
}

- (void)onDatePickerSelected:(NSDate *)dateSelected {
    NSString *date = [[Utils dateFormatter] stringFromDate:dateSelected];
    _searchField.text = date;
    if(![date isEqualToString:searchDate]) {
        searchDate = date;
        [self downloadWith:date];
    }
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _crateDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CrateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellCrateManager];
    UILabel *indexLabel = [cell viewWithTag:201];
    indexLabel.text = @(indexPath.row + 1).stringValue;
    [cell setCrate:_crateDataSource[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![Utils hasWritePermission:kCrateTableName notify:NO]) return;
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [today isEqualToString:searchDate];
}

@end
