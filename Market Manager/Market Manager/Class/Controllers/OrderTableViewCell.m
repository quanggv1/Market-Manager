//
//  OrderTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "OrderPopOverViewController.h"

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) Order *order;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(Order *)order {
    if(!_order) {
        _order = order;
        _orderName.text = _order.name;
    }
}

- (IBAction)onExtendClicked:(id)sender {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    OrderPopOverViewController *vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardOrderPopover];
    vc.selectedIndexPath = [((UITableView *)view) indexPathForCell:self];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController * popOverController = vc.popoverPresentationController;
    [popOverController setDelegate:controller];
    popOverController.sourceView = self.extendButton;
    popOverController.sourceRect = self.extendButton.bounds;
    popOverController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [controller presentViewController:vc
                             animated:YES
                           completion:nil];
    
}

@end
