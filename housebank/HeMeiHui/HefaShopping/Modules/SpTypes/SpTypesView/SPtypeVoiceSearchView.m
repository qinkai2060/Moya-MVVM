//
//  SPtypeVoiceSearchView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/8/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SPtypeVoiceSearchView.h"

@implementation SPtypeVoiceSearchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView * bgView = [UIView new];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
            make.right.equalTo(self).offset(-15);
        }];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 15;
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VH_videoSearch"]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(10);
            make.width.height.equalTo(@15);
        }];
        
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchBtn setTitle:@"请输入搜索内容" forState:UIControlStateNormal];
        self.searchBtn.titleLabel.font = kFONT(14);
        self.searchBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.searchBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [bgView addSubview:self.searchBtn];
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView);
            make.height.equalTo(@30);
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-1);
            make.left.right.equalTo(self);
            make.height.equalTo(@0.8);
        }];
    }
    return self;
}

@end
