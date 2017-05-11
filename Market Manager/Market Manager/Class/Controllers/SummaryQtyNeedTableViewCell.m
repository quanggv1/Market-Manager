//
//  SupplyTableViewCell.m
//  Market Manager
//
//  Created by Quang on 2/18/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "SummaryQtyNeedTableViewCell.h"

@interface SummaryQtyNeedTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *productContentCollection;
@property (strong, nonatomic) NSArray *productContentList;
@end

@implementation SummaryQtyNeedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _productContentCollection.dataSource = self;
    _productContentCollection.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setProductContentList:(NSArray *)productContentList {
    _productContentList = productContentList;
    [_productContentCollection reloadData];
}

#pragma mark - COLLECTION DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _productContentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qtyNeedReportContentCollectionId" forIndexPath:indexPath];
    return cell;
}


@end
