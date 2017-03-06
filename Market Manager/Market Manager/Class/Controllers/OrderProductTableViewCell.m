//
//  OrderProductTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderProductTableViewCell.h"
#import "OrderDropDownListViewController.h"

@interface OrderProductTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productOrderLabel;
@property (weak, nonatomic) IBOutlet UITextField *wh1TextField;
@property (weak, nonatomic) IBOutlet UITextField *wh2TextField;
@property (weak, nonatomic) IBOutlet UITextField *whTLTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateQtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *crateTypeTextField;
@property (weak, nonatomic) Product *product;
@end
@implementation OrderProductTableViewCell {
    OrderDropDownListViewController *orderDropDownList;
    id controller;
}

-(void)setProduct:(Product *)product {
    _product = product;
    _productNameLabel.text = _product.name;
    _productOrderLabel.text = [NSString stringWithFormat:@"%ld", _product.order];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _wh1TextField.delegate = self;
    _wh2TextField.delegate = self;
    _whTLTextField.delegate = self;
    _crateQtyTextField.delegate = self;
    _crateTypeTextField.delegate = self;
    
    [_crateTypeTextField addTarget:self
                              action:@selector(crateTypeTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
}

- (void)crateTypeTextFieldDidChange:(UITextField *)textField {
    [orderDropDownList updateRecommedListWith:textField.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _crateTypeTextField) {
        [self showPopUpAt:textField];
        [orderDropDownList onSelected:^(NSString *result) {
            [textField setText:result];
            [Utils hideKeyboard];
        }];
    }
}

- (void)showPopUpAt:(UITextField *)textField {
    if(!orderDropDownList) {
        UIView *view = self;
        while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
            view = view.superview;
        }
        controller = ((UITableView *)view).dataSource;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
        orderDropDownList = [storyboard instantiateViewControllerWithIdentifier:StoryboardOrderDropdownList];
        orderDropDownList.modalPresentationStyle = UIModalPresentationPopover;
    }
    UIPopoverPresentationController * popOverController = orderDropDownList.popoverPresentationController;
    [popOverController setDelegate:controller];
    popOverController.sourceView = textField;
    popOverController.sourceRect = textField.bounds;
    popOverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [controller presentViewController:orderDropDownList
                             animated:YES
                           completion:nil];
}


@end
