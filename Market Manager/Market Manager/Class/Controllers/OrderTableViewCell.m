//
//  OrderTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *dateOrderLabel;
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

-(void)setOrder:(Order *)order {
    _order = order;
    _dateOrderLabel.text = [NSString stringWithFormat:@"%@         ID: %@", _order.date, _order.ID];
    switch (_order.status) {
        case 0:
            _statusView.backgroundColor = [UIColor greenColor];
            break;
        case 1:
            _statusView.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            _statusView.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
}


@end
