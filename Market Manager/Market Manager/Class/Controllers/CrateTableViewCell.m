//
//  CrateTableViewCell.m
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateTableViewCell.h"

@interface CrateTableViewCell()
@property (weak, nonatomic) Crate *crate;
@property (weak, nonatomic) IBOutlet UILabel *crateIdLable;
@property (weak, nonatomic) IBOutlet UILabel *crateNameLable;
@end

@implementation CrateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCrate:(Crate *)crate {
    _crate = crate;
    _crateIdLable.text = crate.ID;
    _crateNameLable.text = crate.name;
}

@end
