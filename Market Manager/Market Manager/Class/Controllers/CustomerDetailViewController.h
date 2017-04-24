//
//  CustomerDetailViewController.h
//  Market Manager
//
//  Created by quanggv on 4/24/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Customer.h"

@interface CustomerDetailViewController : BaseViewController
@property (nonatomic, weak) Customer *customer;
@end
