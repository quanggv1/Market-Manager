//
//  WhExpectedCollectionViewCell.h
//  Market Manager
//
//  Created by quanggv on 6/20/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhExpectedCollectionViewCell : UICollectionViewCell<UITextFieldDelegate>
- (void)setValueAt:(NSInteger)index dict:(NSDictionary *)productDic key:(NSString *)key;
@end
