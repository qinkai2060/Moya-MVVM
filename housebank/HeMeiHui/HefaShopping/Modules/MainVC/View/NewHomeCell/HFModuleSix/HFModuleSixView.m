//
//  HFModuleSixView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleSixView.h"

@implementation HFModuleSixView

- (void)hh_setupViews {
    
    [self addSubview:self.imageView];
    [self addSubview:self.bgview];
    [self addSubview:self.titleLb];
}
- (void)doMessageRendering {
//    HFModuleSixViewModel *viewmodel = (HFModuleSixViewModel*)self.viewmodel;
//    self.imageView.image = [UIImage imageNamed:viewmodel.model.imgUrl];
       [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.sixModel.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.sixModel.title;
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
    self.bgview.frame = CGRectMake(10, self.height-10-40, self.width-20, 40);
    self.titleLb.frame = CGRectMake(20, self.height-10-40, self.bgview.width-20, 40);
    
}
- (UIView *)bgview {
    if (!_bgview) {
        _bgview = [[UIView alloc] init];
        _bgview.backgroundColor = [UIColor whiteColor];
    }
    return _bgview;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor colorWithHexString:@"202020"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}
@end
