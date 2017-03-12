//
//  SupplyDetailViewController.h
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Supply.h"
#import "BaseViewController.h"

@interface SupplyDetailViewController : BaseViewController
@property (weak, nonatomic) Supply *supply;
@property (strong, nonatomic) NSMutableArray *products;
@end
