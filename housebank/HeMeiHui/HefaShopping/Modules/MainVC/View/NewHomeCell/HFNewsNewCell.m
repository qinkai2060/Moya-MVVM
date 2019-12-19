//
//  HFNewsNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNewsNewCell.h"
#import "ZTGCDTimerManager.h"
#import "HFNewsSmallCell.h"
@interface HFNewsNewCell ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;
@end
@implementation HFNewsNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeNewsType];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.morelb];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.quickImageV];
    [self.contentView addSubview:self.hotTitleLb];
//    [self.contentView addSubview:self.titleTableView];
    [self.contentView addSubview:self.collectionView];
    
    
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
- (void)doMessageRendering {
    [self invalidateTimer];
    self.newsModel = (HFNewsModel*)self.model;
    self.morelb.frame = CGRectMake(ScreenW-25-5, 13, 25, 15);
    self.lineView.frame = CGRectMake(self.morelb.left-10-1, 13, 1, 15);
    self.quickImageV.frame = CGRectMake(15, 10, 32, 20);
    self.hotTitleLb.frame = CGRectMake(self.quickImageV.right+5, 13, 30, 15);
    
    self.collectionView.frame = CGRectMake(self.hotTitleLb.right+10, 0, self.lineView.left-10-self.hotTitleLb.right-10, self.newsModel.rowheight);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(self.collectionView.width,40);
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    self.quickImageV.image = [UIImage imageNamed:@"title-news"];
    self.hotTitleLb.text = @"热议";
    self.autoScroll = YES;
    if (self.newsModel.dataArray.count>1 ){
        [self setAutoScroll:self.autoScroll];
  }
    [self.collectionView reloadData];
}
- (void)initTimer {
    [self invalidateTimer];
    [[ZTGCDTimerManager sharedInstance] scheduleGCDTimerWithName:@"newscell" interval:3 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
        if (0 == self.newsModel.dataArray.count*1000) return;
        int currentIndex = [self currentIndex];
        int targetIndex = currentIndex + 1;
        [self scrollToIndex:targetIndex];
    }];
}
//- (void)scrollToIndex:(int)targetIndex {
//    if (targetIndex >= self.newsModel.dataArray.count*1000) {
//
//        targetIndex = self.newsModel.dataArray.count*1000 * 0.5;
//        [self.titleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        return;
//    }
//
//    [self.titleTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:targetIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}
- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= self.newsModel.dataArray.count*1000) {
        
        targetIndex = self.newsModel.dataArray.count*1000 * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}
//- (int)currentIndex
//{
//    if (self.titleTableView.width == 0 || self.titleTableView.height == 0) {
//        return 0;
//    }
//    int   index = (self.titleTableView.contentOffset.y +40*0.5) / 40;
//
//    return MAX(0, index);
//}
- (int)currentIndex
{
    if (self.collectionView.width == 0 || self.collectionView.height == 0) {
        return 0;
    }
    int   index = (self.collectionView.contentOffset.y +40*0.5) / 40;
    
    return MAX(0, index);
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.newsModel.dataArray.count >1){
//        return self.newsModel.dataArray.count*1000;
//    }else {
//        return self.newsModel.dataArray.count;
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index =   indexPath.row % self.newsModel.dataArray.count;
//    HFNewsModel *model =  [self.newsModel.dataArray objectAtIndex:index];
//    if (self.didNewsBlock) {
//        self.didNewsBlock(model);
//    }
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HFNewsSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    NSInteger index =   indexPath.row % self.newsModel.dataArray.count;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    HFNewsModel *model =  [self.newsModel.dataArray objectAtIndex:index];
//    cell.newsModel = model;
//    [cell getData];
//    return cell;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        if (self.newsModel.dataArray.count >1){
            return self.newsModel.dataArray.count*1000;
        }else {
            return self.newsModel.dataArray.count;
        }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFNewsSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NSInteger index =   indexPath.row % self.newsModel.dataArray.count;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HFNewsModel *model =  [self.newsModel.dataArray objectAtIndex:index];
        cell.newsModel = model;
        [cell getData];
        return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        NSInteger index =   indexPath.row % self.newsModel.dataArray.count;
        HFNewsModel *model =  [self.newsModel.dataArray objectAtIndex:index];
        if (self.didNewsBlock) {
            self.didNewsBlock(model);
        }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//
//    [self scrollViewDidEndScrollingAnimation:self.titleTableView];
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (!self.newsModel.dataArray.count) return; // 解决清除timer时偶尔会出现的问题
  
}
-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
   if (_autoScroll&&self.newsModel.dataArray.count > 1) {
        [self initTimer];
    }
}


- (void)invalidateTimer {
    [[ZTGCDTimerManager sharedInstance] cancelTimerWithName:@"newscell"];
}
- (void)moreClick {
    if (self.didNewsMoreBlock) {
        self.didNewsMoreBlock();
    }
}
- (UIButton *)morelb {
    if (!_morelb) {
        _morelb = [[UIButton alloc] init];
        [_morelb setTitle:@"更多" forState:UIControlStateNormal];
        [_morelb addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [_morelb setTitleColor:[UIColor colorWithHexString:@"494949"] forState:UIControlStateNormal];
//        _morelb.textColor = [UIColor colorWithHexString:@"494949"];
       _morelb.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _morelb;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E9E7E8"];
    }
    return _lineView;
}
-(UIImageView *)quickImageV {
    if (!_quickImageV) {
        _quickImageV = [[UIImageView alloc] init];
        _quickImageV.image = [UIImage imageNamed:@"title-news"];
    }
    return _quickImageV;
}
- (UILabel *)hotTitleLb {
    if (!_hotTitleLb) {
        _hotTitleLb = [[UILabel alloc] init];
        _hotTitleLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _hotTitleLb.font = [UIFont systemFontOfSize:10];
        _hotTitleLb.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
        _hotTitleLb.layer.borderWidth = 0.5;
        _hotTitleLb.layer.cornerRadius = 4;
        _hotTitleLb.layer.masksToBounds = YES;
        _hotTitleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _hotTitleLb;
}
//- (UITableView *)titleTableView {
//    if (!_titleTableView) {
//        _titleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _titleTableView.delegate =self;
//        _titleTableView.dataSource =self;
//        _titleTableView.scrollEnabled = NO;
//        [_titleTableView registerClass:[HFNewsSmallCell class] forCellReuseIdentifier:@"cell"];
//    }
//    return _titleTableView;
//}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(_collectionView.width,40);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[HFNewsSmallCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}
@end
