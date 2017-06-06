//
//  OrderTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 6/6/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()
@property (nonatomic, weak) Order *order;
@property (nonatomic, weak) IBOutlet UIButton *showOrderReportButton;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _showOrderReportButton.hidden = ([[ProductManager sharedInstance] getProductType] == kFoods);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onEditClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowOrderDetail object:_order];
}

- (IBAction)onShowReport:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowOrderReport object:_order];
}

- (IBAction)onCreateInvoice:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowOrderInvoice object:_order];
}

- (void)setOrder:(Order *)order
{
    _order = order;
}

@end
