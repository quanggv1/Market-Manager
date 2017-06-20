//
//  WhExpectedCollectionViewCell.m
//  Market Manager
//
//  Created by quanggv on 6/20/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "WhExpectedCollectionViewCell.h"
#import "Data.h"
#import "SupplyManager.h"

@interface WhExpectedCollectionViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *theTextField;

@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, weak) NSMutableDictionary *dictionary;
@property (nonatomic, copy) NSString            *key;

@end

@implementation WhExpectedCollectionViewCell

- (void)setValueAt:(NSInteger)index dict:(NSMutableDictionary *)productDic key:(NSString *)key
{
    _index = index;
    _dictionary = productDic;
    _key = key;
    _theTextField.text = [NSString stringWithFormat:@"%@",[_dictionary objectForKey:_key]];
    _theTextField.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *oldValue = [NSString stringWithFormat:@"%@", [_dictionary objectForKey:_key]];
    
    if ([oldValue isEqualToString:textField.text]) return;
    
    [self updateWarehouseExpected:textField.text];
}

- (void)updateWarehouseExpected:(NSString *)value
{
    NSDictionary *params = @{kShopName: _key,
                             kId: [NSString stringWithFormat:@"%@", [_dictionary objectForKey:kId]],
                             kWhName: [[SupplyManager sharedInstance] getCurrentWarehouseName],
                             @"value": value,
                             kProductID: [NSString stringWithFormat:@"%@", [_dictionary objectForKey:kProductID]],
                             kDate: [Utils stringTodayDateTime]};
    [[Data sharedInstance] get:API_UPDATE_WAREHOUSE_EXPECTED data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [_dictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:_key];
        } else {
            
        }
        _theTextField.text = [NSString stringWithFormat:@"%@", [_dictionary objectForKey:_key]];
    } error:^{
        _theTextField.text = [NSString stringWithFormat:@"%@", [_dictionary objectForKey:_key]];
        ShowMsgConnectFailed;
    }];
}

@end
