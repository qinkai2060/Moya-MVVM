//
//  HFBrowserImageNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBrowserImageNewCell.h"
#import "HFImageCollectionCell.h"
//#import "HFBrowserCellViewModel.h"
#import "ZTGCDTimerManager.h"

@implementation HFBrowserImageNewCell

+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModeBrowserBannerType];
}

-(void)hh_setupSubviews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.pageControl];
}
- (void)doMessageRendering {
    self.browserModel = (HFBrowserModel*)self.model;
    self.collectionView.frame = CGRectMake(0, 0, ScreenW, self.browserModel.rowheight);
    self.pageControl.frame = CGRectMake(0, self.browserModel.rowheight-20-5, self.browserModel.dataArray.count*(7+3), 20);
    self.autoScroll = YES;
    self.pageControl.centerX = self.contentView.centerX;
    self.pageControl.numberOfPages = self.browserModel.dataArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.hidden = !(self.browserModel.dataArray.count>1);
    if (self.browserModel.dataArray.count>1 ){
        [self setAutoScroll:self.autoScroll];
    }
    [self.collectionView reloadData];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.browserModel.dataArray.count >1){
        return self.browserModel.dataArray.count*1000;
    }else {
        return self.browserModel.dataArray.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
  
    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
    cell.model = model;
    [cell doMessageRendering];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
    if (self.didBrowserBlock) {
        self.didBrowserBlock(model);
    }
}
#pragma mark - UIScrollViewDelegate
- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    return (int)index % self.browserModel.dataArray.count;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.browserModel.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
//    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    self.pageControl.currentPage = indexOnPageControl;
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

    if (!self.browserModel.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    if (_autoScroll&&self.browserModel.dataArray.count > 1) {
        [self setupTimer];
    }
    
}


- (void)setupTimer {
    [self invalidateTimer];
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:NSStringFromClass([HFBrowserImageNewCell class]) interval:5 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        if (0 == self.browserModel.dataArray.count*1000) return;
        int currentIndex = [self currentIndex];
        int targetIndex = currentIndex + 1;
        [self scrollToIndex:targetIndex];
    }];
}
- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:NSStringFromClass([HFBrowserImageNewCell class])];
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
    if (targetIndex >= self.browserModel.dataArray.count*1000) {
        
        targetIndex = self.browserModel.dataArray.count*1000 * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        return;
    }

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
    return CGSizeMake(kScreenSize.width, self.browserModel.rowheight);
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW,235);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 235) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFImageCollectionCell class] forCellWithReuseIdentifier:@"moreCell"];
        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"F3344A"];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
@end

