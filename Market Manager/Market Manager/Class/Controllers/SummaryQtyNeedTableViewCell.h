//
//  SupplyTableViewCell.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Supply.h"

@interface SummaryQtyNeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UITextField *quantityNeed;
- (void)setProductContentList:(NSArray *)productContentList;

@end
