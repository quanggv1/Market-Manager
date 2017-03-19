//
//  ProductCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) Product *product;
@end


@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(Product *)product {
    _product = product;
    _productName.text = _product.name;
    _productPrice.text = [NSString stringWithFormat:@"%.2f $", _product.price];
}


@end
