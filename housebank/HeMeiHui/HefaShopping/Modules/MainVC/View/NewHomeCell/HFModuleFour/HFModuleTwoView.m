//
//  HFModuleTwoView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleTwoView.h"

@implementation HFModuleTwoView

- (void)hh_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.miaoshLb];
    [self addSubview:self.imageView];
}
- (void)doMessageRendering {
    if (self.fourModuleModel) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.fourModuleModel.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        self.titleLb.text =self.fourModuleModel.title;
        self.miaoshLb.text = self.fourModuleModel.littleTitle;
    } else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.fourLiveModuleModel.img] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        self.titleLb.text =self.fourLiveModuleModel.mainTitle;
        self.miaoshLb.text = self.fourLiveModuleModel.subtitle;
    }
    
    self.titleLb.frame = CGRectMake(0, 10, self.width, 15);
    self.miaoshLb.frame = CGRectMake(0, self.titleLb.bottom,self.width, 15);
    self.imageView.frame = CGRectMake(15,self.miaoshLb.bottom, self.width-30, 70);
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height);
    
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:14];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)miaoshLb {
    if (!_miaoshLb) {
        _miaoshLb = [[UILabel alloc] init];
        _miaoshLb.textColor = [UIColor colorWithHexString:@"999999"];
        _miaoshLb.font = [UIFont boldSystemFontOfSize:10];
        _miaoshLb.textAlignment = NSTextAlignmentCenter;
    }
    return _miaoshLb;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _bgView.layer.cornerRadius = 2;
        _bgView.layer.masksToBounds = 1;
    }
    return _bgView;
}
@end
