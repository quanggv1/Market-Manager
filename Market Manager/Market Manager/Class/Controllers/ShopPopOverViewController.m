//
//  ShopPopOverViewController.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopPopOverViewController.h"

@interface ShopPopOverViewController ()

@end

@implementation ShopPopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDeleteButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShopDeletesItem object:_selectedIndexPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
