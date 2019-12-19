//
//  HFKeyBordView.m
//  housebank
//
//  Created by usermac on 2018/12/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFKeyBordView.h"
@interface HFKeyBordView()
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@end
@implementation HFKeyBordView

- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
+ (void)show:(NSNotification*)noti  {
    
  
 
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self addSubview:self.bottomView];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.width.equalTo(self);
//        make.height.equalTo(@50);
//    }];
    [self.bottomView addSubview:self.cancelBtn];
    [self.bottomView addSubview:self.sureBtn];
    self.cancelBtn.frame = CGRectMake(0, 0, 62, 50);
    self.sureBtn.frame = CGRectMake(ScreenW-62, 0, 62, 50);
    
}
- (void)sureEventClick:(UIButton*)btn {
        [self endEditing:YES];
    if (self.sBlock) {
        self.sBlock();
    }
}
- (void)cancelEventClick:(UIButton*)btn {

    if (self.cBlock) {
        self.cBlock();
    }
    [self endEditing:YES];
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bottomView;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"F3344A"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn addTarget:self action:@selector(sureEventClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(cancelEventClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
