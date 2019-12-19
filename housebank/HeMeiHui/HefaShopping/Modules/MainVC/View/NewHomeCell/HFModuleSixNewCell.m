//
//  HFModuleSixNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleSixNewCell.h"
#import "HFModuleSixSmallCell.h"
@implementation HFModuleSixNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeSixType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.collectionView];
}
- (void)doMessageRendering {
    self.sixModel = (HFModuleSixModel*)self. model;

    self.collectionView.frame = CGRectMake(0, 0, ScreenW, self.sixModel.rowheight);
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.sixModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFModuleSixSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFModuleSixSmallCell class]) forIndexPath:indexPath];
    
    HFModuleSixModel *model = self.sixModel.dataArray[indexPath.row];
    cell.model = model;
    [cell doMessgaSommthing];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HFModuleSixModel *model = self.sixModel.dataArray[indexPath.row];
    if (self.didModuleSixBlock) {
        self.didModuleSixBlock(model);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((ScreenW-25)*0.5,120);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFModuleSixSmallCell class] forCellWithReuseIdentifier:NSStringFromClass([HFModuleSixSmallCell class])];
        //        _collectionView.pagingEnabled = YES;
        _collectionView.bounces=NO;
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}
@end
