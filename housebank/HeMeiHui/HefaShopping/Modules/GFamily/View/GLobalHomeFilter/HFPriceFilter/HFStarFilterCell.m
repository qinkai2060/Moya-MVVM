//
//  HFStarFilterCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFStarFilterCell.h"
#import "HFPriceFixledRangCollectionCell.h"
@implementation HFStarFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}
- (void)hh_setUpviews {
    
}
- (void)doSomthing {
    self.titleLb.text = self.starfilterModel.title;
    self.titleLb.frame = CGRectMake(15, 15, 30, 20);
    self.collectionView .frame = CGRectMake(0, self.titleLb.bottom, ScreenW, 120);
    [self.collectionView reloadData];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.starfilterModel.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFPriceFixledRangCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
    HFFilterPriceModel *model = (HFFilterPriceModel*)self.starfilterModel.dataSource[indexPath.item];
    cell.model = model;
    [cell doSomething];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HFFilterPriceModel *model = (HFFilterPriceModel*)self.starfilterModel.dataSource[indexPath.item];
    if (model.isSelected) {
        model.isSelected = NO;
        [collectionView reloadData];
    }else {
        if ([model.title isEqualToString:@"不限"]) {
            for (HFFilterPriceModel *modelF in self.starfilterModel.dataSource) {
                modelF.isSelected = NO;
            }
            model.isSelected = YES;
        }else {
         
            for (HFFilterPriceModel *modelF in self.starfilterModel.dataSource ) {
                if ([modelF.title isEqualToString:@"不限"]) {
                    modelF.isSelected = NO;
                }
            }
            model.isSelected = YES;
        }
    }

    if ([self.delegate respondsToSelector:@selector(starFilterCell:selectArray:)]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (HFFilterPriceModel *modelF in self.starfilterModel.dataSource) {
            if (modelF.isSelected) {
                [array addObject:modelF];
            }
        }
        if (array.count == 0) {
        [self.starfilterModel.dataSource firstObject].isSelected = YES;
        [array addObject:[self.starfilterModel.dataSource firstObject]];
        [collectionView reloadData];
        }
        [self.delegate starFilterCell:self selectArray:array];
    }
    [collectionView reloadData];
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleLb;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 10, 15);
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((ScreenW-30-20)/3,35);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFPriceFixledRangCollectionCell class] forCellWithReuseIdentifier:@"moreCell"];
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}
@end
