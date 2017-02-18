//
//  ProductCell.h
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "Product.h"

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
- (void)initWith:(Product *)product;
@end
