//
//  InvoiceViewController.h
//  Market Manager
//
//  Created by Hanhnn1 on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "BaseViewController.h"
#import "Order.h"
@interface InvoiceViewController : BaseViewController
@property (weak, nonatomic) Order *order;
@end
