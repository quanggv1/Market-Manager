//
//  SupplyViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 2/15/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SupplyViewController.h"
#import "Supply.h"
#import "SupplyTableViewCell.h"
#import "SupplyDetailViewController.h"
#import "AddNewSupplyViewController.h"
#import "SupplyManager.h"
#import "Data.h"

@interface SupplyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;
@property (strong, nonatomic) NSMutableArray *warehouses;

@end

@implementation SupplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _supplyTableView.delegate = self;
    _supplyTableView.dataSource = self;
    
    [self loadData];
}

- (void)loadData
{
    _warehouses = [NSMutableArray arrayWithArray:[self getWarehouses]];
    [_supplyTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Ware House";
}

- (NSArray *)getWarehouses
{
    return [[SupplyManager sharedInstance] getWarehouses];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath
{
    Supply *supply = _warehouses[indexPath.row];
    NSDictionary *params = @{kSupplyName:supply.name};
    [[Data sharedInstance] get:API_REMOVE_WAREHOUSE data:params success:^(id res) {
        if([[res objectForKey:kCode] integerValue] == kResSuccess) {
            [[SupplyManager sharedInstance] delete:supply];
            [self loadData];
        } else {
            ShowMsgSomethingWhenWrong;
        }
    } error:^{
        ShowMsgConnectFailed;
    }];
}

- (IBAction)onAddNewSupply:(id)sender
{
    if(![Utils hasWritePermission:kSupplyTableName notify:YES]) return;
    [AddNewSupplyViewController showViewAt:self onSave:^(Supply *supply) {
        [self loadData];
    }];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _warehouses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSupply];
    [cell initWith: [_warehouses objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Supply *warehouse = _warehouses[indexPath.row];
    if([Utils hasReadPermission:warehouse.name]) {
        [self performSegueWithIdentifier:SegueSupplyDetail sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAt:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utils hasWritePermission:kSupplyTableName notify:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SegueSupplyDetail]) {
        SupplyDetailViewController *vc = segue.destinationViewController;
        vc.supply = _warehouses[_supplyTableView.indexPathForSelectedRow.row];
    }
}


@end
