//
//  ProductCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "ProductCell.h"
#import "ProductPopOverViewController.h"

@interface ProductCell()
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) Product *product;
@end


@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWith:(Product *)product {
    _product = product;
    _productName.text = _product.name;
    _productPrice.text = [NSString stringWithFormat:@"%.2f $", _product.price];
}

- (IBAction)onExtendClicked:(id)sender {
    UIView *view = self;
    while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
        view = view.superview;
    }
    id controller = ((UITableView *)view).dataSource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
    ProductPopOverViewController *vc = [storyboard instantiateViewControllerWithIdentifier:StoryboardProductPopover];
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
