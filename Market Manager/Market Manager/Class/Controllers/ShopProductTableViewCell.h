//
//  ShopProductTableViewCell.h
//  Market Manager
//
//  Created by Quang on 3/4/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//


#import "Product.h"

@interface ShopProductTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *productSTakeTextField;
- (void)setProduct:(Product *)product;
@end
