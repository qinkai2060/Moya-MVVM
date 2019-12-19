//
//  SpParameterCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/14.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpParameterCell.h"

@implementation SpParameterCell
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
        NSString *text = @"参数";
        NSString *text2 = @"上市年份季节 材质成分";
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
        
    }
@end
