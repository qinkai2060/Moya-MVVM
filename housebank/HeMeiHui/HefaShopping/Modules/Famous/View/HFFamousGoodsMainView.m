//
//  HFFamousGoodsMainView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousGoodsMainView.h"
#import "HFFamousGoodsViewModel.h"
#import "HFFamousGoodsHeaderView.h"
#import "HFFamousCell.h"
#import "HFTableViewnView.h"

@interface HFFamousGoodsMainView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HFFamousGoodsViewModel *viewModel;
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)HFFamousGoodsHeaderView *headerView;
@property(nonatomic,strong)UIButton *topBtn;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL isload;
@property(nonatomic,assign)CGFloat currentOffsetY;
@end
@implementation HFFamousGoodsMainView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.tableView];
    CGFloat nav = IS_iPhoneX ? 44:10;
    self.topBtn.frame = CGRectMake(ScreenW-48-10, self.height-48-30, 48, 48);
    [self addSubview:self.topBtn];
    
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.dataSendSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if ([x isKindOfClass:[NSArray class]]) {
            if (((NSArray*)x).count>0) {
                if (self.viewModel.pageNum == 1) {
                     NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                    [array removeAllObjects];
                    self.dataArray = array;
                }
                [self.tableView haveData];
                NSArray *dataArray = (NSArray*)x;
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
                [array addObjectsFromArray:dataArray];
                self.dataArray = array;
                [self.tableView reloadData];
            }else {
                if (self.viewModel.pageNum >=0) {
                     self.viewModel.pageNum--;
                }else {
                    self.viewModel.pageNum = 1;
                }
               
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
    
        }else {
            if (self.viewModel.pageNum >=0) {
                self.viewModel.pageNum--;
            }else {
                self.viewModel.pageNum = 1;
            }
            [self.tableView setErrorImage:erroImageStr text:@"抱歉,这个星球找不到呢!"];
        }
         self.isload= NO;
    }];
    [self.viewModel.headerdataSendSubjc subscribeNext:^(id  _Nullable x) {
        NSArray *array = (NSArray*)x;
        if ([x isKindOfClass:[NSArray class]]&&array.count >0) {
            self.headerView.array = array;
            self.tableView.tableHeaderView = self.headerView;
        }
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (!self.isload) {
            
            [self reloadFooterMoreData];
        }
      
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (!self.isload) {
            self.viewModel.pageNum=1;
            [self reloadMoreData];
        }
       
    }];
}
- (void)topClick {

   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES]; 
}
- (void)reloadFooterMoreData {
   
    self.isload = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
     self.viewModel.pageNum++;
    [self.viewModel.dataCommand execute:nil];
}
- (void)reloadMoreData {
    self.isload = YES;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.viewModel.dataCommand execute:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFamousCell *cell = [tableView dequeueReusableCellWithIdentifier:@"famousCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HFFamousGoodsModel *dataModel = self.dataArray[indexPath.row];
    cell.dataModel = dataModel;
    [cell dosomethingMessage];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HFFamousGoodsModel *dataModel = self.dataArray[indexPath.row];
    [self.viewModel.didSelectSubjc sendNext:dataModel];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   

  self.topBtn.hidden = !(scrollView.contentOffset.y > 0&&self.dataArray.count>0);
}

- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HFFamousCell class] forCellReuseIdentifier:@"famousCell"];
    }
    return _tableView;
}
- (HFFamousGoodsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HFFamousGoodsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 160) WithViewModel:self.viewModel];
    }
    return _headerView;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] init];
        [_topBtn setImage:[UIImage imageNamed:@"float"] forState:UIControlStateNormal];
        _topBtn.hidden = YES;
        [_topBtn addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}
@end
