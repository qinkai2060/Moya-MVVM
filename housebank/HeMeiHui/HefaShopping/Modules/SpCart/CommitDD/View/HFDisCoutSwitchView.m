//
//  HFDisCoutSwitchView.m
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFDisCoutSwitchView.h"
@interface HFDisCoutSwitchView ()
@property (nonatomic,strong) UISwitch *switchView;
@property (nonatomic,strong) UILabel *disCoutValueLb;
@end
@implementation HFDisCoutSwitchView
- (void)hh_setupViews {
    [self addSubview:self.switchView];
    [self addSubview:self.disCoutValueLb];
}
- (void)hh_bindViewModel {
    self.disCoutValueLb.text = @"合发优惠 折扣券省1元";
    
}
- (void)clickOnOrOff:(UISwitch*)switchView {
    NSLog(@"😁😁%ld",switchView.isOn);
}
- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenW - 52-14, 7, 52, 34)];
        [_switchView addTarget:self action:@selector(clickOnOrOff:) forControlEvents:UIControlEventValueChanged];
    }
  return  _switchView;
}
- (UILabel *)disCoutValueLb {
    if (!_disCoutValueLb) {
        _disCoutValueLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 16, ScreenW-15-52-14, 15)];
        _disCoutValueLb.font = [UIFont systemFontOfSize:15];
        _disCoutValueLb.textColor = [UIColor blackColor];
        
    }
    return _disCoutValueLb;
}
@end
