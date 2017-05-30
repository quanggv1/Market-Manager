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
#import "Data.h"


static AddNewSupplyViewController *addNewSupplyViewController;
@interface AddNewSupplyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *SupplyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *SupplyDescTextView;
@end

@implementation AddNewSupplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _SupplyNameTextField.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self dismiss];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _SupplyNameTextField.text = [_SupplyNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)showViewAt:(UIViewController *)controller onSave:(SaveCallback)saveCallback
{
    if(!addNewSupplyViewController) {
        addNewSupplyViewController = [[UIStoryboard storyboardWithName:StoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:StoryboardAddNewSupply];
        [controller addChildViewController:addNewSupplyViewController];
        [controller.view addSubview:addNewSupplyViewController.view];
        addNewSupplyViewController.saveCallback = saveCallback;
    }
}

- (void)dismiss
{
    if(addNewSupplyViewController) {
        [addNewSupplyViewController removeFromParentViewController];
        [addNewSupplyViewController.view removeFromSuperview];
        addNewSupplyViewController = nil;
    }
}

- (IBAction)onCancelClicked:(id)sender
{
    [Utils hideKeyboard];
    [self dismiss];
}

- (IBAction)onSaveClicked:(id)sender
{
    [Utils hideKeyboard];
    
    Supply *newSupply = [[Supply alloc] init];
    newSupply.name = _SupplyNameTextField.text;
    newSupply.supplyDesc = _SupplyDescTextView.text;
    
    if(newSupply.name.length == 0) {
        [self showMessage:@"Please input warehouse name"];
        return;
    }
    
    if ([[SupplyManager sharedInstance] exist:newSupply.name]) {
        [self showMessage:@"Warehouse name is existed"];
        return;
    }
    
    NSDictionary *params =  @{kParams:@{kSupplyName:newSupply.name,
                                        kSupplyDesc: newSupply.supplyDesc}};
    
    [[Data sharedInstance] get:API_ADD_NEW_WAREHOUSE data:params success:^(id res) {
        if([[res objectForKey:kCode] intValue] == 200) {
            newSupply.ID = [NSString stringWithFormat:@"%@", [[res objectForKey:kData] objectForKey:@"insertId"]];
            [[SupplyManager sharedInstance] insert:newSupply];
            self.saveCallback(newSupply);
            [self dismiss];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)showMessage:(NSString *)message
{
    [CallbackAlertView setCallbackTaget:nil
                                message:message
                                 target:self
                                okTitle:btnOK
                             okCallback:nil
                            cancelTitle:nil
                         cancelCallback:nil];
}

@end
