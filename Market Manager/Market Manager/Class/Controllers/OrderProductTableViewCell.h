//
//  OrderProductTableViewCell.h
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Product.h"
@interface OrderProductTableViewCell : UITableViewCell <UITextFieldDelegate>
- (void)setProductDic:(NSDictionary *)productDic;
@end
