//
//  SpStoreRecommendCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpStoreRecommendCell.h"
#import "SpStoreRecommendDetailCell.h"

@interface SpStoreRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 图片数组 */
//@property (strong , nonatomic)NSMutableArray<DCCommentPicItem *> *picItem;
@end
@implementation SpStoreRecommendCell

static NSString *const SpStoreRecommendDetailCellID = @"SpStoreRecommendDetailCell";
//static const CGFloat kItemSpacing = 10;   //item之间的间距  --
//static const CGFloat kLineSpacing = 5.f;   //列间距 |
#pragma mark - LoadLazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册
        [_collectionView registerClass:[SpStoreRecommendDetailCell class] forCellWithReuseIdentifier:SpStoreRecommendDetailCellID];
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

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.productInfo.data.topProducts.count>3) {
        return 3;
    }else
    {
       return self.productInfo.data.topProducts.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpStoreRecommendDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpStoreRecommendDetailCellID forIndexPath:indexPath];
    TopProductsItem *item;
    if (self.productInfo.data.topProducts.count>0) {
         item=[self.productInfo.data.topProducts objectAtIndex:indexPath.row];
    }
    cell.productInfo=item;
    [cell reSetVDataValue:item];
//    cell.backgroundColor=HEXCOLOR(0XF7F7F7);
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(105, 145);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TopProductsItem *item;
    if (self.productInfo.data.topProducts.count>0) {
        item=[self.productInfo.data.topProducts objectAtIndex:indexPath.row];
    }
   NSDictionary *dict = @{@"productId":[NSString stringWithFormat:@"%ld",(long)item.productId],@"episode":@1,@"seekTime":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:ShopeProductDetailView object:nil userInfo:dict];
}

-(void)reSetVDataValue:(GoodsDetailModel*)productInfo
{
    self.productInfo=productInfo;
}
@end
