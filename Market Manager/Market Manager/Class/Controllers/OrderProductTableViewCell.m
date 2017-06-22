//
//  OrderProductTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 2/23/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "OrderProductTableViewCell.h"
#import "RecommendListViewController.h"
#import "OrderDetailViewController.h"
#import "OrderDetailCollectionViewCell.h"

@interface OrderProductTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) NSDictionary *productDic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id controller;
@end

@implementation OrderProductTableViewCell
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

- (void)setProductDic:(NSDictionary *)productDic {
    _productDic = productDic;
    [_collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((OrderDetailViewController *)self.controller).titleContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"orderDetailCollectionViewCellID" forIndexPath:indexPath];
    NSString *key = (((OrderDetailViewController *)self.controller).titleContents[indexPath.row]);
    if ([key isEqualToString:@"Order"]) {
        key = kProductOrder;
    } else if ([key isEqualToString:@"Crate Q.ty"]) {
        key = kCrateQty;
    } else if ([key isEqualToString:@"Crate Type"]) {
        key = kCrateType;
    }
    [cell setValueAt:indexPath.row dict:_productDic key:key];
    return cell;
}

@end
