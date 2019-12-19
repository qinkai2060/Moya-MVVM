//
//  HFPriceFilterCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFPriceFilterCell.h"
#import "HFPriceFixledRangCollectionCell.h"
#import "HFSilderView.h"
@interface HFPriceFilterCell()<UICollectionViewDelegate,UICollectionViewDataSource,HFSilderViewDelegate>
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *selectTitleLb;
@property(nonatomic,strong)HFSilderView *sliderView;

@property(nonatomic,strong)UICollectionView *collectionView;
@end
@implementation HFPriceFilterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setUpviews];
    }
    return self;
}
- (void)hh_setUpviews {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.selectTitleLb];
    [self.contentView addSubview:self.sliderView];
    [self.contentView addSubview:self.collectionView];
}
- (void)doMessageSomthing {
    self.titleLb.text = self.pricefilterModel.title;
    self.selectTitleLb.text = [self selectTitle:self.pricefilterModel.minfloat max:self.pricefilterModel.maxfloat].length == 0 ?@"": [self selectTitle:self.pricefilterModel.minfloat max:self.pricefilterModel.maxfloat];
    if([self.pricefilterModel.maxfloat isEqualToString:@"不限"]) {
           [self.sliderView setMaxValue:1050 withMinValue:[self.pricefilterModel.minfloat integerValue]];
    }else {
        [self.sliderView setMaxValue:[self.pricefilterModel.maxfloat integerValue] withMinValue:[self.pricefilterModel.minfloat integerValue]];
    }
 
    self.titleLb.frame = CGRectMake(15, 15, 30, 20);
    self.selectTitleLb.frame = CGRectMake(self.titleLb.right+15, 15, ScreenW-self.titleLb.right-30, 20);
    self.sliderView.frame = CGRectMake(20, self.selectTitleLb.bottom+15, ScreenW-40, 100);
    self.collectionView .frame = CGRectMake(0, self.sliderView.bottom, ScreenW, 150);
    if ( self.pricefilterModel.dataSource.count == 0) {
        self.collectionView.hidden = YES;
    }
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pricefilterModel.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFPriceFixledRangCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
    HFFilterPriceModel *model = (HFFilterPriceModel*)self.pricefilterModel.dataSource[indexPath.item];
    cell.model = model;
    [cell doSomething];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (HFFilterPriceModel *pModel in self.pricefilterModel.dataSource) {
        pModel.isSelected = NO;
    }
    HFFilterPriceModel *model = (HFFilterPriceModel*)self.pricefilterModel.dataSource[indexPath.item];
    model.isSelected = YES;
    if ([model.title isEqualToString:@"不限"]) {
        self.pricefilterModel.minfloat = @"0";
        self.pricefilterModel.maxfloat = @"不限";
        [self.sliderView setMaxValue:1050 withMinValue:0];
    }else if ([model.title isEqualToString:@"¥900以上"]) {
        self.pricefilterModel.minfloat = model.minfloat;
        self.pricefilterModel.maxfloat = @"不限";

       [self.sliderView setMaxValue:1050 withMinValue:900];
    }else {
        self.pricefilterModel.maxfloat = model.maxfloat;
        self.pricefilterModel.minfloat = model.minfloat;
        [self.sliderView setMaxValue:[model.maxfloat integerValue]  withMinValue:[model.minfloat integerValue]];

    }
    self.pricefilterModel.selectTitle = [self selectTitle:self.pricefilterModel.minfloat max:self.pricefilterModel.maxfloat];
    if ([self.delegate respondsToSelector:@selector(priceFilterCell:model:)]) {
        [self.delegate priceFilterCell:self model:self.pricefilterModel];
    }
    [collectionView reloadData];
    if ([self.superview isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView*)[self superview];
        [tableView reloadData];
    }

   
}
- (void)silderView:(HFSilderView *)view low:(NSString *)low hight:(NSString *)hight state:(HFSilderViewState)state {
    if (state == HFSilderViewStateBegan) {
        for (HFFilterPriceModel *pModel in self.pricefilterModel.dataSource) {
            pModel.isSelected = NO;
        }
        if ([self.superview isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView*)[self superview];
            [tableView reloadData];
        }
    }
    if (state == HFSilderViewStateChange) {
    }
   
    if (state == HFSilderViewStateEnd) {
        self.pricefilterModel.minfloat = low;
        self.pricefilterModel.maxfloat =hight;
        if ([self.superview isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView*)[self superview];
            [tableView reloadData];
        }
        self.pricefilterModel.selectTitle = [self selectTitle:self.pricefilterModel.minfloat max:self.pricefilterModel.maxfloat];
        if ([self.delegate respondsToSelector:@selector(priceFilterCell:model:)]) {
            [self.delegate priceFilterCell:self model:self.pricefilterModel];
        }
    }

}
- (NSString *)selectTitle :(NSString*)min max:(NSString*)max {
    if ([min isEqualToString:@"不限"] ||([max isEqualToString:@"不限"]&&([min isEqualToString:@"0"]||[min isEqualToString:@""]))) {
       return  @"¥不限";
    }else {
        self.selectTitleLb.hidden = NO;
        if ([min isEqualToString:max] ) {
            if ([min isEqualToString:@"0"]) {
                return  @"¥0以下";
            }else {
               return  [NSString stringWithFormat:@"¥%@以上",min];
            }
        }else if ([max isEqualToString:@"不限"]&& [min integerValue] > 0) {
            return  [NSString stringWithFormat:@"¥%@以上",min];
        }else {
           return  [NSString stringWithFormat:@"¥%@-%@",min,max];
        }
        
    }
    return @"";

}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleLb;
}
- (UILabel *)selectTitleLb {
    if (!_selectTitleLb) {
        _selectTitleLb = [[UILabel alloc] init];
        _selectTitleLb.font = [UIFont systemFontOfSize:14];
        _selectTitleLb.textColor = [UIColor colorWithHexString:@"FF6600"];
    }
    return _selectTitleLb;
}
- (HFSilderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[HFSilderView alloc] initWithFrame:CGRectMake(20, 15, ScreenW-40, 100)];
        _sliderView.delegate = self;
    }
    return _sliderView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 10, 15);
        flowLayout.itemSize = CGSizeMake((ScreenW-30-20)/3,35);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150) collectionViewLayout:flowLayout];
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
