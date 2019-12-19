//
//  SpTypesSearchNoContentMainView.m
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchNoContentMainView.h"
#import "STSearchNoContentCollectionViewCell.h"
#import "STSearchNoContentCollectionHeaderView.h"

@interface SpTypesSearchNoContentMainView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation SpTypesSearchNoContentMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.searchView = [[SpTypesSearchView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44) isAddOneBtn:YES addBtnImageName:@"spTypes_search_message" addBtnTitle:@"" searchKeyStr:@"" canEidt:NO placeholderStr:@"" isHaveBack:YES isHaveBottomLine:YES];
    [self addSubview:self.searchView];
    
    //
    self.topView = [[SpTypesSearchTopView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.frame.size.width, 50)];
    [self addSubview:self.topView];

    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame),ScreenW,self.frame.size.height -  CGRectGetMaxY(self.topView.frame)) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[STSearchNoContentCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [_collectionView registerClass:[STSearchNoContentCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

#pragma mark collectionView delegate
//一共有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    STSearchNoContentCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    [cell refreshViewWithModel:nil];
    return cell;
}

//头部和脚部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        STSearchNoContentCollectionHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//        if (_sectionGriditemArr.count > indexPath.section) {
//            NSArray *arr = _sectionGriditemArr[indexPath.section];
//            if (arr.count > indexPath.row) {
//                VideoHomeGriditemModel *model = arr[indexPath.row];
//                headerView.titleLab.text = model.titleText;
//            }
//        }
        return headerView;
    }
    return [[UICollectionReusableView alloc] init];
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
//    if (_sectionGriditemArr.count > section) {
//        if ([_sectionGriditemArr[section] count] == 0) {
//            return CGSizeMake(0, 0);
//        }
//    }
    return CGSizeMake(ScreenW, 200);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW - 30) / 2, (ScreenW - 30) / 2 + 100);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

@end
