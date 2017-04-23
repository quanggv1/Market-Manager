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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _ipAddressField.text = [_ipAddressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (IBAction)onOutsideClicked:(id)sender {
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

- (IBAction)onSavedClicked:(id)sender {
    [Utils hideKeyboard];
    [[StorageService sharedInstance] saveItem:_ipAddressField.text forKey:kStorageIPAdress];
    [self onOutsideClicked:nil];
}

@end
