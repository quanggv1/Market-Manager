///
//  LoginViewController.m
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidateService.h"
#import "MenuViewController.h"

@interface LoginViewController ()<UITextFieldDelegate> {
    User *tempUser;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneValidation;
@property (weak, nonatomic) IBOutlet UILabel *labelPasswordValidation;
@property (weak, nonatomic) IBOutlet UIView *phoneSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@property (assign, nonatomic) BOOL isUserNameValid;
@property (assign, nonatomic) BOOL isPasswordValid;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameTextField.delegate = self;
    _passwordTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _userNameTextField.text = @"";
    _passwordTextField.text = @"";
    _labelPhoneValidation.text = @"";
    _labelPasswordValidation.text = @"";

}

- (IBAction)onLoginClicked:(id)sender {

   // [self pushToMain];

    if(![self isNameValid]) return;
    if(![self isPasswordValid]) return;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *userName = _userNameTextField.text;
    NSString *password = _passwordTextField.text;
    NSDictionary *params = @{kUserName: userName,
                             kUserPassword: password};
    [manager GET:API_AUTHEN parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:@"code"] intValue] == 200 ){
                tempUser = [[User alloc] initWith:[responseObject objectForKey:kData]];

                 [self pushToMain];
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgAuthenFailed
                                              target:self okTitle:@"OK"
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:@"OK"
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
             [self hideActivity];
         }];
}

- (void)pushToMain {
    MenuViewController *vc = (MenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:StoryboardMenuView];
    vc.user = tempUser;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onForgetPasswordClicked:(id)sender {
    
}

- (IBAction)onSigninClicked:(id)sender {
    
}

#pragma mark - TEXTFIELD DELEGATE
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _userNameTextField) {
        _phoneSeparator.backgroundColor = appColor;
        _labelPhoneValidation.text = @"";
    }
    else if(textField == _passwordTextField) {
        _passwordSeparator.backgroundColor = appColor;
        _labelPasswordValidation.text = @"";
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == _userNameTextField) {
        [self isNameValid];
    }
    else if(textField == _passwordTextField) {
        [self isPasswordValid];
    }
}

- (BOOL)isNameValid {
    _labelPhoneValidation.text = [ValidateService validName:_userNameTextField.text];
    if([_labelPhoneValidation.text isEqualToString:@""]) {
        _phoneSeparator.backgroundColor = [UIColor lightGrayColor];
        return YES;
    } else {
        _phoneSeparator.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (BOOL)isPasswordValid {
    _labelPasswordValidation.text = [ValidateService validPassword:_passwordTextField.text];
    if([_labelPasswordValidation.text isEqualToString:@""]) {
        _passwordSeparator.backgroundColor = [UIColor lightGrayColor];
        return YES;
    } else {
        _passwordSeparator.backgroundColor = [UIColor redColor];
        return NO;
    }
}


@end
