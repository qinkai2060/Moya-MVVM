//
//  SpFeatureItemCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpFeatureItemCell.h"

@implementation SpFeatureItemCell
#pragma mark - Intial
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
    NSString *text = @"规格";
    NSString *text2 = @"选择 属性名称";
    //    标题
    _featureTitleLabel = [UILabel lableFrame:CGRectZero title:text backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] textColor:HEXCOLOR(0x999999)];
    [self addSubview:_featureTitleLabel];
    //    名称
    _featureLabel = [UILabel lableFrame:CGRectZero title:text2 backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] textColor:HEXCOLOR(0x333333)];
    [self addSubview:_featureLabel];
    //    箭头
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indicateButton setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
    [self addSubview:_indicateButton];
////    分割线
//    _spaceLabe = [UILabel lableFrame:CGRectZero title:@"" backgroundColor:HEXCOLOR(0xF5F5F5) font:[UIFont systemFontOfSize:14] textColor:HEXCOLOR(0x333333)];
//    [self addSubview:_spaceLabe];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
   
    [_featureTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
    }];
    [_featureLabel mas_makeConstraints:^(MASConstraintMaker *make){
        [make.left.mas_equalTo(_featureTitleLabel.mas_right)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
    }];
    [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self);
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
    if (context.length>0) {
        _featureLabel.text=context;
    }else
    {
        _featureLabel.text= @"选择 属性名称";
    }
    
}
@end
