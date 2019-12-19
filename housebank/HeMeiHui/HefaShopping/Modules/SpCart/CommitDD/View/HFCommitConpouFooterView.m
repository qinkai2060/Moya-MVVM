//
//  HFCommitConpouFooterView.m
//  HeMeiHui
//
//  Created by usermac on 2019/1/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCommitConpouFooterView.h"
#import "HFPaymentBaseModel.h"

@interface HFCommitConpouFooterView ()
@property (nonatomic,strong) UILabel *disCountLb;
@property (nonatomic,strong) UIImageView *alertCouponsImgV;
@property (nonatomic,strong) UILabel *disTypeValueLb;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) CALayer *lineLayerOne;
@property (nonatomic,strong) CAGradientLayer *gratlayer;
@property (nonatomic,strong) UILabel *youHuiQLb;
@property (nonatomic,strong) UILabel *youHuiQCountLb;
@property (nonatomic,strong) UIImageView *youHuiQImgV;
@property (nonatomic,strong) UILabel *youHuiQShowLb;
@property (nonatomic,strong) UIButton *youHuiQBtn;
@property (nonatomic,strong) HFPayMentViewModel *viewModel;



@end
@implementation HFCommitConpouFooterView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.disCountLb];
    [self addSubview:self.alertCouponsImgV];
    [self.layer addSublayer:self.gratlayer];
    [self addSubview:self.disTypeValueLb];
    [self.layer addSublayer:self.lineLayerOne];
    [self addSubview:self.btn];
    
//    [self addSubview:self.youHuiQLb];
//    [self addSubview:self.youHuiQCountLb];
//    [self addSubview:self.youHuiQImgV];
//    [self addSubview:self.youHuiQShowLb];
//    [self addSubview:self.youHuiQBtn];
}
- (void)hh_bindViewModel {
    self.disCountLb.text = @"资产抵扣";

    self.disCountLb.frame = CGRectMake(15, 15, 70, 15);
    self.alertCouponsImgV.frame = CGRectMake(ScreenW-15-15, 15,15, 15);
    self.gratlayer.frame = CGRectMake(self.alertCouponsImgV.left-5-90-5, 13, 90+10, 20);
    self.disTypeValueLb.frame = CGRectMake(self.alertCouponsImgV.left-5-90, 15, 90, 15);
    self.lineLayerOne.frame = CGRectMake(15, self.disCountLb.bottom+15, ScreenW-30, 0.5);
    self.btn.frame = CGRectMake(0, 0, ScreenW, 45);
    
//    self.youHuiQLb.text = @"优惠券";
//    self.youHuiQCountLb.text = @"已选2张";
//    CGSize youHuiQLbSize = [self.youHuiQLb sizeThatFits:CGSizeMake(70, 15)];
//    CGSize youHuiQCountSize = [self.youHuiQCountLb sizeThatFits:CGSizeMake(70, 15)];
//    self.youHuiQLb.frame = CGRectMake(15,CGRectGetMaxY(self.lineLayerOne.frame)+15, youHuiQLbSize.width, 15);
//    self.youHuiQCountLb.frame = CGRectMake(self.youHuiQLb.right+15,CGRectGetMaxY(self.lineLayerOne.frame)+15, youHuiQCountSize.width+10, 15);
//    self.youHuiQImgV.frame = CGRectMake(ScreenW-15-15,CGRectGetMaxY(self.lineLayerOne.frame)+15, 15, 15);
//    self.youHuiQBtn.frame = CGRectMake(0, CGRectGetMaxY(self.lineLayerOne.frame), ScreenW, 45);
    @weakify(self)
    [self.viewModel.getAllPriceSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
         [self reloadUI];
    }];
    [[self.youHuiQBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
//        [ self.viewModel.showYHQSubjc sendNext:nil];
    }];
    
}
- (void)reloadUI {
    if(self.viewModel.payMentModel.contentMode == HFOrderShopModelTypeSelected ) {
        self.disTypeValueLb.frame = CGRectMake(self.disCountLb.right+5, 15, ScreenW-15-10-5-self.disCountLb.right-5, 15);
        self.disTypeValueLb.text = [NSString stringWithFormat:@"抵扣券 -¥ %.f",self.viewModel.payMentModel.allIntegralPrice];
        self.disTypeValueLb.font = [UIFont systemFontOfSize:14];
        self.disTypeValueLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        self.disTypeValueLb.textAlignment = NSTextAlignmentRight;
        self.gratlayer.hidden = YES;
    }else if (self.viewModel.payMentModel.contentMode == HFOrderShopModelTypeRegSelected){
        self.disTypeValueLb.frame = CGRectMake(self.disCountLb.right+5, 15, ScreenW-15-10-5-self.disCountLb.right-5, 15);
        self.disTypeValueLb.text = [NSString stringWithFormat:@"注册券 -¥ %.f",self.viewModel.payMentModel.regCoupon];
        self.disTypeValueLb.font = [UIFont systemFontOfSize:14];
        self.disTypeValueLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        self.disTypeValueLb.textAlignment = NSTextAlignmentRight;
        self.gratlayer.hidden = YES;
    }else if (self.viewModel.payMentModel.contentMode == HFOrderShopModelTypeOne){
        self.disTypeValueLb.frame = CGRectMake(self.alertCouponsImgV.left-5-90, 15, 90, 15);
        self.disTypeValueLb.text = @"1个可用";
        self.disTypeValueLb.font = [UIFont systemFontOfSize:12];
        self.disTypeValueLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.disTypeValueLb.textAlignment = NSTextAlignmentCenter;
        self.gratlayer.hidden = NO;
    }else if (self.viewModel.payMentModel.contentMode == HFOrderShopModelTypeMore) {
        self.disTypeValueLb.frame = CGRectMake(self.alertCouponsImgV.left-5-90, 15, 90, 15);
        self.disTypeValueLb.text = @"2个可用";
        self.disTypeValueLb.font = [UIFont systemFontOfSize:12];
        self.disTypeValueLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        self.gratlayer.hidden = NO;
        self.disTypeValueLb.textAlignment = NSTextAlignmentCenter;
    }else {
        self.disTypeValueLb.frame = CGRectMake(self.alertCouponsImgV.left-5-90, 15, 90, 15);
        self.disTypeValueLb.text = @"无可用";
        self.gratlayer.hidden = YES;
        self.disTypeValueLb.textColor = [UIColor colorWithHexString:@"333333"];
        self.disTypeValueLb.font = [UIFont systemFontOfSize:14];
        self.disTypeValueLb.textAlignment = NSTextAlignmentCenter;
    }
    

}
- (void)alertZhekouClick {
    [self.viewModel.didSelectQuanSubjc sendNext:nil];
}
- (CALayer *)lineLayerOne {
    if (!_lineLayerOne) {
        _lineLayerOne = [CALayer layer];
        _lineLayerOne.backgroundColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    }
    return _lineLayerOne;
}
- (UILabel *)disTypeValueLb {
    if (!_disTypeValueLb) {
        _disTypeValueLb = [[UILabel alloc] init];
        _disTypeValueLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _disTypeValueLb.font = [UIFont systemFontOfSize:15];
    }
    return _disTypeValueLb;
}
- (UIImageView *)alertCouponsImgV {
    if (!_alertCouponsImgV) {
        _alertCouponsImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon-arrow"]];
    }
    return _alertCouponsImgV;
}
- (CAGradientLayer *)gratlayer {
    if (!_gratlayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        
//        gradientLayer.frame = CGRectMake(self.alertCouponsImgV.left-5-size.width-5, 13, size.width+10, 20);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
        gradientLayer.cornerRadius = 2;
        gradientLayer.masksToBounds = YES;
        _gratlayer = gradientLayer;
//        [self.layer addSublayer:gradientLayer];
    }
    return _gratlayer;
}

- (UILabel *)disCountLb {
    if (!_disCountLb) {
        _disCountLb = [[UILabel alloc] init];
        _disCountLb.textColor = [UIColor colorWithHexString:@"333333"];
        _disCountLb.font = [UIFont systemFontOfSize:14];
    }
    return _disCountLb;
}
- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(alertZhekouClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
- (UILabel *)youHuiQLb {
    if (!_youHuiQLb) {
        _youHuiQLb = [HFUIkit textColor:@"333333" font:14 numberOfLines:1];
    }
    return _youHuiQLb;
}
- (UILabel *)youHuiQCountLb {
    if (!_youHuiQCountLb) {
        _youHuiQCountLb = [HFUIkit textColor:@"FF0000" font:10 numberOfLines:1];
        _youHuiQCountLb.layer.borderWidth = 1;
        _youHuiQCountLb.layer.borderColor = [UIColor colorWithHexString:@"FF0000"].CGColor;
        _youHuiQCountLb.layer.cornerRadius = 2;
        _youHuiQCountLb.layer.masksToBounds = YES;
        _youHuiQCountLb.textAlignment = NSTextAlignmentCenter;
    }
    return _youHuiQCountLb;
}
- (UIImageView *)youHuiQImgV {
    if (!_youHuiQImgV) {
        _youHuiQImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_icon-arrow"]];
    }
    return _youHuiQImgV;
}
- (UILabel *)youHuiQShowLb {
    if (!_youHuiQShowLb) {
        _youHuiQShowLb = [[UILabel alloc] init];
        _youHuiQShowLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _youHuiQShowLb.font = [UIFont systemFontOfSize:15];
    }
    return _youHuiQShowLb;
}
- (UIButton *)youHuiQBtn {
    if (!_youHuiQBtn) {
        _youHuiQBtn = [[UIButton alloc] init];
//        [_youHuiQBtn addTarget:self action:@selector(alertZhekouClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _youHuiQBtn;
}
@end
