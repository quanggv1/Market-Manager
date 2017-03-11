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
@end

@implementation CrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _crateTableView.delegate = self;
    _crateTableView.dataSource = self;
    if ([[[CrateManager sharedInstance] getCrateList] count] == 0) {
        [self download];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Crate Management";
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}

- (void)download {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName: kCrateTableName};
    [manager GET:API_GETDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[CrateManager sharedInstance] setValueWith:responseObject];
        _crateDataSource = [[NSMutableArray alloc] initWithArray:[[CrateManager sharedInstance] getCrateList]];
        [_crateTableView reloadData];
        [self hideActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    Crate *CrateDeleted = _crateDataSource[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:kCrateTableName,
                             kParams: @{kIdName:kCrateID,
                                        kIdValue:CrateDeleted.ID}};
    [manager GET:API_DELETEDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideActivity];
        [[CrateManager sharedInstance] delete:CrateDeleted];
        [_crateDataSource removeObjectAtIndex:indexPath.row];
        [_crateTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
    }];
}

- (IBAction)onAddNewCrate:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Add New Crate" message: @"Input Crate Name" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Crate Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * crateField = textfields[0];
        [self addNewCrate: crateField.text];
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
                [CallbackAlertView setCallbackTaget:titleError
                                            message:msgSomethingWhenWrong
                                             target:self
                                            okTitle:@"OK"
                                         okCallback:nil
                                        cancelTitle:nil
                                     cancelCallback:nil];
            }
            [self hideActivity];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self hideActivity];
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"Can't connect to server"
                                         target:self
                                        okTitle:@"OK"
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        }];

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
