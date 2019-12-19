//
//  HFAPPRariseCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAPPRariseCell.h"
#import "HFImageViewCell.h"
@interface HFAPPRariseCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nickNameLb;
@property(nonatomic,strong)UILabel *dateLb;
@property(nonatomic,strong)UILabel *contentLb;
@property(nonatomic,strong)UICollectionView *collectionView;
@end
@implementation HFAPPRariseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setupViews];
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nickNameLb];
    [self addSubview:self.dateLb];
    [self addSubview:self.contentLb];
    [self addSubview:self.collectionView];
}

- (void)doMessageSomthing {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.nickNameLb.text = self.model.nickName;
    self.dateLb.text = self.model.dateStr;
    self.contentLb.text = self.model.contentStr;
    self.iconImageView.frame = CGRectMake(15, 25, 30, 30);
    self.dateLb.frame = CGRectMake(ScreenW-68-15, 33, 68, 15);
    self.nickNameLb.frame = CGRectMake(self.iconImageView.right+10, 25, ScreenW-self.iconImageView.right-10-15-68-5, 20);
    for (UIView *v in self.contentView.subviews) {
        if (v.tag >=100) {
            [v removeFromSuperview];
        }
    }
    NSInteger badScore = 5-[self.model.usersLevel integerValue];
    CGFloat minX = (self.iconImageView.right+10);
    for (int i = 0; i < [self.model.usersLevel integerValue]; i++) {
        UIImageView *good = [[UIImageView alloc] initWithFrame:CGRectMake(minX, self.nickNameLb.bottom+5, 10, 10)];
        good.image = [UIImage imageNamed:@"yd_score"];
        [self.contentView addSubview:good];
        good.tag = 100+i;
        minX = good.right+5;
    }
//    if (minX == 0) {
//        minX = self.iconImageView.right+10;
//    }
    for (int i = 0; i < badScore; i++) {
       
        UIImageView *bade = [[UIImageView alloc] initWithFrame:CGRectMake(minX, self.nickNameLb.bottom+5, 10, 10)];
        bade.image = [UIImage imageNamed:@"yd_score_bad"];
        bade.tag = 105+i;
        [self.contentView addSubview:bade];
         minX = bade.right+5;
    }
    CGSize size = [self.contentLb sizeThatFits:CGSizeMake(ScreenW-30, MAXFLOAT)];
    self.contentLb.frame = CGRectMake(15, self.iconImageView.bottom+15, size.width, size.height);
    NSInteger count = self.model.imageUrlsArray.count % 3;
    CGFloat row = 0;
    if (count == 0) {
        if (self.model.imageUrlsArray.count/3 == 0) {
            row = (self.model.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+0;
        }else {
            row = (self.model.imageUrlsArray.count/3)*((ScreenW-30-10)/3)+5*(self.model.imageUrlsArray.count/3-1);
        }
    }else {
        row = (self.model.imageUrlsArray.count/3+1)*((ScreenW-30-10)/3)+5*(self.model.imageUrlsArray.count/3);
    }
    CGFloat w = floor((ScreenW-30-10)/3);
    self.collectionView.frame = CGRectMake(15, self.contentLb.bottom+10, ScreenW-30, row);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.scrollDirection = 0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(floor((ScreenW-30-10)/3), floor((ScreenW-30-10)/3));
    [self.collectionView setCollectionViewLayout:flowLayout];

    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.imageUrlsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HFImageViewCell" forIndexPath:indexPath];
    [cell domessageSomeThing];
    return cell;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [HFUIkit minimumLineSpacing:5 minimumInteritemSpacing:5 scrollDirection:0 sectionInset:UIEdgeInsetsMake(0, 0, 0, 0) itemSize:CGSizeMake((ScreenW-30-10)/3, (ScreenW-30-10)/3) backgroundColor:[UIColor whiteColor] delegate:self frame:CGRectZero];
        [_collectionView registerClass:[HFImageViewCell class] forCellWithReuseIdentifier:@"HFImageViewCell"];
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}
- (UILabel *)contentLb {
    if(!_contentLb) {
        _contentLb = [HFUIkit textColor:@"333333" font:14 numberOfLines:0];
    }
    return _contentLb;
}
- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb = [HFUIkit textColor:@"999999" font:12 numberOfLines:1];
    }
    return _dateLb;
}
- (UILabel *)nickNameLb {
    if (!_nickNameLb) {
        _nickNameLb = [HFUIkit textColor:@"333333" font:15 numberOfLines:1];
    }
    return _nickNameLb;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
@end
