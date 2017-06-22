//
//  SupplyPalletTableViewCell.h
//  Market Manager
//
//  Created by Quang on 6/22/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplyPalletTableViewCell : UITableViewCell
- (void)setCellWith:(NSString *)index dictionary:(NSMutableDictionary *)dictionary supplies:(NSArray *)supplies;
@end
