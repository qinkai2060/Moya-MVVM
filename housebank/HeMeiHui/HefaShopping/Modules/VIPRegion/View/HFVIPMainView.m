//
//  HFVIPMainView.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPMainView.h"
#import "HFVIPViewModel.h"
#import "HFVIPModel.h"
#import "HFYDTableView.h"
#import "HFVIPHeadView.h"
#import "HFSegementCell.h"
#import "HFSegementNode.h"
#import "HFVIPModel.h"
#import "HFSectionModel.h"
#import "HFDBHandler.h"
#import "HFVIPNewHeaderView.h"
#import "HFTableViewnView.h"
//#import "HFVipClassCategoryCell.h"
#import "HFVIpClassCategoryNewCell.h"
#import "HFAlertView.h"
@interface HFVIPMainView ()<UICollectionViewDataSource,UICollectionViewDelegate,ASCollectionDelegate,ASCollectionDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)HFVIPViewModel *viewModel;
@property(nonatomic,strong)ASButtonNode *buttonNode;
@property(nonatomic,strong)HFYDTableView *tableView;
@property(nonatomic,strong)HFVIPNewHeaderView *headerView;
@property(nonatomic,strong)UIButton *enterButton;
@property(nonatomic,strong)UIButton *coverButton;
@property(nonatomic,strong)ASCollectionNode *segmentNode;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *indexPathesToBeReloaded;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableDictionary *getAllKey;
@property(nonatomic,strong)NSArray *headerSource;


@property(nonatomic,strong)UIImageView *noContentView;
@property(nonatomic,strong)UILabel *noContentLb;

@end
@implementation HFVIPMainView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFVIPViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubnode:self.buttonNode];
    [self addSubview:self.tableView];
    
    [self.tableView addSubview:self.headerView];
    [self.tableView addSubnode:self.segmentNode];
    [self.tableView addSubview:self.enterButton];
    [self.tableView addSubview:self.coverButton];
    [self.tableView addSubview:self.collectionView];
    self.coverButton.hidden = YES;
    self.enterButton.hidden = YES;
    [self.buttonNode addTarget:self action:@selector(enterSearchClick) forControlEvents:ASControlNodeEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveTop) name:@"leaveTop" object:nil];
     self.canScroll = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.viewModel.getAllKey removeAllObjects];
        self.viewModel.keyWord = @"";
        self.viewModel.classId = @"";
        [self.collectionView setContentOffset:CGPointMake(0, 0)];
        self.bottomEnabled = YES;
        self.tableView.scrollEnabled = YES;
        [self.tableView.mj_header endRefreshing];
        [self.viewModel.homeMainCommand execute:nil];
        
    }];
    
}
- (void)enterSearchClick {
    [self.viewModel.enterSearchSubjc sendNext:nil];
}
- (void)Behavior {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
}
- (void)leaveTop {
    self.canScroll = YES;
    HFVIpClassCategoryNewCell *contentNode =  [[self.collectionView visibleCells] firstObject];
    contentNode.bottomCanscroll = NO;
}
- (void)hh_bindViewModel {
//    //逻辑
    @weakify(self)
    [self.viewModel.homeMainSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.buttonNode.hidden = NO;
        if ([x isKindOfClass:[NSArray class]]) {
            
            self.headerSource = x;
            self.headerView.frame = CGRectMake(0, 0, ScreenW,[HFSectionModel headerVIPHeight: self.headerSource]);
            if (  self.headerSource.count >0) {
                [self.tableView haveData];
            }else {
                [self.tableView setErrorImage:@"" text:@"抱歉,这个星球暂时找不到"];
            }
            if (self.viewModel.classCategoryModel.isModuleShow) {
                [self.viewModel.getAllKey setObject:@[] forKey:@"-1"];
                [self.viewModel.VipSearchCommand execute:nil];
                if ([self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count >0) {
                    NSLog(@"=========%f_________%f",[self.viewModel.classCategoryModel.dataModelSource firstObject].horsizeW, ScreenW-38);
                    if (  [self.viewModel.classCategoryModel.dataModelSource firstObject].horsizeW > ScreenW-38) {
                        self.coverButton.hidden = NO;
                        self.enterButton.hidden = NO;
                    }else {
                        self.coverButton.hidden = YES;
                        self.enterButton.hidden = YES;
                    }
                 
                    CGFloat h = ScreenH- 45 - (isIPhoneX()?88:64)-50;
                    self.tableView.contentSize = CGSizeMake(ScreenW, [HFSectionModel headerVIPHeight: self.headerSource]+ScreenH);
                    self.enterButton.frame = CGRectMake(ScreenW-38, self.headerView.bottom, 38, 45);
                    self.coverButton.frame = CGRectMake(self.enterButton.left-17, self.headerView.bottom, 17, 45);
                    self.segmentNode.frame = CGRectMake(0, self.headerView.bottom, ScreenW-38, 45);
                    [self.segmentNode reloadData];
                    self.collectionView.frame = CGRectMake(0, self.headerView.bottom+45, ScreenW,  h);
                    [self.collectionView reloadData];
                }
              
            }else{
          
                self.tableView.contentSize = CGSizeMake(ScreenW, [HFSectionModel headerVIPHeight: self.headerSource]);
            }
        }else {
            if (self.headerView.dataSource == 0) {
                [self.tableView setErrorImage:@"" text:@"抱歉,这个星球暂时找不到"];
            }
        }

    }];
    [self.viewModel.VipSearchSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray *array = x;
            if (array.count >0) {
                if ([self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count >0) {
                    for (HFSegementModel *model in [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray) {
                        if (model.isSelected == YES) {
                            model.dataSource = array;
                            [self.viewModel.getAllKey setObject:array forKey:model.channelId];
                            break;
                        }
                    }
                    
                    [self.collectionView reloadData];
                }
            }
        }
    }];

   
}
- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
        return   [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count;

}
- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        HFSegementModel *model =     [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray[indexPath.row];
        HFSegementNode *segment = [[HFSegementNode alloc] initWithModel:model];
        return segment;
    };
    return cellNodeBlock;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HFSegementModel *model =      [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray[indexPath.row];
    HFVIpClassCategoryNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HFVIpClassCategoryNewCell class]) forIndexPath:indexPath];
     cell .model = model;
    @weakify(self)
    cell.didGoodsBlock = ^(HFVIPModel *vipmodel) {
        @strongify(self)
        [self.viewModel.didGoodsSubjc sendNext:vipmodel];
    };
    
    return cell;
}
- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        NSPredicate *regex = [NSPredicate predicateWithFormat:@"isSelected == YES"];
        HFSegementModel *selectmodel =  [[[self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray filteredArrayUsingPredicate:regex] firstObject];
        selectmodel.isSelected = NO;
        HFSegementModel *model =     [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray[indexPath.item];

        if ([selectmodel.channelId isEqualToString:model.channelId]) {
            
            return;
        }
        model.isSelected = YES;
        [self.segmentNode selectItemAtIndexPath:[NSIndexPath indexPathForItem: indexPath.item inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.segmentNode reloadData];
        if (![self.viewModel.getAllKey objectForKey:model.channelId]) {
            
            if (model.channelId.length !=0) {
                self.viewModel.keyWord = model.name;
                self.viewModel.classId = model.channelId;
//                [self.viewModel.VipSearchCommand execute:nil];
            }
        }
        [self.collectionView setContentOffset:CGPointMake(ScreenW*indexPath.item, 0) animated:YES];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.tableView.scrollEnabled = YES;
        self.bottomEnabled = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        self.bottomEnabled = NO;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        if(!self.viewModel.classCategoryModel.isModuleShow) {
            return;
        }
        CGFloat bottomCellOffset = [HFSectionModel headerVIPHeight:self.headerSource];
     
        
        if (self.tableView.contentOffset.y >= bottomCellOffset) {
            self.tableView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
              HFVIpClassCategoryNewCell *contentNode =  [[self.collectionView visibleCells] firstObject];
               contentNode.bottomCanscroll = YES;
        
            }
        }else{
            //子视图没到顶部
            if (!self.canScroll) {
                self.tableView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }

    if ([scrollView isEqual:self.collectionView]) {

        if (!self.bottomEnabled) {
            self.tableView.scrollEnabled = NO;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    if ([scrollView isEqual:self.collectionView]) {
          self.bottomEnabled = YES;
          self.tableView.scrollEnabled = YES;
//        if (self.collectionView.contentOffset.x >(self.index*ScreenW+ScreenW * 0.5)) {
            NSInteger   index = (self.collectionView.contentOffset.x + ScreenW * 0.5) / ScreenW;

            NSPredicate *regex = [NSPredicate predicateWithFormat:@"isSelected == YES"];
            HFSegementModel *selectmodel =  [[[self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray filteredArrayUsingPredicate:regex] firstObject];
            selectmodel.isSelected = NO;
            HFSegementModel *model =  [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray[index];
            model.isSelected = YES;
            [self.segmentNode selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            [self.segmentNode reloadData];
        if (![self.viewModel.getAllKey objectForKey:model.channelId] ) {

            if (model.channelId.length !=0) {
                self.viewModel.keyWord = model.name;
                self.viewModel.classId = model.channelId;
//                [self.viewModel.getAllKey setObject:@[] forKey:model.channelId];
                [self.viewModel.VipSearchCommand execute:nil];
            }
        }
        self.index = index;
//        }

      
    }
    
}
//滚动到最后一列
- (void)scrollToClick{
    if ([self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray>0) {
        HFSegementModel *model =  [self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray[[self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count-1];
        NSPredicate *regex = [NSPredicate predicateWithFormat:@"isSelected == YES"];
        HFSegementModel *selectmodel =  [[[self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray filteredArrayUsingPredicate:regex] firstObject];
        selectmodel.isSelected = NO;
        model.isSelected = YES;
        [self.segmentNode scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self.viewModel.classCategoryModel.dataModelSource firstObject].dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        if (![self.viewModel.getAllKey objectForKey:model.channelId]) {
            
            if (model.channelId.length !=0) {
                self.viewModel.keyWord = model.name;
                self.viewModel.classId = model.channelId;
                [self.viewModel.VipSearchCommand execute:nil];
            }
        }
        
    }
}
- (void)loadData:(NSInteger)index {
    
}
- (HFYDTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HFYDTableView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, self.height-50)];
        
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
       _tableView.showsHorizontalScrollIndicator = NO;
    
    }
    return _tableView;
}
- (HFVIPNewHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HFVIPNewHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [HFSectionModel headerVIPHeight: self.headerSource]) WithViewModel:self.viewModel];
        _headerView.backgroundColor  = [UIColor whiteColor];
    }
    return _headerView;
}
- (ASCollectionNode *)segmentNode {
    if (!_segmentNode) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _segmentNode = [[ASCollectionNode alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _segmentNode.delegate = self;
        _segmentNode.dataSource = self;
        _segmentNode.leadingScreensForBatching = 1;
        _segmentNode.view.showsVerticalScrollIndicator = NO;
        _segmentNode.view.showsHorizontalScrollIndicator = NO;
    
     
    }
    return _segmentNode;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
         CGFloat h = ScreenH- 45 - (isIPhoneX()?88:64)-50;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(ScreenW,  h );
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HFVIpClassCategoryNewCell class] forCellWithReuseIdentifier:NSStringFromClass([HFVIpClassCategoryNewCell class])];
    }
    return _collectionView;
}
- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        [_enterButton setImage:[UIImage imageNamed:@"car_category"] forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(scrollToClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}
- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] init];
        [_coverButton setImage:[UIImage imageNamed:@"vip_cover"] forState:UIControlStateNormal];
    }
    return _coverButton;
}
- (NSMutableArray *)indexPathesToBeReloaded {
    if(!_indexPathesToBeReloaded){
        _indexPathesToBeReloaded = [NSMutableArray array];
    }
    return  _indexPathesToBeReloaded;
}
- (NSMutableDictionary *)getAllKey {
    if (!_getAllKey) {
        _getAllKey = [NSMutableDictionary dictionary];
    }
    return _getAllKey;
}
- (ASButtonNode *)buttonNode {
    if (!_buttonNode) {
        _buttonNode = [HFUIkit nodeButtonNodeAddNode:nil Title:@"请输入商品名称" TitleColor:[UIColor colorWithHexString:@"999999"] Font:[UIFont systemFontOfSize:14] Image:[UIImage imageNamed:@"home_search_icon"] ImageAlignment:ASButtonNodeImageAlignmentBeginning CornerRadius:15 BackgroundColor:[UIColor colorWithHexString:@"F0F0F0"] ContentVerticalAlignment:ASVerticalAlignmentCenter ContentHorizontalAlignment:ASHorizontalAlignmentNone];
        _buttonNode.frame = CGRectMake(15, 10, ScreenW-30, 30);
        _buttonNode.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _buttonNode.contentSpacing = 5;
        _buttonNode.hidden = YES;
    }
    return _buttonNode;
}
@end
