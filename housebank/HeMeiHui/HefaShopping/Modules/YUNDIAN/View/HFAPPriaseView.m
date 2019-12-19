//
//  HFAPPriaseView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFAPPriaseView.h"
#import "HFYDDetialViewModel.h"
#import "HFYDDetialDataModel.h"
#import "HFTableViewnView.h"
#import "HFTextCovertImage.h"
#import "HFAPPRariseCell.h"
@interface HFAPPriaseView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)UILabel *storeScore;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation HFAPPriaseView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        self.tableView.contentOffset = CGPointZero;
    }
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.storeScore];
    [self addSubview:self.tableView];
    self.storeScore.frame = CGRectMake(15, 15, 150, 20);
    self.lineView.frame = CGRectMake(0, self.storeScore.bottom+15, ScreenW, 0.5);
    self.tableView.frame = CGRectMake(0, self.lineView.bottom, ScreenW, self.height-self.lineView.bottom);
    NSInteger score = 4;
    NSInteger badScore = 5-score;
    CGFloat minX = ScreenW-15-15;
    for (int i = 0; i < badScore; i++) {
        UIImageView *bade = [[UIImageView alloc] initWithFrame:CGRectMake(minX, 20, 15, 15)];
        bade.image = [UIImage imageNamed:@"yd_score_bad"];
        [self addSubview:bade];
        minX = bade.left-5-15;
    }
    for (int i = 0; i < score; i++) {
        UIImageView *good = [[UIImageView alloc] initWithFrame:CGRectMake(minX, 20, 15, 15)];
        good.image = [UIImage imageNamed:@"yd_score"];
        [self addSubview:good];
        minX = good.left-5-15;
    }
    self.storeScore.attributedText  = [HFTextCovertImage attrbuteStr:[NSString stringWithFormat:@"店铺评分 5.0"] rangeOfArray:@[@"5.0"] font:16 color:@"F3344A"];
    @weakify(self)
    [self.viewModel.subCanSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.canScroll = [x boolValue];
        NSLog(@"评价%d %f",self.canScroll,self.tableView.contentOffset.y);
    }];
    [self.viewModel.didApprriaseSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.canScroll = NO;
    }];
}
- (void)hh_bindViewModel {
//               self.reivewLb.attributedText = [HFTextCovertImage attrbuteStr:[NSString stringWithFormat:@"%ld分 来自 %ld 条点评",self.model.commentScore,self.model.commentNum] rangeOfArray:@[[NSString stringWithFormat:@"%ld分",self.model.commentScore],[NSString stringWithFormat:@"%ld",self.model.commentNum]] font:12 color:@"FF6600"];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UITableView  *tab = scrollView;
    if (!self.canScroll) {
        [tab setContentOffset:CGPointZero];
    }
    CGFloat offsetY = tab.contentOffset.y;
    if (offsetY<=0) {
        [self.viewModel.appcanscrollSubjc sendNext:@(YES)];
        self.canScroll = NO;
        tab.contentOffset = CGPointZero;
    }else {
        [self.viewModel.appcanscrollSubjc sendNext:@(NO)];
        self.canScroll = YES;
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [HFYDDetialRariseDataModel dataSource].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFYDDetialRariseDataModel *model =    [HFYDDetialRariseDataModel dataSource][indexPath.row];
    return model.rowHight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFAPPRariseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFAPPRariseCell" forIndexPath:indexPath];
    HFYDDetialRariseDataModel *model =    [HFYDDetialRariseDataModel dataSource][indexPath.row];
    cell.model = model;
    [cell doMessageSomthing];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UILabel *)storeScore {
    if (!_storeScore) {
        _storeScore = [HFUIkit textColor:@"333333" font:16 numberOfLines:0];
    }
    return _storeScore;
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [[HFTableViewnView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HFAPPRariseCell class] forCellReuseIdentifier:@"HFAPPRariseCell"];
        _tableView.tag = 10002;
    }
    return _tableView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView;
}
@end
