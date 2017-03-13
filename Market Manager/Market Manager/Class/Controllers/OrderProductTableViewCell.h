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
@property (weak, nonatomic) IBOutlet UITextField *wh1TextField;
@property (weak, nonatomic) IBOutlet UITextField *wh2TextField;
@property (weak, nonatomic) IBOutlet UITextField *whTLTextField;
- (void)setProduct:(Product *)product;
@end
