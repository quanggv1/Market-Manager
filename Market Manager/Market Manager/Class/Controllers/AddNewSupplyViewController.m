//
//  AddNewSupplyViewController.m
//  Market Manager
//
//  Created by Quang on 2/26/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "AddNewSupplyViewController.h"
#import "SupplyManager.h"
#import "Supply.h"


static AddNewSupplyViewController *addNewSupplyViewController;
@interface AddNewSupplyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *SupplyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *SupplyDescTextView;
@end

@implementation AddNewSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SupplyNameTextField.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _SupplyNameTextField.text = [_SupplyNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback {
    if(!addNewSupplyViewController) {
        addNewSupplyViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewSupply];
        [controller addChildViewController:addNewSupplyViewController];
        [controller.view addSubview:addNewSupplyViewController.view];
        addNewSupplyViewController.saveCallback = saveCallback;
    }
}

- (void)dismiss {
    if(addNewSupplyViewController) {
        [addNewSupplyViewController removeFromParentViewController];
        [addNewSupplyViewController.view removeFromSuperview];
        addNewSupplyViewController = nil;
    }
}

- (IBAction)onCancelClicked:(id)sender {
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender {
    [Utils hideKeyboard];
    Supply *newSupply = [[Supply alloc] init];
    newSupply.name = _SupplyNameTextField.text;
    newSupply.supplyDesc = _SupplyDescTextView.text;
    if(newSupply.name.length == 0) {
        [CallbackAlertView setCallbackTaget:@""
                                    message:@"Please input warehouse name"
                                     target:self
                                    okTitle:@"OK"
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
        return;
    }
    
    [self showActivity];
    NSDictionary *params =  @{kParams:@{kSupplyName:newSupply.name,
                                        kSupplyDesc: newSupply.supplyDesc}};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:API_ADD_NEW_WAREHOUSE
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if([[responseObject objectForKey:kCode] intValue] == 200) {
                 newSupply.ID = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:kData] objectForKey:@"insertId"]];
                 [[SupplyManager sharedInstance] insert:newSupply];
                 self.saveCallback(newSupply);
                 [self dismiss];
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
