//
//  HFFashionSmallCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFashionSmallCell.h"

@implementation HFFashionSmallCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupSubviews];
    }
    return self;
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.miaoshLb];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.rightView];
    [self.contentView addSubview:self.topView];
}
- (void)doMessageRendering {

    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.fashionModel.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text =  self.fashionModel.title;
    self.miaoshLb.text = self.fashionModel.littleTitle;
//    self.imageView.image = [UIImage imageNamed:fashinModel.model.imgUrl];
    //    CGSize titleSize = [self.titleLb sizeThatFits:CGSizeMake(60, 15)];
    //    CGSize miaoshSize = [self.titleLb sizeThatFits:CGSizeMake(60, 15)];
    //    CGSize tagSize = [self.titleLb sizeThatFits:CGSizeMake(60, 15)];
    self.titleLb.frame = CGRectMake(0, 15, self.contentView.width, 15);
    self.miaoshLb.frame = CGRectMake(0, self.titleLb.bottom+5,self.contentView.width, 15);
    self.imageView.frame = CGRectMake(10,self.miaoshLb.bottom+15, self.contentView.width-20, self.contentView.height-15-self.miaoshLb.bottom-15);
    self.rightView.frame = CGRectMake(self.width-0.5, 0, 0.5, self.height);
    self.bottomView.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    self.topView.frame = CGRectMake(0, 0, self.width, 0.5);
    
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = [UIColor colorWithHexString:@"494949"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)miaoshLb {
    if (!_miaoshLb) {
        _miaoshLb = [[UILabel alloc] init];
        _miaoshLb.textColor = [UIColor colorWithHexString:@"#8146EC"];
        _miaoshLb.font = [UIFont systemFontOfSize:12];
        _miaoshLb.textAlignment = NSTextAlignmentCenter;
    }
    return _miaoshLb;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
    }
    return _bottomView;
}
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
    }
    return _rightView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"];
    }
    return _topView;
}
@end
