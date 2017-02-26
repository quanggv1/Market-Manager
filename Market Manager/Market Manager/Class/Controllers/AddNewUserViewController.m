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
@interface AddNewUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@end

@implementation AddNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *userName = [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userPassword = [_userPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!userName || userName.length == 0 ) {
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Please input username & password" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params = @{@"tableName":kUserTableName,
                             @"params": @{kUserName:userName,
                                          kUserPassword: userPassword}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_INSERTDATA parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if([[responseObject objectForKey:@"status"] intValue] == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *userID = [NSString stringWithFormat:@"%@", [data objectForKey:@"insertId"]];
            [self addNewUser:userID name:userName password:userPassword];
            [self hideActivity];
            [self dismiss];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideActivity];
        [CallbackAlertView setCallbackTaget:@"Error" message:@"Can't connect to server" target:self okTitle:@"OK" okCallback:nil cancelTitle:nil cancelCallback:nil];
    }];
}

- (void)addNewUser:(NSString *)UserID name:(NSString *)UserName password:(NSString *)password {
    User *newUser = [[User alloc] initWith:@{kUserID:UserID,
                                             kUserName:UserName,
                                             kUserPassword: password}];
    [[UserManager sharedInstance] insert:newUser];
    self.saveCallback(newUser);
}

@end

