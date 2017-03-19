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
    _textField.enabled = ![key isEqualToString:kProductOrder];
    _textField.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([_key isEqualToString:kCrateType]) {
        [RecommendListViewController showRecommendListAt:self.controller viewSource:textField recommends:[[CrateManager sharedInstance] getCrateNameList] onSelected:^(NSString *result) {
            textField.text = result;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([[[SupplyManager sharedInstance] getSupplyNameList] containsObject:_key]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{kProductID:[_productDic objectForKey:kProductID],
                                 @"receivedQty": _textField.text,
                                 kWhName: _key};
        [manager GET:API_CHECK_TOTAL_WAREHOUSE_PRODUCTS
          parameters:params
            progress:nil
             success:^(NSURLSessionDataTask * task, id responseObject) {
                 if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                     [_productDic setValue:_textField.text forKey:_key];
                 } else {
                     _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
                     [CallbackAlertView setCallbackTaget:titleError message:@"Please input number no more than number of warehouse's product" target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil];
                 }
             } failure:^(NSURLSessionDataTask * task, NSError * error) {
                 _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
                 ShowMsgConnectFailed;
             }];
    } else if([_key isEqualToString:kCrateQty]) {
        if(![[[CrateManager sharedInstance] getCrateNameList] containsObject:[NSString stringWithFormat:@"%@", [_productDic objectForKey:kCrateType]]]) {
            _textField.text = [NSString stringWithFormat:@"%@",[_productDic objectForKey:_key]];
            [CallbackAlertView setCallbackTaget:titleError message:@"Please input correct crate type" target:self okTitle:btnOK okCallback:nil cancelTitle:nil cancelCallback:nil];
        } else {
            [_productDic setValue:_textField.text forKey:_key];
        }
    } else {   
        [_productDic setValue:_textField.text forKey:_key];
    }
}
@end
