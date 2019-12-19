//
//  HFYDMainBottomView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDMainBottomView.h"
#import "HFYDDetialViewModel.h"
#import "UIButton+HQCustomIcon.h"
#import "HFYDTableView.h"
#import "HFYDProductView.h"
#import "HFAPPriaseView.h"
@interface HFYDMainBottomView ()<UIScrollViewDelegate>
@property(nonatomic,strong)HFYDDetialViewModel *viewModel;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)UIButton *productBtn;
@property(nonatomic,strong)UIButton *appraiseBtn; //评价
@property(nonatomic,strong)UIImageView *indecatoImgV;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *wedianBtn;
@property(nonatomic,strong)UIView *lineView2;

@property(nonatomic,strong)HFYDTableView *tableView;
@property(nonatomic,strong)HFYDProductView *productView;
@property(nonatomic,strong)HFAPPriaseView *appRiaseView;
@end
@implementation HFYDMainBottomView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFYDDetialViewModel*)viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.wedianBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.productBtn];
    [self addSubview:self.appraiseBtn];
    [self addSubview:self.indecatoImgV];
    [self addSubview:self.lineView2];
    [self addSubview:self.tableView];
    [self.tableView addSubview:self.productView];
    [self.tableView addSubview:self.appRiaseView];
    
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.ydDataSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFYDDetialDataModel class]]) {
            HFYDDetialDataModel *model = (HFYDDetialDataModel*)x;
            self.indecatoImgV.image = [UIImage imageNamed:@"yd_indector"];
            self.wedianBtn.frame = CGRectMake(ScreenW-101, 0, 101, 44);
            self.lineView.frame = CGRectMake(self.wedianBtn.left-0.5, 10, 0.5, 24);
            self.productBtn.frame = CGRectMake(0, 0, (self.lineView.left-101)*0.5, 44);
            self.appraiseBtn.frame =  CGRectMake(self.productBtn.right, 0, (self.lineView.left-101)*0.5, 44);
            self.indecatoImgV.frame = CGRectMake((self.appraiseBtn.width-(self.appraiseBtn.width-60)*0.5)*0.5, self.appraiseBtn.bottom, (self.appraiseBtn.width-60)*0.5, 2);
            self.indecatoImgV.centerX = self.productBtn.centerX;
            [self.wedianBtn setIconInRightWithSpacing:5];
            self.lineView2.frame = CGRectMake(0, self.indecatoImgV.bottom, ScreenW , 0.5);
            self.tableView.frame = CGRectMake(0, self.lineView2.bottom, ScreenW ,self.height-34);
            self.tableView.backgroundColor = [UIColor redColor];
            self.tableView.contentSize = CGSizeMake(ScreenW*2, 0);
            self.productView.frame = CGRectMake(0, 0, ScreenW, self.tableView.height);
//            self.wedianBtn.hidden = model.isContainWD;
//            self.lineView.hidden = model.isContainWD;
        
        }
    }];

    /**
     商品
     */
    [[self.productBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        self.selectIndex = 0;
        self.indecatoImgV.centerX = self.productBtn.centerX;
        [self.viewModel.didProductSubjc sendNext:nil];
    }];
    
    /**
     评价点击
     */
    [[self.appraiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.tableView setContentOffset:CGPointMake(ScreenW, 0)];
        self.selectIndex = 1;
        self.indecatoImgV.centerX = self.appraiseBtn.centerX;
        [self.viewModel.didApprriaseSubjc sendNext:nil];
    }];
    [[self.wedianBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.enterWDSubjc sendNext:nil];
    }];
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        NSInteger index = (self.tableView.contentOffset.x + self.tableView.bounds.size.width * 0.5) / ScreenW;
        [self.tableView setContentOffset:CGPointMake(index*ScreenW, 0)];
        self.selectIndex = index;
        if (self.selectIndex == 1) {
            self.indecatoImgV.centerX = self.appraiseBtn.centerX;
        }else {
            self.indecatoImgV.centerX = self.productBtn.centerX;
        }
    }];

}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView2;
}
- (UIButton *)wedianBtn {
    if (!_wedianBtn) {
        _wedianBtn = [HFUIkit btnWithfont:14 text:@"TA的微店" titleColor:@"ED0505" selectTitleColor:@"ED0505"];
        [_wedianBtn setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
        [_wedianBtn setTintColor:[UIColor colorWithHexString:@"ED0505"]];
     
    }
    return _wedianBtn;
}
- (UIButton *)productBtn {
    if (!_productBtn) {
        _productBtn = [HFUIkit btnWithfont:14 text:@"商品" titleColor:@"333333" selectTitleColor:@"000000"];
    }
    return _productBtn;
}
- (UIButton *)appraiseBtn {
    if (!_appraiseBtn) {
        _appraiseBtn = [HFUIkit btnWithfont:14 text:@"评价" titleColor:@"333333" selectTitleColor:@"000000"];
    }
    return _appraiseBtn;
}
- (UIImageView *)indecatoImgV {
    if (!_indecatoImgV) {
        _indecatoImgV = [[UIImageView alloc] init];
    }
    return _indecatoImgV;
}
- (HFYDTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HFYDTableView  alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.pagingEnabled = YES;
        _tableView.tag =  -1000;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (HFYDProductView *)productView {
    if (!_productView) {
        _productView = [[HFYDProductView alloc] initWithFrame:CGRectMake(0, self.lineView2.bottom, ScreenW ,self.height-34) WithViewModel:self.viewModel];
    }
    return _productView;
}
- (HFAPPriaseView *)appRiaseView {
    if (!_appRiaseView) {
        _appRiaseView = [[HFAPPriaseView alloc] initWithFrame:CGRectMake(ScreenW, self.lineView2.bottom, ScreenW ,self.height-34) WithViewModel:self.viewModel];
    }
    return _appRiaseView;
}
@end
