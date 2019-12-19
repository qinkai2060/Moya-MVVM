//
//  HFCarEmptyGoodsView.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarEmptyGoodsView.h"
#import "HFCarViewModel.h"
@interface HFCarEmptyGoodsView ()
@property (nonatomic,strong) UIImageView *emptyImageV;
@property (nonatomic,strong) UILabel *tipLb;
@property (nonatomic,strong) UIButton *eventBtn;

@property (nonatomic,strong) HFCarViewModel *viewModel;
@end
@implementation HFCarEmptyGoodsView
- (id)initWithFrame:(CGRect)frame WithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    if (self = [super initWithFrame:frame WithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.emptyImageV];
    [self addSubview:self.tipLb];
    [self addSubview:self.eventBtn];
}
- (void)enterClick {
    [self.viewModel.goCategorySubjc sendNext:nil];
}
- (UIButton *)eventBtn {
    if (!_eventBtn) {
        _eventBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenW-200)*0.5, self.tipLb.bottom+20, 200, 30)];
        _eventBtn.backgroundColor = [UIColor colorWithHexString:@"#FF2E5D"];
        [_eventBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_eventBtn addTarget:self action:@selector(enterClick) forControlEvents:UIControlEventTouchUpInside];
//         [_eventBtn setBackgroundImage:[[UIImage imageNamed:@"disable_reset"] resizeImage] forState:UIControlStateNormal];
        [_eventBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _eventBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _eventBtn.layer.cornerRadius = 15;
        _eventBtn.layer.masksToBounds = 1;
        _eventBtn.hidden = YES;
    }
    return _eventBtn;
}



- (UILabel *)tipLb {
    if (!_tipLb) {
        _tipLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.emptyImageV.bottom+10, ScreenW, 20)];
        _tipLb.textColor = [UIColor colorWithHexString:@"999999"];
        _tipLb.font = [UIFont systemFontOfSize:12];
        _tipLb.textAlignment = NSTextAlignmentCenter;
        _tipLb.text = @"购物车是空嗒~快去买买买";                    
    }
    return _tipLb;
}
- (UIImageView *)emptyImageV {
    if (!_emptyImageV) {
        _emptyImageV = [[UIImageView alloc] initWithFrame: CGRectMake((ScreenW - 50)*0.5, 210, 50, 40)];
        _emptyImageV.image = [UIImage imageNamed:@"car_empty"];
    }
    return _emptyImageV;
    
}
@end
