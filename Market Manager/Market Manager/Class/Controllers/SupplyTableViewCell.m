//
//  SupplyTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyTableViewCell.h"

@interface SupplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *supplyImage;
@property (weak, nonatomic) IBOutlet UILabel *supplyName;
@property (weak, nonatomic) Supply *supply;

@end

@implementation SupplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(Supply *)supply {
    _supply = supply;
    _supplyName.text = _supply.name;
}


@end
