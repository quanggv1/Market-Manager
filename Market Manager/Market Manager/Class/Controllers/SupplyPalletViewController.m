//
//  SupplyPalletViewController.m
//  Market Manager
//
//  Created by quanggv on 6/22/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyPalletViewController.h"
#import "Data.h"
#import "SupplyManager.h"
#import "SupplyPalletTableViewCell.h"

@interface SupplyPalletViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *theArray;
@property (nonatomic, strong) NSMutableArray *supplies;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SupplyPalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self getDataWithId:_wh_pd_ID];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)onSave
{
    [Utils hideKeyboard];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSInteger whIn = 0;
    for (NSDictionary *dict in _theArray) {
        NSString *key = dict.allKeys[0];
        [data setValue:[NSString stringWithFormat:@"%@", [dict objectForKey:key]] forKey:key];
        if ([key containsString:@"In from "]) {
            whIn += [[dict objectForKey:key] integerValue];
        }
    }
    [data setValue:@(whIn) forKey:@"inQuantity"];
    
    NSDictionary *params = @{kProductWareHouseID: _wh_pd_ID,
                             kData: [Utils objectToJsonString:data]};
    [[Data sharedInstance] get:API_UPDATE_WHPRODUCT_W_ID data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (void)onCancel
{
    [Utils hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataWithId:(NSString *)Id
{
    NSDictionary *params = @{kProductWareHouseID: Id};
    
    [[Data sharedInstance] get:API_GET_WH_PRODUCT_W_ID data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            
            NSDictionary *product = [[res objectForKey:kData] objectForKey:@"product"];
            
            _supplies = [[NSMutableArray alloc] init];
            _theArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in [[res objectForKey:kData] objectForKey:@"suppliers"]) {
                [_supplies addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"provider"]]];
            }
            
            for (NSString *whName in _supplies) {
                NSString *inWh = [@"In from " stringByAppendingString:whName];
                NSString *palletType = [@"Pallet type From " stringByAppendingString:whName];
                NSString *palletNumber = [@"Number of pallet From " stringByAppendingString:whName];
                
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[product objectForKey:inWh]
                                                                        forKey:inWh]];
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[product objectForKey:palletType]
                                                                        forKey:palletType]];;
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[product objectForKey:palletNumber]
                                                                        forKey:palletNumber]];;
            }
            [_tableView reloadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _theArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplyPalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *index = @(indexPath.row + 1).stringValue;
    [cell setCellWith:index dictionary:_theArray[indexPath.row] supplies:_supplies];
    return cell;
}

@end
