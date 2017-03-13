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
@property (weak, nonatomic) IBOutlet UILabel *crateIdLable;
@property (weak, nonatomic) IBOutlet UILabel *crateNameLable;
@property (weak, nonatomic) IBOutlet UITextField *crateReceived;
@property (weak, nonatomic) IBOutlet UITextField *crateReturned;
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
    _crateReturned.delegate = self;
    _crateReceived.delegate = self;
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
    _crateReceived.text = @(crate.receivedQty).stringValue;
    _crateReturned.text = @(crate.returnedQty).stringValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([_crateReturned.text integerValue] > _crate.receivedQty) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:titleError
                                                                       message:@"Number of crate had been returned incorrect!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:btnOK style:UIAlertActionStyleDefault
                                                              handler:nil];
        
        [alert addAction:defaultAction];
        [self.controller presentViewController:alert animated:YES completion:nil];
    } else {
        _crate.returnedQty = [_crateReturned.text integerValue];
    }
    _crateReturned.text = @(_crate.returnedQty).stringValue;
    
}

@end
