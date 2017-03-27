//
//  AddNewUserViewController.m
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewUserViewController.h"
#import "UserManager.h"
#import "User.h"

static AddNewUserViewController *addNewUserViewController;
@interface AddNewUserViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@end

@implementation AddNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userNameTextField.delegate = self;
    _userPasswordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismiss];
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback {
    if(!addNewUserViewController) {
        addNewUserViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewUser];
        [controller addChildViewController:addNewUserViewController];
        [controller.view addSubview:addNewUserViewController.view];
        addNewUserViewController.saveCallback = saveCallback;
    }
}

- (void)dismiss {
    if(addNewUserViewController) {
        [addNewUserViewController removeFromParentViewController];
        [addNewUserViewController.view removeFromSuperview];
        addNewUserViewController = nil;
    }
}

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    User *newUser = [[User alloc] init];
    newUser.name = _userNameTextField.text;
    newUser.password = _userPasswordTextField.text;
    if(newUser.name.length < 5 || newUser.password.length < 5 ) {
        [CallbackAlertView setCallbackTaget:@""
                                    message:@"Please input username & password at least 5 letters!"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params = @{kParams: @{kUserName: newUser.name,
                                        kUserPassword: newUser.password}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_ADD_NEW_USER
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self hideActivity];
             if([[responseObject objectForKey:kCode] intValue] == kResSuccess) {
                 newUser.ID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:kInsertID]];
                 self.saveCallback(newUser);
                 [self dismiss];
             } else {
                 [CallbackAlertView setCallbackTaget:@""
                                             message:@"Username has been used!"
                                              target:self
                                             okTitle:@"OK"
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        ShowMsgConnectFailed;
    }];
}

@end

