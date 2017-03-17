//
//  OrderDetailCollectionViewCell.h
//  Market Manager
//
//  Created by quanggv on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCollectionViewCell : UICollectionViewCell
- (void)setValueAt:(NSInteger)index dict:(NSDictionary *)productDic key:(NSString *)key;
@end
