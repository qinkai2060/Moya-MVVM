//
//  HFWDMainView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFWDMainView.h"
#import "HFYDDetialViewModel.h"
#import "HFWDHeaderView.h"
#import "HFYDCarView.h"
#import "HFWDProductCell.h"
#import "HFTableViewnView.h"
@interface HFWDMainView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,strong)HFWDHeaderView *headerView;
@property(nonatomic,strong)HFYDCarView *carCoverView;
@property(nonatomic,strong)HFTableViewnView *tableView;
@property(nonatomic,strong)UIButton *payMentBtn;
@property(nonatomic,strong)UIView *dibuView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton *carIconBtn;
@property(nonatomic,strong)UIButton *priceBtn;
@property(nonatomic,strong)HFYDDetialDataModel *model;
@end
@implementation HFWDMainView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.customNavBar];
    [self addSubview:self.tableView];
    [self addSubview:self.headerView];
    [self addSubview:self.carCoverView];
    [self addSubview:self.bgView];
    [self addSubview:self.payMentBtn];
    [self addSubview:self.dibuView];
    [self addSubview:self.carIconBtn];
    [self addSubview:self.priceBtn];
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.wdDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        CGFloat ipx = IS_iPhoneX?34:0;
        self.tableView.frame = CGRectMake(0, self.customNavBar.bottom, ScreenW, self.height-self.customNavBar.height-50-ipx);
         if ([x isKindOfClass:[HFYDDetialDataModel class]]) {
             HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;
             self.model = model;
             self.headerView.frame = CGRectMake(0, 0, ScreenW, 301);
             self.tableView.tableHeaderView = self.headerView;
             
             self.bgView.frame = CGRectMake(0, self.height-50-ipx, ScreenW, 50+ipx);
             self.payMentBtn.frame = CGRectMake(ScreenW-110, self.height-50-ipx, 110, 50);
             self.dibuView.frame = CGRectMake(0, self.height-50-ipx, self.payMentBtn.left, 50);
             self.carIconBtn.frame = CGRectMake(10, self.height-68-5-ipx, 58, 68);
             self.priceBtn.frame = CGRectMake(self.carIconBtn.right+5, self.height-50-ipx, self.dibuView.width-self.carIconBtn.right-5-5, 50);
             self.priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.priceBtn.width)/2, 0, 0);
             [self.tableView reloadData];
         }else{
             [self.tableView setErrorImage:erroImageStr text:@"暂无数据"];
         }

        
    }];

    
    [[self.carIconBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.carCoverView.isShow) {
            [self.carCoverView dissMissCar];
        }else {
            self.carCoverView.hidden = NO;
            [self.carCoverView showCar];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.wdList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFWDProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HFWDProductCell" forIndexPath:indexPath];
    HFYDDetialRightDataModel *model =  self.model.wdList[indexPath.row];
    cell.model = model;
    [cell doMessageSomething];
    return cell;
    
}
- (HFWDHeaderView *)headerView {
    if (!_headerView) {
        CGFloat ipx = IS_IPHONE_X()?88:64;
        _headerView = [[HFWDHeaderView alloc] initWithFrame:CGRectMake(0, ipx, ScreenW, 270) WithViewModel:self.viewModel];
    }
    return _headerView;
}
- (WRCustomNavigationBar *)customNavBar {
    if (!_customNavBar) {
        CGFloat navH = IS_iPhoneX?88:64;
        _customNavBar = [[WRCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, navH)];
        _customNavBar.title = @"云店";
        [_customNavBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"HMH_back_light"] highlighted:[UIImage imageNamed:@"HMH_back_light"]];
        [_customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"highEnd_title_forward"]];
    }
    return _customNavBar;
}
- (UIButton *)payMentBtn {
    if (!_payMentBtn) {
        _payMentBtn = [HFUIkit btnWithfont:15 text:@"请选购" titleColor:@"ffffff" selectTitleColor:@"999999" disableColor:@"999999" backGroundColor:@"ED0505"];
    }
    return _payMentBtn;
}
- (UIView *)dibuView {
    if (!_dibuView) {
        _dibuView = [[UIView alloc] init];
        _dibuView.backgroundColor = [UIColor colorWithHexString:@"333333"];
    }
    return _dibuView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _bgView;
}
- (UIButton *)carIconBtn {
    if (!_carIconBtn) {
        _carIconBtn = [HFUIkit image:@"yd_car" selectImage:@"yd_car_none"];
        
    }
    return _carIconBtn;
}
- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [HFUIkit btnWithfont:13 text:@"购物车是空的" titleColor:@"ffffff" selectTitleColor:@"999999"];
        
    }
    return _priceBtn;
}
- (HFYDCarView *)carCoverView {
    if (!_carCoverView) {
        CGFloat ipx = IS_iPhoneX?34:0;
        _carCoverView = [[HFYDCarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-50-ipx) WithViewModel:self.viewModel];
        _carCoverView.hidden = YES;
    
    }
    return _carCoverView;
}
- (HFTableViewnView *)tableView {
    if (!_tableView) {
        _tableView = [HFUIkit hf_tableViewWith:UITableViewStylePlain delegate:self cellClass:[HFWDProductCell class] Identifier:@"HFWDProductCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
