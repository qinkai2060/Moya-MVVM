//
//  HMHLiveVideoHomeSearchView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeSearchView.h"

@implementation HMHLiveVideoHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    UIImageView *searchImage = [UIImageView new];
    [self addSubview:searchImage];
    [searchImage setImage:ImageLive(@"搜索-icon")];
    searchImage.backgroundColor = [UIColor clearColor];
    searchImage.userInteractionEnabled = YES;
    searchImage.contentMode = UIViewContentModeCenter;
    
    
    UILabel *defaultLabel = [UILabel wd_labelWithText:@"" font:15 textColorStr:@"#999999"];
    [self addSubview:defaultLabel];
    defaultLabel.text = @"请输入搜索内容";
    defaultLabel.textAlignment = NSTextAlignmentLeft;
    
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(WScale(20));
        make.leading.mas_equalTo(self.mas_leading).mas_offset(WScale(10));
    }];
    
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(searchImage.mas_trailing).mas_offset(WScale(6));
    }];
}

@end
