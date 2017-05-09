//
//  Loading.h
//  Market Manager
//
//  Created by quanggv on 5/9/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loading : NSObject
+ (instancetype)shareInstance;
- (void)showAt:(UIView *)view;
- (void)hide;
@end
