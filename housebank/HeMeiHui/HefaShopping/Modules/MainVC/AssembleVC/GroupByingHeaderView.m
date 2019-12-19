//
//  GroupByingHeaderView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/1.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "GroupByingHeaderView.h"

@implementation GroupByingHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor =HEXCOLOR(0xFFEBE2);

    NSString *text = @"快速参团（点击可快速成团）";
  
    //    标题
    _featureTitleLabel = [UILabel lableFrame:CGRectZero title:text backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold] textColor:HEXCOLOR(0x333333)];
    [self addSubview:_featureTitleLabel];
   
    //    箭头
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indicateButton setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
    [self addSubview:_indicateButton];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [_featureTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin-5];
    }];
    [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self);
    }];
   

}

@end
