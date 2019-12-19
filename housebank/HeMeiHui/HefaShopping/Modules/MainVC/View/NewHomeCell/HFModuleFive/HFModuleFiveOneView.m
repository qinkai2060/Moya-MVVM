//
//  HFModuleFiveOneView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFModuleFiveOneView.h"

@implementation HFModuleFiveOneView

- (void)hh_setupViews {
    [self addSubview:self.titleLb];
    [self addSubview:self.miaoshLb];
    [self addSubview:self.imageView];
    [self addSubview:self.imageViewTwo];
}

- (void)doMessageRendering {
//    HFModuleFiveViewModel *viewmodel = (HFModuleFiveViewModel*)self.viewmodel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.fiveModel.imgUrlL] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:self.fiveModel.imgUrlR] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.fiveModel.title;
    self.miaoshLb.text = self.fiveModel.littleTitle;
//    self.imageView.image = [UIImage imageNamed:viewmodel.model.imgUrlL];
//    self.imageViewTwo.image =  [UIImage imageNamed:viewmodel.model.imgUrlR];
    self.titleLb.frame = CGRectMake(15, 15, self.width-30, 15);
    self.miaoshLb.frame = CGRectMake(15, self.titleLb.bottom+5,self.width-30, 15);
    self.imageView.frame = CGRectMake(15,self.miaoshLb.bottom+13, (self.width-30-5)*0.5, (self.width-30-5)*0.5);
    self.imageViewTwo.frame = CGRectMake( self.imageView.right+5,self.miaoshLb.bottom+13, (self.width-30-5)*0.5, (self.width-30-5)*0.5);
    
}
- (void)tapOne :(UITapGestureRecognizer*)tap {
    
    self.fiveModel.tag = tap.view.tag;
    if (self.didModuleFiveBlock) {
        self.didModuleFiveBlock(self.fiveModel);
    }
    
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont boldSystemFontOfSize:16];
        _titleLb.textColor = [UIColor colorWithHexString:@"202020"];
        //        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)miaoshLb {
    if (!_miaoshLb) {
        _miaoshLb = [[UILabel alloc] init];
        _miaoshLb.textColor = [UIColor colorWithHexString:@"666666"];
        _miaoshLb.font = [UIFont boldSystemFontOfSize:12];
        //        _miaoshLb.textAlignment = NSTextAlignmentCenter;
    }
    return _miaoshLb;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.tag = 1000;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}
- (UIImageView *)imageViewTwo {
    if (!_imageViewTwo) {
        _imageViewTwo = [[UIImageView alloc] init];
        _imageViewTwo.tag = 1001;
         _imageViewTwo.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_imageViewTwo addGestureRecognizer:tapGesture];
    }
    return _imageViewTwo;
}
@end
