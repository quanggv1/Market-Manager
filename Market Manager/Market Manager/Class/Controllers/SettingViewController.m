//
//  SettingViewController.m
//  Market Manager
//
//  Created by quanggv on 4/5/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *ipAddressField;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ipAddressField.delegate = self;
    _ipAddressField.text = [[StorageService sharedInstance] getItemByKey:kStorageIPAdress];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _ipAddressField.text = [Utils trim:_ipAddressField.text];
}

- (IBAction)onCancelClicked:(id)sender
{
    [self showSetting:NO];
}

- (void)showSetting:(BOOL)show
{
    [self.view setHidden:!show];
}

- (IBAction)onSavedClicked:(id)sender
{
    [Utils hideKeyboard];
    [[StorageService sharedInstance] saveItem:_ipAddressField.text forKey:kStorageIPAdress];
    [self showSetting:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
