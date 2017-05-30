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
#import "UserManager.h"
#import "SettingViewController.h"
#import "Data.h"

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
@property (weak, nonatomic) SettingViewController *settingViewController;
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
    [self restrictRotation:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self restrictRotation:NO];
}

- (IBAction)onLoginClicked:(id)sender {
    [Utils hideKeyboard];
    if(![self isNameValid]) return;
    if(![self isPasswordValid]) return;
    
    NSString *userName = _userNameTextField.text;
    NSString *password = _passwordTextField.text;
    NSDictionary *params = @{kUserName: userName,
                             kUserPassword: password};
    
    [[Data sharedInstance] get:API_AUTHEN data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == kResSuccess ){
            tempUser = [[User alloc] initWith:[res objectForKey:kData]];
            [[UserManager sharedInstance] setTempUser:tempUser];
            [self performSegueWithIdentifier:@"showMenu" sender:self];
        } else {
            [CallbackAlertView setCallbackTaget:@""
                                        message:msgAuthenFailed
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
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

- (IBAction)showSetting:(id)sender
{
    [Utils hideKeyboard];
    if (!_settingViewController) {
        _settingViewController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardSettingView];
        [self addChildViewController:_settingViewController];
        [self.view addSubview:_settingViewController.view];
    }
    [_settingViewController.view setHidden:NO];
}


@end
