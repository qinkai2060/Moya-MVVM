//
//  PropertyHeader.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "PropertyHeader.h"

@implementation PropertyHeader
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.headernameL = [[UILabel alloc] init];
    self.headernameL.font = PFR13Font;
    self.headernameL.textColor=HEXCOLOR(0x333333);
    self.headernameL.text=@"商品评价（11）";
    [self addSubview:self.headernameL];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.headernameL mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:15];
        [make.top.mas_equalTo(self)setOffset:15];
    }];
}
@end
