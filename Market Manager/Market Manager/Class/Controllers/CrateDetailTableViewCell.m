//
//  CrateDetailTableViewCell.m
//  Market Manager
//
//  Created by Quang on 4/2/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateDetailTableViewCell.h"

@interface CrateDetailTableViewCell()<UITextFieldDelegate>
@property (nonatomic, weak) Crate *crate;
@property (nonatomic, weak) IBOutlet UILabel *crateTypeLabel;
@property (nonatomic, weak) IBOutlet UITextField *priceField;
@end

@implementation CrateDetailTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _priceField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCrate:(Crate *)crate {
    _crate = crate;
    _crateTypeLabel.text = _crate.name;
    _priceField.text = [NSString stringWithFormat:@"%.2f", _crate.price];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(![textField.text isEqualToString:@""])
        _crate.price = [_priceField.text floatValue];
    _priceField.text = @(_crate.price).stringValue;
}

@end
