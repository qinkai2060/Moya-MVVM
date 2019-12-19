//
//  CloudVipAlertView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/8/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudVipAlertView.h"
@interface CloudVipAlertView ()
@property (nonatomic, strong) UILabel * reasonLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView * backGroundView;
@end

@implementation CloudVipAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.7f];
        
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(48);
            make.right.equalTo(self).offset(-48);
            make.height.equalTo(@136);
        }];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = @"拒绝原因";
        titleLabel.font = kFONT_BOLD(16);
        titleLabel.hidden = YES;
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backGroundView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backGroundView).offset(25);
            make.centerX.equalTo(self.backGroundView);
            make.height.equalTo(@20);
        }];
        
        self.reasonLabel = [UILabel new];
        self.reasonLabel.text = @"语雀是一款优雅高效的在线文档编辑与协同工具， 让每个企业轻松拥有文档中心阿里巴巴集团内部使用多年，众多中小企业首选。";
        self.reasonLabel.font = kFONT(14);
        self.reasonLabel.numberOfLines = 0;
        self.reasonLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.reasonLabel.textAlignment = NSTextAlignmentCenter;
        [self.backGroundView addSubview:self.reasonLabel];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backGroundView).offset(25);
            make.right.equalTo(self.backGroundView).offset(-25);
            make.top.equalTo(self.backGroundView).offset(25);
            make.height.equalTo(@40);
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [self.backGroundView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backGroundView).offset(-46);
            make.width.equalTo(self.backGroundView);
            make.height.equalTo(@1);
            make.left.equalTo(self.backGroundView);
        }];
        
        [self.backGroundView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.backGroundView);
            make.width.equalTo(self.backGroundView.mas_width).multipliedBy(0.5);
            make.top.equalTo(line.mas_bottom);
        }];
        
        [self.backGroundView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.backGroundView);
            make.right.equalTo(self.backGroundView);
            make.top.equalTo(line.mas_bottom);
        }];
        
        @weakify(self);
        [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self closeAnimation];
        }];

        
        [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.changeBlock) {
                self.changeBlock();
            }
        }];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self closeAnimation];
}

- (void)showAlertString:(NSString *)alertString isSure:(BOOL)isSure changeBlock:(changeBlock)changeBlock {
    
    // 如果是YES  那么加确定和取消按钮
    if (isSure == YES) {
        self.cancelBtn.hidden = NO;
        self.cancelBtn.enabled = YES;
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.backGroundView);
            make.width.equalTo(self.backGroundView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@46);
            
        }];
        [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.backGroundView);
            make.width.equalTo(self.backGroundView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@46);
        }];
        
    }else {
        self.cancelBtn.hidden = YES;
        self.cancelBtn.enabled = NO;
    }
    
    self.changeBlock = changeBlock;
    if (alertString) {
        self.reasonLabel.text = alertString;
    }
    [self popAnimation];
}

- (void)popAnimation {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)closeAnimation {
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)resetContext_styleWithSure:(NSString *)sure cancel:(NSString *)cancel{
    if (sure) {
        [self.sureBtn setTitle:sure forState:UIControlStateNormal];
    }
    if (cancel) {
        [self.cancelBtn setTitle:cancel forState:UIControlStateNormal];
    }

}
#pragma mark -- lazy load
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"]
                        forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFONT(16);
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
        _sureBtn.titleLabel.font = kFONT(16);
    }
    return _sureBtn;
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [UIView new];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        _backGroundView.layer.masksToBounds = YES;
        _backGroundView.layer.cornerRadius = 6;
    }
    return _backGroundView;
}
@end
