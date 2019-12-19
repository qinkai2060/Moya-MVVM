//
//  CloudAlertView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudAlertView.h"
@interface CloudAlertView ()
@property (nonatomic, strong) UILabel * reasonLabel;
@end

@implementation CloudAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.7f];
        
        UIView * backGroundView = [UIView new];
        backGroundView.backgroundColor = [UIColor whiteColor];
        backGroundView.layer.masksToBounds = YES;
        backGroundView.layer.cornerRadius = 6;
        [self addSubview:backGroundView];
        [backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(48);
            make.right.equalTo(self).offset(-48);
            make.height.equalTo(@220);
        }];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = @"拒绝原因";
        titleLabel.font = kFONT_BOLD(16);
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [backGroundView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backGroundView).offset(25);
            make.centerX.equalTo(backGroundView);
            make.height.equalTo(@20);
        }];

        self.reasonLabel = [UILabel new];
        self.reasonLabel.text = @"语雀是一款优雅高效的在线文档编辑与协同工具， 让每个企业轻松拥有文档中心阿里巴巴集团内部使用多年，众多中小企业首选。";
        self.reasonLabel.font = kFONT(14);
        self.reasonLabel.numberOfLines = 0;
        self.reasonLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.reasonLabel.textAlignment = NSTextAlignmentLeft;
        [backGroundView addSubview:self.reasonLabel];
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backGroundView).offset(25);
            make.right.equalTo(backGroundView).offset(-25);
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
            make.height.equalTo(@80);
        }];

        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [backGroundView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backGroundView).offset(-46);
            make.width.equalTo(backGroundView);
            make.height.equalTo(@1);
            make.left.equalTo(backGroundView);
        }];

        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#333333"]
                        forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = kFONT(16);
        [backGroundView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(backGroundView);
            make.width.equalTo(backGroundView.mas_width).multipliedBy(0.5);
            make.top.equalTo(line.mas_bottom);
        }];

        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setTitle:@"立即修改" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
        sureBtn.titleLabel.font = kFONT(16);
        [backGroundView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(backGroundView);
            make.width.equalTo(backGroundView.mas_width).multipliedBy(0.5);
            make.top.equalTo(line.mas_bottom);
        }];

        @weakify(self);
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
             @strongify(self);
            [self closeAnimation];
        }];

        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
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

- (void)showAlertString:(NSString *)alertString  changeBlock:(changeBlock)changeBlock {

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


@end
