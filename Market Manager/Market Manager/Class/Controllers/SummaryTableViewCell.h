//
//  SummaryTableViewCell.h
//  Market Manager
//
//  Created by Hanhnn1 on 3/13/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

@interface SummaryTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbReceived;
@property (weak, nonatomic) IBOutlet UILabel *lbQuantityNeeded;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbProductName;
@property (weak, nonatomic) IBOutlet UILabel *lbCrateQty;
@property (weak, nonatomic) IBOutlet UILabel *lbCrateType;
- (void)setProduct:(NSDictionary *)dict;
@end
