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
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *productQuantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *wareHouseTextField;
@end
@implementation OrderProductTableViewCell {
    OrderDropDownListViewController *orderDropDownList;
    id controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _productNameTextField.delegate = self;
    _productQuantityTextField.delegate = self;
    _wareHouseTextField.delegate = self;
    
    [_productNameTextField addTarget:self
                              action:@selector(productNameTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    [_wareHouseTextField addTarget:self
                            action:@selector(productNameTextFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
}

- (void)productNameTextFieldDidChange:(UITextField *)textField {
    [orderDropDownList updateRecommedListWith:textField.text];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _productQuantityTextField) {
        
    } else {
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
    if(textField == _productNameTextField) {
        [orderDropDownList setRecommendList:kProductTableName];
    } else {
        [orderDropDownList setRecommendList:kShopTableName];
    }
}


@end
