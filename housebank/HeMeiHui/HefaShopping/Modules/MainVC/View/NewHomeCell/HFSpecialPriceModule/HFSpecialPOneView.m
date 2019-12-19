//
//  HFSpecialPOneView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSpecialPOneView.h"

@implementation HFSpecialPOneView
- (void)hh_setupViews {
    [self addSubview:self.titleLb];
    [self addSubview:self.miaoshLb];
    [self addSubview:self.tagLb];
    [self addSubview:self.imageView];
//  [self.layer addSublayer:self.linelayer];
    [self.layer addSublayer:self.linelayer1];
    [self.layer addSublayer:self.linelayer2];
}
- (void)doMessageRendering {
    self.titleLb.text = self.specialModel.title;
    self.miaoshLb.text = self.specialModel.littleTitle;
    self.tagLb.text = self.specialModel.tagStr;
    CGSize titleSize = [self.titleLb sizeThatFits:CGSizeMake(ScreenW*0.5, 15)];
     CGSize miaoshSize = [self.miaoshLb sizeThatFits:CGSizeMake(0, 15)];
    CGSize tagSize = [self.tagLb sizeThatFits:CGSizeMake(60, 15)];
    self.titleLb.frame = CGRectMake(10, 15, titleSize.width, titleSize.height);
    self.miaoshLb.frame = CGRectMake(10, self.titleLb.bottom+5,140, miaoshSize.height);
    self.tagLb.frame = CGRectMake(10, self.miaoshLb.bottom+5, tagSize.width+10, 15);
    self.imageView.frame = CGRectMake(83, 70, ScreenW*0.5-83, 170-70);
    if ([self.specialModel.colorStr isEqualToString:@"false"]) {
        self.tagLb.backgroundColor = [UIColor colorWithHexString:@"FF6B00"];
    }else {
        self.tagLb.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
    }
    self.linelayer1.frame = CGRectMake(self.width-0.5, 0, 0.5, self.height);
    self.linelayer2.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.specialModel.imgUrl,IMGWH(CGSizeMake(self.imageView.width, self.imageView.height))]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:14];
        _titleLb.textColor = [UIColor colorWithHexString:@"494949"];
    }
    return _titleLb;
}
- (UILabel *)miaoshLb {
    if (!_miaoshLb) {
        _miaoshLb = [[UILabel alloc] init];
        _miaoshLb.textColor = [UIColor colorWithHexString:@"999999"];
        _miaoshLb.font = [UIFont boldSystemFontOfSize:12];
    }
    return _miaoshLb;
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.font = [UIFont systemFontOfSize:10];
        _tagLb.textColor = [UIColor whiteColor];
        _tagLb.layer.cornerRadius = 8;
        _tagLb.layer.masksToBounds = YES;
        _tagLb.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLb;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}
- (CALayer *)linelayer {
    if(!_linelayer) {
        _linelayer = [CALayer layer];
        _linelayer.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"].CGColor;
    }
    return _linelayer;
}
- (CALayer *)linelayer1 {
    if(!_linelayer1) {
        _linelayer1 = [CALayer layer];
        _linelayer1.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"].CGColor;
    }
    return _linelayer1;
}

- (CALayer *)linelayer2 {
    if(!_linelayer2) {
        _linelayer2 = [CALayer layer];
        _linelayer2.backgroundColor = [UIColor colorWithHexString:@"EBF0F6"].CGColor;
    }
    return _linelayer2;
}

@end
