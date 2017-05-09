//
//  CustomerViewController.m
//  Market Manager
//
//  Created by Quang on 4/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CustomerViewController.h"
#import "Customer.h"
#import "CustomerManager.h"
#import "CustomerCell.h"
#import "CustomerDetailViewController.h"

@interface CustomerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *customers;
@property (nonatomic, weak) IBOutlet UITableView *customerTableView;
@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerTableView.dataSource = self;
    _customerTableView.delegate = self;
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Customers";
}

- (void)getData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_GET_CUSTOMERS
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * task, id  responseObject) {
             NSInteger statusCode = [[responseObject objectForKey:kCode] integerValue];
             if (statusCode == kResSuccess) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 CustomerManager *manager = [CustomerManager sharedInstance];
                 NSArray *customers = [manager getListForm:data];
                 _customers = [NSMutableArray arrayWithArray:customers];
                 [_customerTableView reloadData];
             } else {
                 [self showConfirmToBack];;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             [self showConfirmToBack];
         }];
}

- (IBAction)onAddCustomer:(id)sender {
    UIAlertController * alertCtrl;
    alertCtrl = [UIAlertController alertControllerWithTitle: @"Customer"
                                                    message: @""
                                             preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    NSArray * textfields = alertCtrl.textFields;
                                                    UITextField * nameField = textfields[0];
                                                    if(nameField.text.length == 0) {
                                                        [self showMessage];
                                                    } else {
                                                        [self addNewCrate: nameField.text];
                                                    }
                                                }]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)addNewCrate:(NSString *)name {
    if(![Utils hasWritePermission:kFoodPermission notify:YES]) return;
    if(![self isCustomerExisted:name]) return
    [self showActivity];
    Customer *customer = [[Customer alloc] init];
    customer.name = name;
    customer.info = @"";
    NSDictionary *params = @{kTableName:@"food_customers",
                             kParams: @{kCustomerName:customer.name}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 NSDictionary *data = [responseObject objectForKey:kData];
                 customer.ID = [NSString stringWithFormat:@"%@", [data objectForKey:kInsertID]];
                 [_customers addObject:customer];
                 [_customerTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

- (void)showMessage {
    [CallbackAlertView setCallbackTaget:titleError
                                message:@"Please input name"
                                 target:self
                                okTitle:btnOK
                             okCallback:nil
                            cancelTitle:nil
                         cancelCallback:nil];
}

- (BOOL)isCustomerExisted:(NSString *)name {
    for (Customer *customer in _customers) {
        if ([customer.name isEqualToString:name]) {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"This name is existed!"
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

- (void)deleteItemAt:(NSIndexPath *)indexPath{
    [self showActivity];
    Customer *customer = _customers[indexPath.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kTableName:@"food_customers",
                             kParams: @{kIdName:kCustomerID,
                                        kIdValue:customer.ID}};
    [manager GET:API_DELETEDATA
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideActivity];
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [_customers removeObjectAtIndex:indexPath.row];
                 [_customerTableView reloadData];
             } else {
                 ShowMsgSomethingWhenWrong;
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self hideActivity];
             ShowMsgConnectFailed;
         }];
}

#pragma mark - TABLE VIEW DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerCell *cell;
    UILabel *indexLable;
    cell = [tableView dequeueReusableCellWithIdentifier:CellCustomer];
    [cell setCustomer:[_customers objectAtIndex:indexPath.row]];
    indexLable = [cell viewWithTag:kIndexTag];
    [indexLable setText:@(indexPath.row + 1).stringValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark - TABLE VIEW DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SegueShowCustomerDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(![Utils hasWritePermission:kFoodPermission notify:NO]) return;
        [self deleteItemAt:indexPath];
    }
}

#pragma mark - SEGUE DELEGATE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SegueShowCustomerDetail]) {
        CustomerDetailViewController *vc = segue.destinationViewController;
        vc.customer = _customers[_customerTableView.indexPathForSelectedRow.row];
    }
}


@end
