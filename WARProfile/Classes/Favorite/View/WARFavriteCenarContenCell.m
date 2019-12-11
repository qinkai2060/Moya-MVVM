//
//  WARFavriteCenarContenCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteCenarContenCell.h"
#import "WARFavriteGenarContentSubCell.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARFavoriteModel.h"
#define CellW    ([UIScreen mainScreen].bounds.size.width - 30-13.5*2)/3
@implementation WARFavriteCenarContenCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setContentArray:(NSArray *)contentArray {
    _contentArray = contentArray;
    
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return  self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WARFavriteGenarContentSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subCell" forIndexPath:indexPath];
    WARFavoriteInfoModel *model = self.contentArray[indexPath.item];
    
    cell.model = model;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(CellW,152+38);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WARFavriteGenarContentSubCell class] forCellWithReuseIdentifier:@"subCell"];
        
    }
    return _collectionView;
}

@end
