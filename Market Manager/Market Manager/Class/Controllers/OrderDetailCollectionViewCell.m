//
//  OrderDetailCollectionViewCell.m
//  Market Manager
//
//  Created by quanggv on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDetailCollectionViewCell.h"
#import "SupplyManager.h"
#import "RecommendListViewController.h"
#import "CrateManager.h"
#import "ProductManager.h"
#import "Data.h"

@interface OrderDetailCollectionViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) NSArray *contents;
@property (weak, nonatomic) NSDictionary *productDic;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) id controller;
@end

@implementation OrderDetailCollectionViewCell

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

- (void)setValueAt:(NSInteger)index dict:(NSDictionary *)productDic key:(NSString *)key {
    _index = index;
    _productDic = productDic;
    _key = key;
    _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
    _textField.delegate = self;
    if ([_key containsString:@"receive expected"] ||
        [_key containsString:@"balance of "] ||
        [_key containsString:@"Total expected"] ||
        [_key containsString:@"Total balance"]) {
        _textField.enabled = NO;
    } else {
        _textField.enabled = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([_key isEqualToString:kCrateType]) {
        NSArray *crateTypeList = [[CrateManager sharedInstance] getCrateNameList];
        [RecommendListViewController showRecommendListAt:self.controller
                                              viewSource:textField
                                              recommends:crateTypeList
                                              onSelected:^(NSString *result) {
                                                  textField.text = result;
                                                  [_productDic setValue:result forKey:_key];
                                              }];
        [Utils hideKeyboard];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[[SupplyManager sharedInstance] getSupplyNameList] containsObject:_key]) {
        [self updateWarehouse];
    } else if([_key isEqualToString:kCrateQty]) {
        NSArray *crateTypeList = [[CrateManager sharedInstance] getCrateNameList];
        NSString *crateType = [NSString stringWithFormat:@"%@", [_productDic objectForKey:kCrateType]];
        if([crateTypeList containsObject:crateType]) {
            NSInteger crateQty = [_textField.text integerValue];
            [_productDic setValue:@(crateQty) forKey:_key];
        } else {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"Please input correct crate type"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        }
        _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
    } else if([_key isEqualToString:kProductOrder]) {
        NSInteger numberOfProduct = [_textField.text integerValue];
        [_productDic setValue:@(numberOfProduct) forKey:_key];
        _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
    } else if([_key isEqualToString:kCrateType]) {
        NSArray *crateTypeList = [[CrateManager sharedInstance] getCrateNameList];
        if (![crateTypeList containsObject:_textField.text]) {
            _textField.text = @"";
        }
        [_productDic setValue:_textField.text forKey:_key];
    } else {
        [_productDic setValue:_textField.text forKey:_key];
    }
}

- (void)updateWarehouse
{
    NSInteger valueChange = [_textField.text integerValue] - [[_productDic objectForKey:_key] integerValue];
    NSDictionary *params = @{kProductID: [NSString stringWithFormat:@"%@", [_productDic objectForKey:kProductID]],
                             @"receivedQty": @(valueChange),
                             kWhName: _key,
                             kType:@([[ProductManager sharedInstance] getProductType])};
    
    [[Data sharedInstance] get:API_CHECK_TOTAL_WAREHOUSE_PRODUCTS data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSInteger numberOfProduct = [_textField.text integerValue];
            [_productDic setValue:@(numberOfProduct) forKey:_key];
            
            NSInteger totalBalance = [[_productDic objectForKey:@"Total balance"] integerValue];
            totalBalance += valueChange;
            [_productDic setValue:@(totalBalance) forKey:@"Total balance"];
            
            NSInteger balance = [[_productDic objectForKey:[@"balance of " stringByAppendingString:_key]] integerValue];
            balance += valueChange;
            [_productDic setValue:@(balance) forKey:[@"balance of " stringByAppendingString:_key]];
        } else {
            [CallbackAlertView setCallbackTaget:titleError
                                        message:@"Please input number no more than number of warehouse's product"
                                         target:self
                                        okTitle:btnOK
                                     okCallback:nil
                                    cancelTitle:nil
                                 cancelCallback:nil];
        }
        _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
    } error:^{
        ShowMsgConnectFailed;
        _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
    }];
}


@end
