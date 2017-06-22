//
//  SupplyPalletTableViewCell.m
//  Market Manager
//
//  Created by Quang on 6/22/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyPalletTableViewCell.h"
#import "RecommendListViewController.h"

@interface SupplyPalletTableViewCell()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel        *indexLabel;
@property (nonatomic, weak) IBOutlet UILabel        *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField    *textField;
@property (nonatomic, weak) NSMutableDictionary *dictionary;
@property (nonatomic, weak) NSArray             *supplies;
@property (nonatomic, weak) id controller;
@end

@implementation SupplyPalletTableViewCell

- (id)controller {
    if(!_controller) {
        UIView *view = self;
        while (!(view == nil || [view isKindOfClass:[UITableView class]])) {
            view = view.superview;
        }
        _controller = ((UITableView *)view).dataSource;
    }
    return _controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWith:(NSString *)index dictionary:(NSMutableDictionary *)dictionary supplies:(NSArray *)supplies
{
    _dictionary = dictionary;
    _indexLabel.text = index;
    _supplies = supplies;
    
    NSString *name = _dictionary.allKeys[0];
    NSString *number = [NSString stringWithFormat:@"%@", [_dictionary objectForKey:name]];
    
    _nameLabel.text = name;
    _textField.text = number;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([_nameLabel.text containsString:@"Pallet type From"]) {
        [RecommendListViewController showRecommendListAt:self.controller
                                              viewSource:textField
                                              recommends:_supplies
                                              onSelected:^(NSString *result) {
                                                  textField.text = result;
                                                  [_dictionary setValue:result forKey:_nameLabel.text];
                                              }];
        [Utils hideKeyboard];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [_dictionary setValue:textField.text forKey:_nameLabel.text];
}



@end
