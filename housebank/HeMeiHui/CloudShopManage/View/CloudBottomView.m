//
//  CloudBottomView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/9/4.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudBottomView.h"

@implementation CloudBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(12);
            make.right.equalTo(self.sureBtn.mas_left).offset(-10);
            make.width.equalTo(self.sureBtn);
            make.height.equalTo(@40);
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(12);
            make.width.equalTo(self.cancelBtn);
            make.height.equalTo(@40);
        }];
    }
    return self;
}

#pragma mark -- lazy load
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.titleLabel.font = kFONT(16);
        _cancelBtn.layer.cornerRadius = 20;
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.borderColor = [UIColor colorWithHexString:@"#FF0000"].CGColor;
        _sureBtn.layer.borderWidth = 1;
        _sureBtn.titleLabel.font = kFONT(16);
        _sureBtn.layer.cornerRadius = 20;
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
    }
    return _sureBtn;
}
@end
