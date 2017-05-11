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
@property (weak, nonatomic) NSDictionary *productContent;
@property (weak, nonatomic) NSArray *titleList;
@end

@implementation SummaryQtyNeedTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _productContentCollection.dataSource = self;
    _productContentCollection.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setProductContent:(NSDictionary *)productContent titles:(NSArray *)titles
{
    _productContent = productContent;
    _titleList = titles;
    [_productContentCollection reloadData];
}

#pragma mark - COLLECTION DATASOURCE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titleList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(120, 50);
    } else {
        return CGSizeMake(80, 50);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qtyNeedReportContentCollectionId" forIndexPath:indexPath];
    UILabel *contentLabel = [cell viewWithTag:kContentTag];
    NSString *contentKey = _titleList[indexPath.row];
    if (indexPath.row == 0) {
        contentLabel.text = [NSString stringWithFormat:@"%@", [_productContent objectForKey:contentKey]];
    } else {
        contentLabel.text = [NSString stringWithFormat:@"%ld", [[_productContent objectForKey:contentKey] integerValue]];
    }
    
    return cell;
}


@end
