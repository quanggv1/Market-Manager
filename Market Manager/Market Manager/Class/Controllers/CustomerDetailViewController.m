//
//  CustomerDetailViewController.m
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CustomerDetailViewController.h"

@interface CustomerDetailViewController ()
@property (nonatomic, weak) IBOutlet UITextField *customerNameField;
@property (nonatomic, weak) IBOutlet UITextView *customerInfoField;
@end

@implementation CustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customerInfoField.text = _customer.info;
    _customerNameField.text = _customer.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSave:(id)sender {
    [Utils hideKeyboard];
    [self showActivity];
    _customer.info = _customerInfoField.text;
    NSDictionary *params = @{kParams:@{kCustomerID: _customer.ID,
                                       kCustomerInfo: _customer.info}};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_UPDATE_CUSTOMER
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == kResSuccess) {
                 [CallbackAlertView setBlock:@""
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


@end
