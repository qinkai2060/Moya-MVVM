//
//  WARFavriteGenarSegementView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteGenarSegementView.h"
#import "WARFavriteGenarSegementCell.h"
@implementation WARFavriteGenarSegementView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionVSegment];
 
    }
    return self;
}
- (void)setSegementArr:(NSArray *)segementArr {
    _segementArr = segementArr;
    
    [self.collectionVSegment reloadData];
    [self.collectionVSegment selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return   self.segementArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARFavriteGenarSegementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segmentCell" forIndexPath:indexPath];
    NSDictionary *dict = self.segementArr[indexPath.item];
    cell.namelb.text = [dict valueForKey:@"favoriteType"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(favriteGenarSegementView:didSelectIndexPath:)]) {
        [self.delegate favriteGenarSegementView:self didSelectIndexPath:indexPath];
    }
}
- (UICollectionView *)collectionVSegment {
    if (!_collectionVSegment) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(60,40);
        
        _collectionVSegment = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,40) collectionViewLayout:flowLayout];
        _collectionVSegment.backgroundColor = [UIColor whiteColor];
        _collectionVSegment.dataSource = self;
        _collectionVSegment.delegate = self;
        _collectionVSegment.bounces = NO;
        _collectionVSegment.showsHorizontalScrollIndicator = NO;
        [_collectionVSegment registerClass:[WARFavriteGenarSegementCell class] forCellWithReuseIdentifier:@"segmentCell"];

        
    }
    return _collectionVSegment;
}
@end
