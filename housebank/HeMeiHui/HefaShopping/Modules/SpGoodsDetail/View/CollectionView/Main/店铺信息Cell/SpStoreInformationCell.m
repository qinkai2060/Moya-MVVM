//
//  SpStoreInformationCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpStoreInformationCell.h"
#import "SpBusinessDetailCell.h"
#import "SpStoreRecommendCell.h"
#import "SpaceLineCell.h"
@interface SpStoreInformationCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
@property (strong , nonatomic) UIView *line;

@end

static NSString *const SpBusinessDetailCellID = @"SpBusinessDetailCell";
static NSString *const SpStoreRecommendCellID = @"SpStoreRecommendCell";
static NSString *const SpaceLineCellID = @"SpaceLineCell";

@implementation SpStoreInformationCell
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
//        layout.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        //注册
        [_collectionView registerClass:[SpBusinessDetailCell class] forCellWithReuseIdentifier:SpBusinessDetailCellID];
        [_collectionView registerClass:[SpaceLineCell class] forCellWithReuseIdentifier:SpaceLineCellID];
        [_collectionView registerClass:[SpStoreRecommendCell class] forCellWithReuseIdentifier:SpStoreRecommendCellID];
        
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.bottom.equalTo(self);
    }];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.productInfo.data.topProducts.count>0) {
           return  3;
    }else
    {
        return  1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
       UICollectionViewCell *gridcell = nil;
    if (indexPath.row==0) {
        SpBusinessDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpBusinessDetailCellID forIndexPath:indexPath];
        cell.productInfo=self.productInfo;
        [cell reSetVDataValue:self.productInfo];
        gridcell = cell;
    }
    else if (indexPath.row==1)
    {
        SpaceLineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpaceLineCellID forIndexPath:indexPath];
         cell.backgroundColor=HEXCOLOR(0xF5F5F5);
        gridcell = cell;
    }
    else
    {
        SpStoreRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpStoreRecommendCellID forIndexPath:indexPath];
        cell.productInfo=self.productInfo;
        [cell reSetVDataValue:self.productInfo];
        gridcell = cell;
        
    }
   
    return gridcell;
}

#pragma mark - <UICollectionViewDelegate>
#pragma mark - item宽高   待计算动态高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
          return  CGSizeMake(ScreenW, 80) ;
    }else if(indexPath.row==1)
    {
          return  CGSizeMake(ScreenW, 1) ;
    }else
    {
         return  CGSizeMake(ScreenW, 176) ;
    }
      
}


#pragma mark - 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(void)reSetVDataValue:(GoodsDetailModel*)productInfo
{
    self.productInfo=productInfo;
}
#pragma mark - Setter Getter Methods

@end
