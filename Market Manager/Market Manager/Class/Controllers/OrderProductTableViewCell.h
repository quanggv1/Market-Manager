//
//  OrderProductTableViewCell.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Product.h"
typedef void(^completion)(BOOL);
@class OrderProductTableViewCell;
@protocol OrderProductDelegate <NSObject>
- (void)textFieldDidEndEditingFinish:(OrderProductTableViewCell *)cell textField:(UITextField *)text :(completion) complete;
@end
@interface OrderProductTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, retain) id<OrderProductDelegate> delegate;
- (void)setProduct:(Product *)product;
@end
