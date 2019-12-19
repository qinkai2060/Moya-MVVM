//
//  HFLoginView.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFLoginView.h"
#import "HFLoginViewModel.h"
#import "HFPassWordLoginView.h"
#import "HFCodeLoginView.h"

@interface HFLoginView()<UIScrollViewDelegate>
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@property(nonatomic,strong)HFPassWordLoginView *passWordView;
@property(nonatomic,strong)HFCodeLoginView *codeView;
@property(nonatomic,strong)UIButton *passLoginBtn;
@property(nonatomic,strong)UIButton *codeLoginBtn;
@property(nonatomic,strong)UIScrollView *scrolleview;
@end
@implementation HFLoginView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.passLoginBtn.frame = CGRectMake(30, 30, 90, 30);
    self.codeLoginBtn.frame = CGRectMake(self.passLoginBtn.right+30, 30, 120, 30);
    self.scrolleview.frame = CGRectMake(0, self.codeLoginBtn.bottom+40, ScreenW, self.height-self.codeLoginBtn.bottom-40);
    [self addSubview:self.passLoginBtn];
    [self addSubview:self.codeLoginBtn];
    [self addSubview:self.scrolleview];
    [self.scrolleview addSubview:self.passWordView];
    [self.scrolleview addSubview:self.codeView];
    if (@available(iOS 11.0, *)) {
        
        self.scrolleview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
}
- (void)hh_bindViewModel {
    @weakify(self)
    [[self.passLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.codeLoginBtn.selected = NO;
        self.passLoginBtn.selected = YES;
        [self.scrolleview setContentOffset:CGPointMake(0, 0)];
    }];
    [[self.codeLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.codeLoginBtn.selected = YES;
        self.passLoginBtn.selected = NO;
        [self.scrolleview setContentOffset:CGPointMake(ScreenW, 0)];
    }];
    [self.viewModel.findSuccessPhoneSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.scrolleview setContentOffset:CGPointMake(0, 0)];
    }];
}
- (void)editingEndSuccess {
    [self.passWordView editingEndSuccess];
}
- (UIButton *)passLoginBtn {
    if (!_passLoginBtn) {
        _passLoginBtn = [[UIButton alloc] init];
        [_passLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        [_passLoginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [_passLoginBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _passLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _passLoginBtn.selected = YES;
    }
    return _passLoginBtn;
}
- (UIButton *)codeLoginBtn {
    if (!_codeLoginBtn) {
        _codeLoginBtn = [[UIButton alloc] init];
        [_codeLoginBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_codeLoginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        [_codeLoginBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _codeLoginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    return _codeLoginBtn;
}
- (UIScrollView *)scrolleview {
    if (!_scrolleview) {
        _scrolleview = [[UIScrollView alloc] init];
        _scrolleview.contentSize = CGSizeMake(ScreenW*2, 0);
        _scrolleview.delegate = self;
        _scrolleview.scrollEnabled = NO;
        _scrolleview.pagingEnabled = YES;
        _scrolleview.showsVerticalScrollIndicator = NO;
        _scrolleview.showsHorizontalScrollIndicator = NO;
        _scrolleview.backgroundColor = [UIColor whiteColor];
        _scrolleview.bounces = NO;
    }
    return _scrolleview;
}
- (HFPassWordLoginView *)passWordView {
    if (!_passWordView) {
        _passWordView = [[HFPassWordLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.scrolleview.height) WithViewModel:self.viewModel];
    }
    return _passWordView;
}
- (HFCodeLoginView *)codeView {
    if (!_codeView) {
        _codeView = [[HFCodeLoginView alloc] initWithFrame:CGRectMake(ScreenW, 0, ScreenW, self.scrolleview.height) WithViewModel:self.viewModel];
    }
    return _codeView;
}
@end
