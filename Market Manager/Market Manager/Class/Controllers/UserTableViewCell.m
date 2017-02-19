//
//  UserTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UserPopOverViewController.h"

@interface UserTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) User *user;
@end

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initWith:(User *)user {
    if(!_user) {
        _user = user;
        _userName.text = _user.name;
    }
}

- (IBAction)onExtendClicked:(id)sender {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    UserPopOverViewController *vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardUserPopover];
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
