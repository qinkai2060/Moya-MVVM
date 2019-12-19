//
//  HFVIPBrowserImage.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPBrowserImage.h"
#import "ASPageControlNode.h"
#import "HFCollectionCellNode.h"
#import "HFBrowserModel.h"
#import "HFSectionModel.h"
#import "ZTGCDTimerManager.h"
@interface HFVIPBrowserImage()<ASCollectionDelegate,ASCollectionDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)ASPageControlNode *pageControl;
@property(nonatomic,strong)ASCollectionNode *collectionView;
@end
@implementation HFVIPBrowserImage
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModeBrowserBannerType];
}
- (instancetype)initWithModel:(HFSectionModel *)model {
    if (self = [super initWithModel:model]) {
        [self addSubnode:self.collectionView];
        [self addSubnode:self.pageControl];
        self.browserModel = (HFBrowserModel*)[model.dataModelSource firstObject];
        self.autoScroll = YES;
        self.pageControl.numberOfPages = self.browserModel.dataArray.count;
        self.pageControl.currentPage = 0;
        self.pageControl.hidden = !(self.browserModel.dataArray.count>1);
        if (self.browserModel.dataArray.count>1 ){
            [self setAutoScroll:self.autoScroll];
        }
//       [self.collectionView reloadData];
    }
    return self;
}
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    if (self.browserModel.dataArray.count >1){
        return self.browserModel.dataArray.count*1000;
    }else {
        return self.browserModel.dataArray.count;
    }
}
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        HFCollectionCellNode *cellNode = [[HFCollectionCellNode alloc] initWithUrl:model];
        return cellNode;
    };
    return cellNodeBlock;
}
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    HFBrowserModel *model = self.browserModel.dataArray[itemIndex];
    if (self.didBrowserBlock) {
        self.didBrowserBlock(model);
    }

}
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
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView.view];
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
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:NSStringFromClass([HFVIPBrowserImage class]) interval:2 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        if (0 == self.browserModel.dataArray.count*1000) return;
        int currentIndex = [self currentIndex];
        int targetIndex = currentIndex + 1;
        [self scrollToIndex:targetIndex];
    }];
}
- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:NSStringFromClass([HFVIPBrowserImage class])];
}
- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= self.browserModel.dataArray.count*1000) {
        
        targetIndex = self.browserModel.dataArray.count*1000 * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
- (int)currentIndex
{
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    int   index = (self.collectionView.contentOffset.x + ScreenW * 0.5) / ScreenW;
    
    
    return MAX(0, index);
}
- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASWrapperLayoutSpec *collectStack = [ASWrapperLayoutSpec wrapperWithLayoutElement:self.collectionView];
    ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsEnd flexWrap:ASStackLayoutFlexWrapNoWrap alignContent:ASStackLayoutAlignContentEnd children:@[self.pageControl]];
    ASOverlayLayoutSpec *overStack = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:collectStack overlay:stack];
    return overStack;
}
- (ASPageControlNode *)pageControl {
    if (!_pageControl) {
        _pageControl = [[ASPageControlNode alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"F3344A"];
        _pageControl.userInteractionEnabled = NO;

    }
    return _pageControl;
}
- (ASCollectionNode *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(ScreenW,150);
        _collectionView = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.view.delegate = self;
        _collectionView.style.preferredSize = CGSizeMake(ScreenW, 150);
        _collectionView.view.pagingEnabled = YES;
    }
    return _collectionView;
}
@end
