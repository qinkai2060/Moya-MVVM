//
//  HFGlobaInterFaceNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobaInterFaceNewCell.h"
#import "HFGlobalInterFaceLittleCell.h"
@interface HFGlobaInterFaceNewCell ()

@end
@implementation HFGlobaInterFaceNewCell

+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModeGlobalInterfaceType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.trackView];
}
- (void)doMessageRendering {
    self.InterfaceModel = (HFGlobalInterfaceModel*)self.model;
    self.bgView.frame = CGRectMake((ScreenW-30)*0.5, self.collectionView.bottom, 30, 2);
    self.trackView.hidden =  !(self.InterfaceModel.dataArray.count > 10);
    self.bgView.hidden =  !(self.InterfaceModel.dataArray.count > 10);
    self.trackView.frame = CGRectMake(0, 0, 10, 2);
    if (self.InterfaceModel.dataArray.count < 10) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW/4,80);
        [self.collectionView setCollectionViewLayout:flowLayout];
    }else
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW/5,80);
        [self.collectionView setCollectionViewLayout:flowLayout];
    }
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    return  self.InterfaceModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFGlobalInterFaceLittleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LittleCell" forIndexPath:indexPath];

    HFGlobalInterfaceModel *model = self.InterfaceModel.dataArray[indexPath.row];
    cell.model = model;
    [cell doMessageRendering];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    HFGlobalInterfaceModel *model = self.InterfaceModel.dataArray[indexPath.row];
    
    if (self.didGloabalBlock) {
        self.didGloabalBlock(model);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat frameX = self.trackView.frame.origin.x;
    
    CGFloat scale =  scrollView.contentOffset.x/ABS((scrollView.contentSize.width
                                                     -ScreenW));
    frameX = scrollView.contentOffset.x*scale;
    self.trackView.frame =  CGRectMake(20*scale, 0, 10, 2);
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW/5,80);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 160) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFGlobalInterFaceLittleCell class] forCellWithReuseIdentifier:@"LittleCell"];
        //        _collectionView.pagingEnabled = YES;
        _collectionView.bounces=NO;
        
    }
    return _collectionView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return _bgView;
}
- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [[UIView alloc] init];
        _trackView.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
    }
    return _trackView;
}
@end
