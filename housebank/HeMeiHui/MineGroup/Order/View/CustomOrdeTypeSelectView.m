//
//  CustomOrdeTypeSelectView.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "CustomOrdeTypeSelectView.h"
#import "CustomOrderTypeCollectionViewCell.h"
@interface CustomOrdeTypeSelectView()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    NSMutableArray *arrClick;//标记数据源
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *currentTitle;
@end

@implementation CustomOrdeTypeSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return self;
}

+(instancetype)showCustomOrdeTypeSelectViewViewIn:(UIView *)view dataArr:(NSArray *)dataArr currentTitle:(NSString *)currentTitle clickBlock:(void(^)(NSString *strType))clickBlock{
    CustomOrdeTypeSelectView *cus = [[CustomOrdeTypeSelectView alloc] initWithFrame:view.bounds];
    cus.currentTitle = currentTitle;

    cus.clickBlock = clickBlock;
    cus.dataArr = dataArr;
    return cus;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self setFlagArrAndChangeCollectionFrame];
}

/**
 计算是否点击过 并 根据数组个数计算CollectionFrame
 */
- (void)setFlagArrAndChangeCollectionFrame{
    arrClick = [NSMutableArray array];
    for (int i = 0; i < _dataArr.count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%@",_dataArr[i]];
        if ([_currentTitle isEqualToString:str] || ([_currentTitle isEqualToString:@"我的订单"] && i == 0)) {
            [arrClick addObject:@"1"];
        } else {
            [arrClick addObject:@"0"];
        }
    }
    
    NSInteger i = _dataArr.count % 3;
    NSInteger flag = _dataArr.count / 3;
    if (i > 0) {
        flag = flag + 1;
    }
    double h = flag * 30.f + (flag + 1) * 15.f;
    
    [self setCollectionFrame:CGRectMake(0, 0, ScreenW, h)];

}

/**
 collection 初始化

 @param F 传入计算过的frame
 */
- (void)setCollectionFrame:(CGRect)F{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    self.collectionView = [[UICollectionView alloc] initWithFrame:F collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[CustomOrderTypeCollectionViewCell class] forCellWithReuseIdentifier:@"CustomOrderTypeCollectionViewCell"];
    
    
    UIView *tapCloseView = [[UIView alloc] init];
    [self addSubview:tapCloseView];
    [tapCloseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClose)];
    [tapCloseView addGestureRecognizer:tap];
}

/**
 获取当前标题计算 在cell返回使其变色

 @param currentTitle 当前navigation title
 */
- (void)setCurrentTitle:(NSString *)currentTitle{
    _currentTitle = currentTitle;
    for (int i = 0; i < self.dataArr.count; i ++ ) {
        if ([_currentTitle isEqualToString:_dataArr[i]]) {
            arrClick[i] = @"1";
        } else {
            arrClick[i] = @"0";
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - sectionNuw
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenW - 60) / 3 , 30);
}
#pragma mark - cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataArr.count;
}
#pragma mark - 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomOrderTypeCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomOrderTypeCollectionViewCell" forIndexPath:indexPath];
    cell.selecteLable.text = _dataArr[indexPath.item];
    if (arrClick.count) {
        if ([arrClick[indexPath.item] isEqualToString:@"1"]) {
            cell.selecteLable.layer.borderColor = HEXCOLOR(0xE31436).CGColor;
            cell.selecteLable.textColor = HEXCOLOR(0xE31436);
        } else {
            
            cell.selecteLable.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
            cell.selecteLable.textColor = HEXCOLOR(0x333333);
        }
    }
    
    return cell;
}
#pragma mark - 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上左下右
    return UIEdgeInsetsMake(15 ,15, 15, 15);
}

#pragma mark - cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadData];
    if (self.clickBlock) {
        self.clickBlock([NSString stringWithFormat:@"%@", _dataArr[indexPath.row]]);
        [self removeFromSuperview];
    }
}
- (void)tapClose{
    if (self.clickBlock) {
        self.clickBlock(@"");
        [self removeFromSuperview];
    }
}
@end
