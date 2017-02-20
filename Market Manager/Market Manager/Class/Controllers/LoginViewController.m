///
//  LoginViewController.m
//  Canets
//
//  Created by Quang on 11/27/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneValidation;
@property (weak, nonatomic) IBOutlet UILabel *labelPasswordValidation;
@property (weak, nonatomic) IBOutlet UIView *phoneSeparator;
@property (weak, nonatomic) IBOutlet UIView *passwordSeparator;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _phoneTextField.text = @"";
    _passwordTextField.text = @"";
    _labelPhoneValidation.text = @"";
    _labelPasswordValidation.text = @"";

}

- (IBAction)onLoginClicked:(id)sender {
    [self pushToMain];
}

- (void)pushToMain {
    [Utils showActivity];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onForgetPasswordClicked:(id)sender {
}

- (IBAction)onSigninClicked:(id)sender {
    
}


@end
