//
//  OrderPopOverViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderPopOverViewController.h"

@interface OrderPopOverViewController ()

@end

@implementation OrderPopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDeleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyOrderDeletesItem object:_selectedIndexPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
