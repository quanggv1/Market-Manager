//
//  WhExpectedTableViewCell.m
//  Market Manager
//
//  Created by quanggv on 6/20/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "WhExpectedTableViewCell.h"
#import "ShopManager.h"
#import "WhExpectedCollectionViewCell.h"

@interface WhExpectedTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) NSMutableDictionary *theDictionary;
@property (nonatomic, strong) NSMutableArray *shops;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation WhExpectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheDictionary:(NSMutableDictionary *)theDictionary
{
    if (!_shops) {
        _shops = [[NSMutableArray alloc] init];
        for (NSString *item in [[ShopManager sharedInstance] getShopNameList]) {
            [_shops addObject:item];
        }
    }
    _theDictionary = theDictionary;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _shops.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WhExpectedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WhExpectedCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    NSString *key = _shops[index];
    [cell setValueAt:index dict:_theDictionary key:key];
    return cell;
}


@end
