//
//  PersonCenterSettingTableViewCell.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "PersonCenterSettingTableViewCell.h"

@implementation PersonCenterSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"主标题";
        _titleL.font = PFR16Font;
        _titleL.textColor = HEXCOLOR(0x333333);
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UIImageView *)imgLogo{
    if (!_imgLogo) {
        _imgLogo = [[UIImageView alloc] init];
    }
    return _imgLogo;
}
- (UIImageView *)imgNext{
    if (!_imgNext) {
        _imgNext = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right>"]];
    }
    return _imgNext;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xE5E5E5);
    }
    return _line;
}
- (void)creatcellView
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgLogo];
    [self addSubview:self.titleL];
    [self addSubview:self.imgNext];
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.imgLogo.mas_right).offset(10);
    }];
    
    [self.imgNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.8);
    }];
}


@end
