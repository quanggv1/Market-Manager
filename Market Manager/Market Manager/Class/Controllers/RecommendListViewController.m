//
//  RecommedListViewController.m
//  Market Manager
//
//  Created by quanggv on 3/8/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "RecommendListViewController.h"

static RecommendListViewController *recommendListViewCtrl;
@interface RecommendListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recommendTableView;
@property (strong, nonatomic) NSArray *recommendList;
@end

@implementation RecommendListViewController {
    NSArray *orderDropdownDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _recommendTableView.dataSource = self;
    _recommendTableView.delegate = self;
    [self setupRecommendList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    recommendListViewCtrl = nil;
    [Utils hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateRecommedListWith:(NSString *)keySearch {
    if(!keySearch || keySearch.length == 0) {
        orderDropdownDatasource = _recommendList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", keySearch];
        orderDropdownDatasource = [NSMutableArray arrayWithArray:[_recommendList filteredArrayUsingPredicate:predicate]];
    }
    [self reloadData];
}

- (void)setupRecommendList {
    orderDropdownDatasource = [_recommendList subarrayWithRange:NSMakeRange(0, (_recommendList.count >= 6) ? 5 : _recommendList.count)];
    [self reloadData];
}

- (void)reloadData {
    [_recommendTableView reloadData];
    self.preferredContentSize = CGSizeMake(150, _recommendTableView.contentSize.height + 10);
}


#pragma mark - TABLE DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderDropdownDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = orderDropdownDatasource[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - TABLE DELEGATE
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _onSelectedCell(orderDropdownDatasource[indexPath.row]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showRecommendListAt:(UIViewController *)controller
                 viewSource:(UIView *)view
                 recommends:(NSArray *)recommends
                 onSelected:(OnSelectedCell)callback {
    if(!recommendListViewCtrl) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMain bundle:nil];
        recommendListViewCtrl = [storyboard instantiateViewControllerWithIdentifier:StoryboardRecommendList];
        recommendListViewCtrl.modalPresentationStyle = UIModalPresentationPopover;
        
        UIPopoverPresentationController * popOverController = recommendListViewCtrl.popoverPresentationController;
        [popOverController setDelegate:(id)controller];
        popOverController.sourceView = view;
        popOverController.sourceRect = view.bounds;
        popOverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        recommendListViewCtrl.onSelectedCell = callback;
        recommendListViewCtrl.recommendList = recommends;
        [controller presentViewController:recommendListViewCtrl
                                 animated:YES
                               completion:nil];
    }
}

+ (void)updateRecommedListWith:(NSString *)keySearch {
    [recommendListViewCtrl updateRecommedListWith:keySearch];
}



@end

