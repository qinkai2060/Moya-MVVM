//
//  HFHightEndGoodsMainView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHightEndGoodsMainView.h"
#import "HFHightEndGoodsViewModel.h"
#import "HFHighEndGoodsCell.h"
#import "HFTableViewnView.h"
@interface HFHightEndGoodsMainView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HFHightEndGoodsViewModel *viewModel;
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIButton *topBtn;
@property(nonatomic,assign)BOOL isload;
@end
@implementation HFHightEndGoodsMainView
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self reloadMoreData];
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
    HFHighEndGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFHighEndGoodsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HFDataModel *dataModel = self.dataArray[indexPath.row];
    cell.dataModel = dataModel;
    [cell dosomethingMessage];
    @weakify(self)
    cell.didSelect = ^(HFDataModel * model) {
        @strongify(self)
        [self.viewModel.didSelectSubjc sendNext:model];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     HFDataModel *dataModel = self.dataArray[indexPath.row];
     [self.viewModel.didSelectSubjc sendNext:dataModel];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    self.topBtn.hidden = !(scrollView.contentOffset.y > 0&&self.dataArray.count>0);
}
- (void)topClick {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HFHighEndGoodsCell class] forCellReuseIdentifier:@"HFHighEndGoodsCell"];
    }
    return _tableView;
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
