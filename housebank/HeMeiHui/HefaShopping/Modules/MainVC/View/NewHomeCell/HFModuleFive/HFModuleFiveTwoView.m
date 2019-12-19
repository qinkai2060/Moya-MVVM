//
//  HFModuleFiveTwoView.m
//  
//
//  Created by usermac on 2019/3/27.
//

#import "HFModuleFiveTwoView.h"

@implementation HFModuleFiveTwoView

- (void)hh_setupViews {
    [self addSubview:self.titleLb];
    [self addSubview:self.miaoshLb];
    [self addSubview:self.imageView];
}

- (void)doMessageRendering {

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.fiveModel.imgUrlL,IMGWH(CGSizeMake(75, 80))]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.fiveModel.title;
    self.miaoshLb.text = self.fiveModel.littleTitle;
    self.titleLb.frame = CGRectMake(0, 18, self.width, 15);
    self.miaoshLb.frame = CGRectMake(0, self.titleLb.bottom,self.width, 15);
    self.imageView.frame = CGRectMake((self.width-75)*0.5,self.miaoshLb.bottom+10, 75, 80);
    
}
- (void)tapOne :(UITapGestureRecognizer*)tap {
    
    self.fiveModel.tag = tap.view.tag;
    if (self.didModuleFiveTwoBlock) {
        self.didModuleFiveTwoBlock(self.fiveModel);
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
        _imageView.tag = 1003;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}
@end

