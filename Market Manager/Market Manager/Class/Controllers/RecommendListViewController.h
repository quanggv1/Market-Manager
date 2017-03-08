//
//  RecommedListViewController.h
//  Market Manager
//
//  Created by quanggv on 3/8/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

typedef void(^OnSelectedCell)(NSString *result);
@interface RecommendListViewController : UIViewController
@property (strong, nonatomic) OnSelectedCell onSelectedCell;
+ (void)showRecommendListAt:(UIViewController *)controller
                 viewSource:(UIView *)view
                 recommends:(NSArray *)recommends
                 onSelected:(OnSelectedCell)callback;
+ (void)updateRecommedListWith:(NSString *)keySearch;
@end
