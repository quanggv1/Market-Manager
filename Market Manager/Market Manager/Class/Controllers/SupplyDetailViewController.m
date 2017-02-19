//
//  SupplyDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyDetailViewController.h"

@interface SupplyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *supplyNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *supplyImageView;
@end

@implementation SupplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _supplyNameLbl.text = _supply.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
