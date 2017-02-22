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

@interface SupplyViewController ()<UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *supplyTableView;
@property (strong, nonatomic) NSMutableArray *supplies;

@end

@implementation SupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _supplyTableView.delegate = self;
    _supplyTableView.dataSource = self;
    [self download];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteItem:)
                                                 name:NotifySupplyDeletesItem
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deleteItem:(NSNotification *)notificaion {
    NSIndexPath *indexPath = [notificaion object];
    [_supplies removeObjectAtIndex:indexPath.row];
    [_supplyTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenuClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyShowHideMenu object:nil];
}


- (void)download {
    Supply *supply1 = [[Supply alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"supply1",@"name", nil]];
    Supply *supply2 = [[Supply alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"supply2",@"name", nil]];
    Supply *supply3 = [[Supply alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"supply3",@"name", nil]];
    Supply *supply4 = [[Supply alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"supply4",@"name", nil]];
    Supply *supply5 = [[Supply alloc] initWith:[NSDictionary dictionaryWithObjectsAndKeys:@"supply5",@"name", nil]];
    
    _supplies = [[NSMutableArray alloc] initWithArray:@[supply1, supply2, supply3, supply4, supply5]];
    [_supplyTableView reloadData];
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _supplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellSupply];
    [cell initWith: [_supplies objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SegueSupplyDetail sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SegueSupplyDetail]) {
        SupplyDetailViewController *vc = segue.destinationViewController;
        vc.supply = _supplies[_supplyTableView.indexPathForSelectedRow.row];
    }
}



@end
