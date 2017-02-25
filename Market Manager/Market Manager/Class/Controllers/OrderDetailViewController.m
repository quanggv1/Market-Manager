//
//  OrderDetailViewController.m
//  Market Manager
//
//  Created by Quang on 2/19/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UITableView *orderFormTableView;
@property (strong, nonatomic) NSMutableArray *productOrderList;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderNameLbl.text = _order.name;
    _orderFormTableView.dataSource = self;
    _orderFormTableView.delegate = self;
    _productOrderList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddNewProductOrder:(id)sender {
    [_productOrderList addObject:@"1"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_productOrderList.count -1) inSection:0];
    [_orderFormTableView insertRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - TABLE DATASOUCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellProductOrder];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - TABLE DELEGATE
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_productOrderList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - POPOVER DELEGATE
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}




@end
