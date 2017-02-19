//
//  SupplyTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyTableViewCell.h"
#import "SupplyPopOverViewController.h"

@interface SupplyTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *supplyImage;
@property (weak, nonatomic) IBOutlet UILabel *supplyName;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) Supply *supply;

@end

@implementation SupplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWith:(Supply *)supply {
    if(!_supply) {
        _supply = supply;
        _supplyName.text = _supply.name;
    }
}

- (IBAction)onExtendClicked:(id)sender {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    SupplyPopOverViewController *vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardSupplyPopover];
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