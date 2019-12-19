//
//  PersonInformationCancelSureView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationCancelSureView.h"

@interface PersonInformationCancelSureView()

@property (nonatomic,strong)UIButton *sureBtn;

@property (nonatomic,strong)UIButton *cancelBtn;

@end

@implementation PersonInformationCancelSureView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    
    self.backgroundColor = [UIColor colorWithHexString:@"F0F1F2"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:0];
    [self addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:kFONT(14)];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#96989B"] forState:UIControlStateNormal];
    cancelBtn.tag = 1;
    [cancelBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [UIButton buttonWithType:0];
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:kFONT(14)];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#E16B67"] forState:UIControlStateNormal];
    sureBtn.tag = 2;
    [sureBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
     
     [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.mas_equalTo(self);
        make.width.mas_equalTo(WScale(60));
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.top.mas_equalTo(self);
        make.width.mas_equalTo(WScale(60));
    }];
    
}

- (void)actionBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            if (self.cancelBlock) {
                self.cancelBlock();
            }
               
            break;
        }
        case 2:
        {
            if (self.sureBlock) {
                self.sureBlock();
            }
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
    [self.cancelBtn setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = rightTitle;
    [self.sureBtn setTitle:rightTitle forState:UIControlStateNormal];
}

@end
