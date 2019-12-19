//
//  MyDeleteUserImageCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteUserImageCell.h"

@implementation MyDeleteUserImageCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:1];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.iconimageView];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.subTitleLb];
    [self.contentView addSubview:self.lineView];
}
- (void)doMessageRendering {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iconimageView.image = [UIImage imageNamed:self.model.imageStr];
    self.titleLb.text = self.model.title;
    self.subTitleLb.text = self.model.subtitle;
    self.iconimageView.frame = CGRectMake((ScreenW-50)*0.5, 35, 50, 50);
    self.titleLb.frame = CGRectMake(0, self.iconimageView.bottom+25, ScreenW, 24);
    self.subTitleLb.frame = CGRectMake(0, self.titleLb.bottom+5, ScreenW, 24);
    self.lineView.frame = CGRectMake(0, self.model.rowHeight-10, ScreenW, 10);
}
- (UIImageView *)iconimageView {
    if (!_iconimageView) {
        _iconimageView = [[UIImageView alloc] init];
    }
    return _iconimageView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.font = [UIFont boldSystemFontOfSize:17];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)subTitleLb {
    if (!_subTitleLb) {
        _subTitleLb = [[UILabel alloc] init];
        _subTitleLb.textColor = [UIColor blackColor];
        _subTitleLb.font = [UIFont systemFontOfSize:17];
        _subTitleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLb;
}
- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView;
}
@end
