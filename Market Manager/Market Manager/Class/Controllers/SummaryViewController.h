//
//  SummaryViewController.h
//  Market Manager
//
//  Created by Hanhnn1 on 3/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Order.h"
@interface SummaryViewController : BaseViewController
@property (weak, nonatomic) Order *order;
@end
