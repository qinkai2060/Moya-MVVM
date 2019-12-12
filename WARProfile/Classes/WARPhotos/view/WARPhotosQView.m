//
//  WARPhotosQView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import "WARPhotosQView.h"
#import "WARPhotosCollectionCell.h"
#import "WARMacros.h"
#import "WARPhotoModel.h"
@implementation WARPhotosQView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}
- (void)setPhotoArray:(NSArray *)photoArray{
    _photoArray = photoArray;
    
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    // 多组
    return self.photoArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WARPhotoModel *photomodel = self.photoArray[section];

    return photomodel.ModthArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARPhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    WARPhotoModel *photomodel = self.photoArray[indexPath.section];
    TZAssetModel *assetModel = photomodel.ModthArray[indexPath.row];
    cell.model = assetModel;
//    cell.textlb.text = [NSString stringWithFormat:@"%ld--%ld",indexPath.section,indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (WARPhotosCollectionView *)collectionView{
    if (!_collectionView )
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        flowLayout.itemSize = CGSizeMake((kScreenWidth-11)/4,126);
        flowLayout.sectionInset = UIEdgeInsetsMake(0,1, 0,2.5);
        _collectionView = [[WARPhotosCollectionView alloc] initWithFrame:CGRectMake(0, 0,   kScreenWidth, 127) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WARPhotosCollectionCell class] forCellWithReuseIdentifier:@"photoCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;

    }
    return _collectionView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([scrollView isKindOfClass:[WARPhotosCollectionView class]]){
        NSArray *arrIndex = [self.collectionView indexPathsForVisibleItems];
        NSIndexPath *indextPath = [arrIndex firstObject];
        
        if ([self.delegate respondsToSelector:@selector(WARPhotosQView:willDisplay:)]) {
            [self.delegate WARPhotosQView:self willDisplay:indextPath.section];
        }
        
    }
}
- (void)gestureBegan:(WARPhotosCollectionView *)collectionView tempview:(UIView *)tempView{
    if ([self.delegate respondsToSelector:@selector(gestureBegan:tempview:data:)]) {
        [self.delegate gestureBegan:self tempview:tempView data:collectionView.selectedIndexPath];
    }
}
- (void)gestureChange:(WARPhotosCollectionView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point{
    
    if ([self.delegate respondsToSelector:@selector(gestureChange:tempview:point:data:)]) {
        [self.delegate gestureChange:self tempview:tempView point:point data:collectionView.selectedIndexPath];
    }
}
- (void)gestureEnd:(WARPhotosCollectionView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point atCell:(WARPhotosCollectionCell *)cell{
    if ([self.delegate respondsToSelector:@selector(gestureEnd:tempview:point:data:)]) {
        WARPhotoModel *photomodel = self.photoArray[collectionView.selectedIndexPath.section];
        TZAssetModel *assetModel = photomodel.ModthArray[collectionView.selectedIndexPath.row];
        [self.delegate gestureEnd:self tempview:tempView point:point data:assetModel];
    }
}
@end
