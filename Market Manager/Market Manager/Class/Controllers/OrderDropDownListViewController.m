//
//  OrderDropDownListViewController.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderDropDownListViewController.h"

@interface OrderDropDownListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderDropdownTableView;
@end

@implementation OrderDropDownListViewController {
    NSArray *orderDropdownDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    orderDropdownDatasource = @[@"1",@"2",@"3",@"4",@"5"];
    self.preferredContentSize = CGSizeMake(150, 35*orderDropdownDatasource.count);
    _orderDropdownTableView.dataSource = self;
    _orderDropdownTableView.delegate = self;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderDropdownDatasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = orderDropdownDatasource[indexPath.row];
    }
    return cell;
}
#pragma mark - TABLE DELEGATE

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
