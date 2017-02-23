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
@implementation OrderProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _productNameTextField.delegate = self;
    _productQuantityTextField.delegate = self;
    _wareHouseTextField.delegate = self;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    OrderDropDownListViewController* vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardOrderDropdownList];
    //    vc.selectedIndexPath = [((UITableView *)view) indexPathForCell:self];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController * popOverController = vc.popoverPresentationController;
    [popOverController setDelegate:controller];
    popOverController.sourceView = textField;
    popOverController.sourceRect = textField.bounds;
    popOverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [controller presentViewController:vc
                             animated:YES
                           completion:nil];
}


@end
