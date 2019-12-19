//
//  HFProudctView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFProudctView.h"
#import "HFProudctVideoCell.h"
@interface HFProudctView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,assign)NSInteger row;
@end
@implementation HFProudctView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[HFProudctVideoCell class] forCellWithReuseIdentifier:@"product"];
    }
    return self;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (indexPath.row == self.row) ? (40+5+95):40;
    return CGSizeMake(w, 40);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFProudctVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"product" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == self.row) {
        cell.select = YES;
    }else {
        cell.select = NO;
    }
    [cell doSomething];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.row = indexPath.row;
    [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.row inSection:0]]];
}
@end
