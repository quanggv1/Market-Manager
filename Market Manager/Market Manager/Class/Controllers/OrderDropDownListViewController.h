//
//  OrderDropDownListViewController.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnSelectedCell)(NSString *result);
@interface OrderDropDownListViewController : UIViewController
@property (strong, nonatomic) OnSelectedCell onSelectedCell;
- (void)onSelected:(OnSelectedCell)callback;
- (void)setRecommendList:(NSString *)name;
- (void)updateRecommedListWith:(NSString *)keySearch;
@end
