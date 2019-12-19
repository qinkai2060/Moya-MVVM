//
//  VIPGiftSelectViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/9/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VIPGiftSelectViewCell.h"
#import "VipGiltBagCollectionViewCell.h"
#import "UIScrollView+UITouch.h"

@interface VIPGiftSelectViewCell()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView * firstCollectView;
@property (nonatomic, strong)UICollectionView * secondCollectView;
@property (nonatomic, strong)UICollectionView * thirdCollectView;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, assign)NSInteger section;
@property (nonatomic, assign)BOOL canDelivery;
@end
@implementation VIPGiftSelectViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#100700"];
        [self addSubview:self.scrollView];
        @weakify(self);
        self.pageBlcok = ^(NSInteger page) {
            @strongify(self);
            [self.scrollView setContentOffset:CGPointMake(page*self.scrollView.frame.size.width, 0) animated:YES];
            self.scrollView.bouncesZoom = NO;
        };
    }
    return self;
}

- (void)setUpDataSouce:(NSArray *)dataSource withSection:(NSInteger)section {
    _dataSource = dataSource;
    _section = section;
    self.scrollView.contentSize = CGSizeMake(self.size.width * self.dataSource.count, self.size.height);
    // 看数据源需要分布多少列
    for (NSInteger  i=0; i < self.dataSource.count; i++) {
        CGRect frame = CGRectMake(i*self.size.width, 0, self.size.width, self.size.height);
        if (i== 0) {
            if (!self.firstCollectView) {
                self.firstCollectView = [self collectViewWithCollectView];
                [self.scrollView addSubview:self.firstCollectView];
            }
            
            self.firstCollectView.frame = frame;
            [self.firstCollectView reloadData];
        }else if (i == 1){
            if (!self.secondCollectView) {
                self.secondCollectView = [self collectViewWithCollectView];
                [self.scrollView addSubview:self.secondCollectView];
            }
            self.secondCollectView.frame = frame;
            [self.secondCollectView reloadData];
        }else if (i == 2){
            if (!self.thirdCollectView) {
                self.thirdCollectView = [self collectViewWithCollectView];
                [self.scrollView addSubview:self.thirdCollectView];
            }
            self.thirdCollectView.frame = frame;
            [self.thirdCollectView reloadData];
        }
    }
}

//拖动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint endPoint = self.scrollView.contentOffset;
    if (endPoint.x == 0) {
        if (self.scrolleBlock ) {
            self.scrolleBlock(0,self.section);
        }
    }else if(endPoint.x < kWidth){
        if (self.scrolleBlock) {
            self.scrolleBlock(1,self.section);
        }
    }else if (endPoint.x < 2 * kWidth){
        if (self.scrolleBlock) {
            self.scrolleBlock(2,self.section);
        }
    }
}

#pragma mark ----------- collectionView  Delegate . dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    NSArray * array ;
    if ([collectionView isEqual:self.firstCollectView]) {
        array = self.dataSource[0];
        return  array.count;
    }else if ([collectionView isEqual:self.secondCollectView]){
        array = self.dataSource[1];
        return  array.count;
    }else if ([collectionView isEqual:self.thirdCollectView]){
        array = self.dataSource[2];
        return  array.count;
    }
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"UICollectionCell";
   VipGiltBagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSArray * array ;
    if ([collectionView isEqual:self.firstCollectView]) {
        array = self.dataSource[0];
        VipGiftShopModel *itemModel = array[indexPath.row];
        [cell setUpShopModel:itemModel withType:[self getSetionTypeString]];
    }else if ([collectionView isEqual:self.secondCollectView]){
        array = self.dataSource[1];
         VipGiftShopModel *itemModel = array[indexPath.row];
        [cell setUpShopModel:itemModel withType:[self getSetionTypeString]];
    }else if ([collectionView isEqual:self.thirdCollectView]){
        array = self.dataSource[2];
       VipGiftShopModel *itemModel = array[indexPath.row];
        [cell setUpShopModel:itemModel withType:[self getSetionTypeString]];
    }
    return cell;
}

- (NSString *)getSetionTypeString {
    if (self.section == 0) {
        return @"银卡礼包";
    }else if (self.section == 1){
        return @"铂金礼包";
    }else if (self.section == 2){
       return  @"钻石礼包";
    }
    return nil;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//同一行两个cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array ;
    VipGiftShopModel *itemModel;
    if ([collectionView isEqual:self.firstCollectView]) {
        array = self.dataSource[0];
         itemModel = array[indexPath.row];
    }else if ([collectionView isEqual:self.secondCollectView]){
        array = self.dataSource[1];
        itemModel = array[indexPath.row];
    }else if ([collectionView isEqual:self.thirdCollectView]){
        array = self.dataSource[2];
        itemModel = array[indexPath.row];
    }
    
    if (self.popNextBlock) {
        self.popNextBlock(itemModel);
    }
}

#pragma mark -- lazy load
- (UICollectionView *)collectViewWithCollectView {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((self.size.width-30)/2,237);
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor colorWithHexString:@"#100700"];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.showsHorizontalScrollIndicator = NO;
    collectView.showsVerticalScrollIndicator = NO;
    [collectView registerNib:[UINib nibWithNibName:@"VipGiltBagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UICollectionCell"];
    collectView.scrollEnabled = NO;
    return collectView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#100700"];
    }
    return _scrollView;
}

@end
