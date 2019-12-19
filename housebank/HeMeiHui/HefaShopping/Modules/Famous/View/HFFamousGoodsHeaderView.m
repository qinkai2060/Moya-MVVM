//
//  HFFamousGoodsHeaderView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousGoodsHeaderView.h"
#import "HFFamousGoodsViewModel.h"
#import "ZTGCDTimerManager.h"
#import "HFFamousGoodsBannerModel.h"
#import "HFBannerAdCell.h"
@interface HFFamousGoodsHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFFamousGoodsViewModel *viewModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,assign) BOOL autoScroll;


@end
@implementation HFFamousGoodsHeaderView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
-(void)hh_setupViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
//     self.array = [self dataSouce];
    
  
}
- (void)hh_bindViewModel {
    [self.viewModel.headerdataSendSubjc subscribeNext:^(id  _Nullable x) {
     
       
    }];
}
- (void)setArray:(NSArray *)array {
    _array = array;
    self.collectionView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, self.height-20-5, array.count*(7+3), 20);
    self.autoScroll = YES;
    self.pageControl.centerX = self.centerX;
    self.pageControl.numberOfPages = array.count;
    self.pageControl.hidden = !(array.count>1);
    if (array.count>1){
        [self setAutoScroll:self.autoScroll];
    }
    [self.collectionView reloadData];
}
- (void)doMessageRendering {

    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.array.count > 1) {
         return  self.array.count*1000;
    }else {
         return  self.array.count;
    }
  
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFBannerAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    HFFamousGoodsBannerModel *model = self.array[itemIndex];
    cell.model = model;
    [cell doMessageRendering];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
     HFFamousGoodsBannerModel *model = self.array[itemIndex];
    [self.viewModel.didBannerSubjc sendNext:model];
    
    
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.array.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    self.pageControl.currentPage = indexOnPageControl;
    
}
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
  //  HFBrowserCellViewModel *viewModel = (HFBrowserCellViewModel*)self.viewmodel;

    return (int)index % self.array.count;
    return 0;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (!self.array.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll&&self.array.count >1) {
        [self setupTimer];
    }
}


- (void)setupTimer {
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:NSStringFromClass([self class]) interval:2 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        NSLog(@"浏览");
//        HFBrowserCellViewModel *viewModel = (HFBrowserCellViewModel*)self.viewmodel;
        if (0 == self.array.count*1000) return;
        int currentIndex = [self currentIndex];
        int targetIndex = currentIndex + 1;
        [self scrollToIndex:targetIndex];
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
}
- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:NSStringFromClass([self class])];
}

- (int)currentIndex
{
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    int   index = (self.collectionView.contentOffset.x + ScreenW * 0.5) / ScreenW;
    
    
    return MAX(0, index);
}
- (void)scrollToIndex:(int)targetIndex {
   // HFBrowserCellViewModel *viewModel = (HFBrowserCellViewModel*)self.viewmodel;
    if (targetIndex >= self.array.count*1000) {

        targetIndex = self.array.count*1000 * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    HFBrowserCellViewModel *viewModel = (HFBrowserCellViewModel*)self.viewmodel;
//    if (self.collectionView.contentOffset.x == 0 &&  viewModel.dataSource.count
//        *1000) {
//        int targetIndex = viewModel.dataSource.count *1000 * 0.5;
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)dealloc {
    [self invalidateTimer];

    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW,160);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFBannerAdCell class] forCellWithReuseIdentifier:@"moreCell"];
        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"F3344A"];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

@end
