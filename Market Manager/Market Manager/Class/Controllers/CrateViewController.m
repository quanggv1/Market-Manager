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
    _crateTableView.delegate = self;
    _crateTableView.dataSource = self;
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.crateTableView;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getConnections) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
}

- (void)getConnections {
    [self downloadWith:searchDate];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Crate Management";
    [super viewWillAppear:animated];
    today = [Utils stringTodayDateTime];
    searchDate = today;
    _searchField.text = today;
    [self downloadWith:searchDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)downloadWith:(NSString *)date {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName: kCrateTableName,
                             kDate: date};
    [manager GET:API_GET_CRATES
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [[CrateManager sharedInstance] setValueWith:[responseObject objectForKey:kData]];
                 _crateDataSource = [[NSMutableArray alloc] initWithArray:[[CrateManager sharedInstance] getCrateList]];
             } else {
                 _crateDataSource = nil;
                 ShowMsgUnavaiableData;
             }
             [self.refreshControl endRefreshing];
             [_crateTableView reloadData];
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self.refreshControl endRefreshing];
             _crateDataSource = nil;
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
             [[CrateManager sharedInstance] delete:CrateDeleted];
             [_crateDataSource removeObjectAtIndex:indexPath.row];
             [_crateTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
         }];
}

- (IBAction)onAddNewCrate:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add New Crate"
                                                                              message: @"Input Crate Name"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Crate Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
            [self addNewCrate: crateField.text];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addNewCrate:(NSString *)name {
    [self showActivity];
    Crate *crate = [[Crate alloc] init];
    crate.name = name;
    NSDictionary *params = @{kTableName:kCrateTableName,
                             kParams: @{kCrateName:crate.name}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
            if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                crate.ID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:kInsertID]];
                [[CrateManager sharedInstance] insert:crate];
                [_crateDataSource insertObject:crate atIndex:0];
                [_crateTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                       withRowAnimation:UITableViewRowAnimationFade];
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
    if([_crateDataSource count] == 0 || ![searchDate isEqualToString:today]) return;
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    for (Crate *crate in _crateDataSource) {
        [updates addObject:@{kCrateID: crate.ID,
                             kCrateReturned: @(crate.returnedQty),
                             kCrateReceived: @(crate.receivedQty)}];
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

- (IBAction)onExportClicked:(id)sender {
    [CallbackAlertView setCallbackTaget:@"Message"
                                message:@"Please save data first, your data will be refreshed. Are you sure to continue?"
                                 target:self
                                okTitle:@"OK"
                             okCallback:@selector(export)
                            cancelTitle:@"Cancel"
                         cancelCallback:nil];
}

- (void)export {
    if (!_crateDataSource) return;
    if ([searchDate isEqualToString:today]) {
        [self showActivity];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:API_EXPORT_CRATES
          parameters:@{kTableName:kCrateTableName}
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                     [self refreshData];
                     [self onSaveClicked:nil];
                 } else {
                     [self hideActivity];
                     ShowMsgSomethingWhenWrong;
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self hideActivity];
                 ShowMsgConnectFailed;
             }];
    } else {
        [CallbackAlertView setCallbackTaget:@"Message"
                                    message:@"This record has been exported!"
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
    }
}

- (void)refreshData {
    for (Crate *crate in _crateDataSource) {
        crate.receivedQty -= crate.returnedQty;
        crate.returnedQty = 0;
    }
    [_crateTableView reloadData];
}



#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _crateDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CrateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellCrateManager];
    [cell setCrate:_crateDataSource[indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}
@end
