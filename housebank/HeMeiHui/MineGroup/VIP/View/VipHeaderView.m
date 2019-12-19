//
//  VipHeaderView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipHeaderView.h"
#import "VipViewCollectionViewCell.h"

@interface VipHeaderView() <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation VipHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    [self addSubview:self.headerImg];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top).offset(IPHONEX_SAFEAREA + 89);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [self addSubview:self.vipLevelL];
    [self.vipLevelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headerImg.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 28));
    }];
    
    [self addSubview:self.vipPrompt];
    [self.vipPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipLevelL.mas_bottom).offset(10);
        make.centerX.equalTo(self.vipLevelL);
    }];
    
    [self addSubview:self.escalateBtn];
    [self.escalateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(IPHONEX_SAFEAREA + 211);
        make.size.mas_equalTo(CGSizeMake(205, 40));
    }];
    
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"会员权益";
    titleL.textColor = HEXCOLOR(0x333333);
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self.headerImg.mas_bottom).offset(147);
        make.height.mas_equalTo(25);
    }];
    
    
    UILabel *moreL = [[UILabel alloc] init];
    moreL.text = @"更多权益 敬请期待";
    moreL.textColor = HEXCOLOR(0x999999);
    moreL.textAlignment = NSTextAlignmentCenter;
    moreL.font = [UIFont boldSystemFontOfSize:13];
    [self addSubview:moreL];
    [moreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
        make.height.mas_equalTo(20);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[VipViewCollectionViewCell class] forCellWithReuseIdentifier:@"VipViewCollectionViewCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleL.mas_bottom).offset(20);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(moreL.mas_top);
    }];
}
#pragma mark - sectionNuw
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenW - 20) / 4 , 60);
}
#pragma mark - cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrDate.count;
}
#pragma mark - 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VipViewCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VipViewCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_arrDate[indexPath.item]];
    cell.titleLable.text = [dic objectForKey:@"title"];
    cell.imgView.image = [UIImage imageNamed:[dic objectForKey:@"img"]];
    return cell;
}
#pragma mark - 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上左下右
    return UIEdgeInsetsMake(0 ,10, 0, 10);
}

#pragma mark - cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UIImageView *)headerImg{
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] init];
        _headerImg.layer.cornerRadius = 35;
        _headerImg.layer.masksToBounds = YES;
        _headerImg.backgroundColor = [UIColor whiteColor];
        
    }
    return _headerImg;
}
- (UILabel *)vipLevelL{
    if (!_vipLevelL) {
        _vipLevelL = [[UILabel alloc] init];
        _vipLevelL.text = @"";
        _vipLevelL.textColor = HEXCOLOR(0x333333);
        _vipLevelL.textAlignment = NSTextAlignmentCenter;
        _vipLevelL.font = [UIFont boldSystemFontOfSize:20];
    }
    return _vipLevelL;
}
- (UILabel *)vipPrompt{
    if (!_vipPrompt) {
        _vipPrompt = [[UILabel alloc] init];
        _vipPrompt.text = @"";
        _vipPrompt.textColor = HEXCOLOR(0x333333);
        _vipPrompt.textAlignment = NSTextAlignmentCenter;
        _vipPrompt.font = [UIFont boldSystemFontOfSize:14];
    }
    return _vipPrompt;
}
- (UIButton *)escalateBtn{
    if (!_escalateBtn) {
        _escalateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _escalateBtn.backgroundColor = HEXCOLOR(0x1E1C1C);
        [_escalateBtn setTitleColor:HEXCOLOR(0xFEECBB) forState:(UIControlStateNormal)];
        _escalateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _escalateBtn.layer.cornerRadius = 20;
        _escalateBtn.layer.masksToBounds = YES;
        [_escalateBtn addTarget:self action:@selector(escalateBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _escalateBtn;
}
- (void)escalateBtnAction:(UIButton *)btn{
    if (self.escalateBlock) {
        self.escalateBlock(btn.titleLabel.text ?: @"");
    }
}
- (void)setArrDate:(NSArray *)arrDate{
    _arrDate = arrDate;
    [self.collectionView reloadData];
}
- (void)refreshVipLevel{
    //vip会员等级(1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员)
    
    switch ([self.vipLevel integerValue]) {
        case 1:
        {
            _vipLevelL.text = @"免费会员";
        }
            break;
        case 2:
        {
            _vipLevelL.text = @"银卡会员";
        }
            break;
        case 3:
        {
            _vipLevelL.text = @"铂金会员";
        }
            break;
        case 4:
        {
            _vipLevelL.text = @"钻石会员";
        }
            break;
            
        default:
            break;
    }
    [_headerImg sd_setImageWithURL:[self.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"tab_mine_UnActive"]];
}


@end
