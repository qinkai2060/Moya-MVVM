//
//  DetailedRulesGroupBuyingCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/1.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "DetailedRulesGroupBuyingCell.h"

@implementation DetailedRulesGroupBuyingCell
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
    self.backgroundColor = [UIColor whiteColor];
    NSString *text = @"购买成团";
    //    标题
    _featureTitleLabel = [UILabel lableFrame:CGRectZero title:text backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold] textColor:HEXCOLOR(0x333333)];
    [self addSubview:_featureTitleLabel];
    //    详细规则
    _detailRulesLabel = [UILabel lableFrame:CGRectZero title:@"详细规则" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular] textColor:HEXCOLOR(0x666666)];
    [self addSubview:_detailRulesLabel];
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
        [make.top.mas_equalTo(self)setOffset:DCMargin];
    }];
    [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self);
    }];
    [_detailRulesLabel mas_makeConstraints:^(MASConstraintMaker *make){
        [make.right.mas_equalTo(_indicateButton.mas_left)setOffset:-5];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
    }];
   
    //    [_spaceLabe mas_makeConstraints:^(MASConstraintMaker *make) {
    //        [make.left.mas_equalTo(self)setOffset:0];
    //        [make.right.mas_equalTo(self)setOffset:0];
    //        make.height.mas_equalTo(1);
    //        [make.bottom.mas_equalTo(self.mas_bottom)setOffset:0];
    //    }];
    
}
- (void)reSetSelectedData:(NSString *)context
{
    // * 拼团类型，1：按拉新成团，2：按购买成团
    
    if ([context isEqualToString:@"2"]) {
        _featureTitleLabel.text = @"购买成团";
    }else
    {
         _featureTitleLabel.text = @"新人参团";
    }
}
@end
