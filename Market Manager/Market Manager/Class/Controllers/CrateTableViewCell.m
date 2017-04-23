//
//  CrateTableViewCell.m
//  Market Manager
//
//  Created by Quang on 3/12/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "CrateTableViewCell.h"

@interface CrateTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) Crate *crate;
@property (weak, nonatomic) IBOutlet UILabel *crateNameLable;
@property (weak, nonatomic) IBOutlet UITextField *qtyInField;
@property (weak, nonatomic) IBOutlet UITextField *qtyOutField;
@property (weak, nonatomic) IBOutlet UITextField *totalField;
@property (weak, nonatomic) id controller;
@end

@implementation CrateTableViewCell

- (id)controller {
    if(!_controller) {
        UIView *view = self;
        while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
            view = view.superview;
        }
        _controller = ((UITableView *)view).dataSource;
    }
    return _controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _qtyInField.delegate = self;
    _qtyOutField.delegate = self;
    _totalField.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCrate:(Crate *)crate {
    _crate = crate;
    _crateNameLable.text = crate.provider;
    _qtyInField.text = @(_crate.qtyIn).stringValue;
    _qtyOutField.text = @(_crate.qtyOut).stringValue;
    _totalField.text = @(_crate.total).stringValue;;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger qtyIn = [_qtyInField.text integerValue];
    NSInteger qtyOut = [_qtyOutField.text integerValue];
    NSInteger total = (qtyIn - _crate.qtyIn) - (qtyOut - _crate.qtyOut) + _crate.total;
    if (total >= 0) {
        _crate.qtyIn = qtyIn;
        _crate.qtyOut = qtyOut;
        _crate.total = total;
    } else {
        [CallbackAlertView setBlock:@""
                            message:@"Please input correct!"
                            okTitle:btnOK
                            okBlock:nil
                        cancelTitle:nil
                        cancelBlock:nil];
    }
    [self setCrate:_crate];
}

@end
