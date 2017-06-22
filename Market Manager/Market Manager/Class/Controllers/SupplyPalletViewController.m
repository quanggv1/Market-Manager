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

@interface SupplyPalletViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *theArray;
@property (nonatomic, strong) NSArray *warehouses;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SupplyPalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _warehouses = [[SupplyManager sharedInstance] getSupplyNameList];
    [self getDataWithId:_wh_pd_ID];
}

- (void)getDataWithId:(NSString *)Id
{
    NSDictionary *params = @{kProductWareHouseID: Id};
    
    [[Data sharedInstance] get:API_GET_WH_PRODUCT_W_ID data:params success:^(id res) {
        if ([[res objectForKey:kCode] integerValue] == kResSuccess) {
            NSDictionary *data = [res objectForKey:kData][0];
            _theArray = [[NSMutableArray alloc] init];
            for (NSString *whName in _warehouses) {
                NSString *inWh = [@"In from " stringByAppendingString:whName];
                NSString *palletType = [@"Pallet type From " stringByAppendingString:whName];
                NSString *palletNumber = [@"Number of pallet From " stringByAppendingString:whName];
                
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[data objectForKey:inWh]
                                                                        forKey:inWh]];
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[data objectForKey:palletType]
                                                                        forKey:palletType]];;
                [_theArray addObject:[NSMutableDictionary dictionaryWithObject:[data objectForKey:palletNumber]
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

@end
