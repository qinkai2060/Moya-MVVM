//
//  CustomNaviOrderTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomNaviOrderTableViewCell.h"

@implementation CustomNaviOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textColor = HEXCOLOR(0x333333);
        self.label.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = RGB(175, 176, 179);
        [self addSubview:self.line];
        
        self.imgSelect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_orderSelect"]];
        [self addSubview:self.imgSelect];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.imgSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
    }];
}

@end
