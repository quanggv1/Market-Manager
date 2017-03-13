//
//  SummaryTableViewCell.h
//  Market Manager
//
//  Created by Hanhnn1 on 3/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@interface SummaryTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbReceived;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantityNeeded;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbProductName;
@property (weak, nonatomic) IBOutlet UILabel *lbCrateQty;
@property (weak, nonatomic) IBOutlet UILabel *lbCrateType;
@property (weak, nonatomic) Product *product;
- (void)setProduct:(Product *)product;
@end
