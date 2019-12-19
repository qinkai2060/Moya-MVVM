//
//  HFFashionNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFashionNewCell.h"
#import "HFFashionSmallCell.h"

@implementation HFFashionNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeFashionType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.collectionView];
}
- (void)doMessageRendering {
    self.fashionModel = (HFFashionModel*)self.model;
    self.collectionView.frame = CGRectMake(0, 0, ScreenW, self.fashionModel.rowheight);
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.fashionModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFFashionSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fashionCell" forIndexPath:indexPath];
  
    HFFashionModel *model = self.fashionModel.dataArray[indexPath.row];
    cell.fashionModel = model;
    [cell doMessageRendering];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
      HFFashionModel *model = self.fashionModel.dataArray[indexPath.row];
    if (self.didFashionBlock) {
        self.didFashionBlock(model);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(ScreenW/3,160);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 160) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFFashionSmallCell class] forCellWithReuseIdentifier:@"fashionCell"];
        //        _collectionView.pagingEnabled = YES;
        _collectionView.bounces=NO;
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}
@end
