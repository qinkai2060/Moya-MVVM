//
//  HFYDDetialMainView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDDetialMainView.h"
#import "HFYDDetialViewModel.h"
#import "HFYDDetialHeaderView.h"
#import "HFYDTableView.h"
#import "HFYDMainBottomView.h"
#import "HFYDCarView.h"
#import "HFYDDetialDataModel.h"
@interface HFYDDetialMainView ()<UITableViewDelegate>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;

@property(nonatomic,strong)HFYDDetialHeaderView *headerView;
@property(nonatomic,strong)HFYDTableView *tableView;
@property(nonatomic,strong)HFYDMainBottomView *bottomView;
@property(nonatomic,strong)HFYDCarView *carCoverView;
@property(nonatomic,strong)UIButton *payMentBtn;
@property(nonatomic,strong)UIView *dibuView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton *carIconBtn;
@property(nonatomic,strong)UIButton *priceBtn;
@end
@implementation HFYDDetialMainView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.canScroll = YES;
    self.appcanScroll = YES;
    
    [self addSubview:self.customNavBar];
    [self addSubview:self.tableView];
    [self.tableView addSubview:self.headerView];
    [self.tableView addSubview:self.bottomView];
    [self addSubview:self.carCoverView];
    [self addSubview:self.bgView];
    [self addSubview:self.payMentBtn];
    [self addSubview:self.dibuView];
    [self addSubview:self.carIconBtn];
    [self addSubview:self.priceBtn];
    self.priceBtn.selected = YES;
    self.carIconBtn.selected = YES;
    
}

- (void)hh_bindViewModel {
    @weakify(self)

    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
       @strongify(self)
     if (x && [x isKindOfClass:[HFYDDetialDataModel class]]) {
          HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;
 
         if (model.shopsBaseInfo.provinceId !=0) {
             self.tableView.frame = CGRectMake(0, self.customNavBar.height, ScreenW, self.height-self.customNavBar.height);
             self.headerView.frame = CGRectMake(0, 0, ScreenW, model.shopsBaseInfo.HeaderHight);
             self.bottomView.frame = CGRectMake(0, self.headerView.bottom, ScreenW, self.height-self.customNavBar.height);
             CGFloat ipx = IS_iPhoneX?34:0;
             self.bgView.frame = CGRectMake(0, self.height-50-ipx, ScreenW, 50+ipx);
             self.tableView.contentSize = CGSizeMake(0, self.height-self.customNavBar.height+ model.shopsBaseInfo.HeaderHight);
             self.payMentBtn.frame = CGRectMake(ScreenW-110, self.height-50-ipx, 110, 50);
             self.dibuView.frame = CGRectMake(0, self.height-50-ipx, self.payMentBtn.left, 50);
             self.carIconBtn.frame = CGRectMake(10, self.height-68-5-ipx, 58, 68);
             self.priceBtn.frame = CGRectMake(self.carIconBtn.right+5, self.height-50-ipx, self.dibuView.width-self.carIconBtn.right-5-5, 50);
             self.priceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.priceBtn.width)/2, 0, 0);
             self.carIconBtn.selected = model.shopsBaseInfo.cartCount == 0?NO:YES;
             if (self.carIconBtn.selected) {
                 self.priceBtn.selected = YES;
                 self.payMentBtn.selected = YES;
                  self.payMentBtn.enabled =YES;
                 [self.priceBtn setTitle:@"¥138.00" forState:UIControlStateNormal];
                 [self.payMentBtn setTitle:@"¥138.00" forState:UIControlStateNormal];
                 self.payMentBtn.backgroundColor = [UIColor colorWithHexString:@"ED0505"];
             }else {
                 self.priceBtn.selected = NO;
                 self.payMentBtn.selected = NO;
                 self.payMentBtn.enabled =NO;
                 [self.priceBtn setTitle:@"购物车是空的" forState:UIControlStateNormal];
                 [self.payMentBtn setTitle:@"请选购" forState:UIControlStateNormal];
                 self.payMentBtn.backgroundColor = [UIColor colorWithHexString:@"4F4F4F"];
             }
         }
     }else {
//         [MBProgressHUD showAutoMessage:@"请求失败"];
     }
       
    }];
    [self.viewModel.addOrminCarSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.selectCarCommand execute:nil];
    }];
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if ([[[x allObjects] firstObject] isKindOfClass:[HFYDTableView class]]) {
            HFYDTableView *tb =  (HFYDTableView*)[[x allObjects] firstObject];
            CGFloat tagget = 340;
            if (tb.contentOffset.y >= tagget) {
                self.canScroll = NO;
                self.appcanScroll = NO;
                [self.viewModel.subCanSubjc sendNext:@(YES)];
            }else {
                self.appcanScroll = YES;
                self.canScroll = YES;
//               [self.viewModel.subCanSubjc sendNext:@(NO)];
            }
           
        }
    }];
    [self.viewModel.appcanscrollSubjc  subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.appcanScroll = [x boolValue];
    }];
    [self.viewModel.canscrollSubjc  subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.canScroll = [x boolValue];
    }];
    [[self.carIconBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (![HFUserDataTools isLogin]) {
            [self.viewModel.loginSubjc sendNext:nil];
            return ;
        }
        if (!self.carIconBtn.selected) {
            return;
        }
        [self.viewModel.selectCarCommand execute:nil];
        if (self.carCoverView.isShow) {
            [self.carCoverView dissMissCar];
        }else {
             self.carCoverView.hidden = NO;
            [self.carCoverView showCar];
        }
    }];

}
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    if (!canScroll) {
        self.tableView.contentOffset = CGPointMake(0, 340);
    }
}
- (void)setAppcanScroll:(BOOL)appcanScroll {
    _appcanScroll = appcanScroll;
    if (!appcanScroll) {
        self.tableView.contentOffset = CGPointMake(0, 340);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
- (HFYDDetialHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HFYDDetialHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 345) WithViewModel:self.viewModel];
    }
    return _headerView;
}
- (HFYDTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HFYDTableView  alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.height-self.customNavBar.height)];
        _tableView.delegate = self;
    }
    return _tableView;
}
- (HFYDMainBottomView *)bottomView {
    if(!_bottomView) {
        CGFloat tabH = IS_IPHONE_X()?(71+34):71;
        _bottomView = [[HFYDMainBottomView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, ScreenW,self.height-self.customNavBar.height-tabH) WithViewModel:self.viewModel];
    }
    return _bottomView;
}
- (UIButton *)payMentBtn {
    if (!_payMentBtn) {
        _payMentBtn = [HFUIkit btnWithfont:15 text:@"请选购" titleColor:@"999999" selectTitleColor:@"ffffff" disableColor:@"999999" backGroundColor:@"ED0505"];
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
        _carIconBtn = [HFUIkit image:@"yd_car_none" selectImage:@"yd_car"];
        
    }
    return _carIconBtn;
}
- (UIButton *)priceBtn {
    if (!_priceBtn) {
        _priceBtn = [HFUIkit btnWithfont:13 text:@"购物车是空的" titleColor:@"999999" selectTitleColor:@"ffffff"];
       
    }
    return _priceBtn;
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
- (HFYDCarView *)carCoverView {
    if (!_carCoverView) {
        CGFloat ipx = IS_iPhoneX?34:0;
        _carCoverView = [[HFYDCarView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-50-ipx) WithViewModel:self.viewModel];
        _carCoverView.hidden = YES;
    }
    return _carCoverView;
}
@end
