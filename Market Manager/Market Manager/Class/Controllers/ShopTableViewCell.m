//
//  ShopTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "ShopPopOverViewController.h"

@interface ShopTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) Shop *shop;
@end

@implementation ShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWith:(Shop *)shop {
    if(!_shop) {
        _shop = shop;
        _shopName.text = _shop.name;
    }
}

- (IBAction)onExtendClicked:(id)sender {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    ShopPopOverViewController *vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardShopPopover];
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
