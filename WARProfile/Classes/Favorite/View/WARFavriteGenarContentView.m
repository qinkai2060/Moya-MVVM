//
//  WARFavriteGenarContentView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteGenarContentView.h"
#import "WARFavriteCenarContenCell.h"
#import "WARMacros.h"
#import "WARFavoriteModel.h"
@implementation WARFavriteGenarContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        if (isIOS11) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)setTypeContenArray:(NSArray *)typeContenArray {
    _typeContenArray = typeContenArray;
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  self.typeContenArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARFavriteCenarContenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    NSDictionary *dict = self.typeContenArray[indexPath.item];
    cell.contentArray = [dict valueForKey:@"favorite"];
    
    return cell;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(favriteGenarContentView:moveEndAtIndex:)]) {
        int index = scrollView.contentOffset.x / kScreenWidth;
        
        [self.delegate favriteGenarContentView:self moveEndAtIndex:index];
    }
    
}

- (void)selectIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(kScreenWidth,CGRectGetHeight(self.frame));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WARFavriteCenarContenCell class] forCellWithReuseIdentifier:@"contentCell"];
    }
    return _collectionView;
}
@end
