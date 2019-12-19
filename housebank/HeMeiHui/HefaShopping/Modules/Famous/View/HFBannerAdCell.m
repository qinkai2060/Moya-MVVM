//
//  HFBannerAdCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBannerAdCell.h"

@implementation HFBannerAdCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupSubViews];
    }
    return self;
}
- (void)hh_setupSubViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textlb];
}
- (void)doMessageRendering {
    

    self.imageView.frame = CGRectMake(0, 0, ScreenW, self.height);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!%@",[[ManagerTools ManagerTools] appInfoModel].imageServerUrl,self.model.imageth,IMGWH(CGSizeMake(ScreenW, self.imageView.height))]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)textlb {
    if (!_textlb) {
        _textlb = [[UILabel alloc] init];
        _textlb.textColor = [UIColor blueColor];
        _textlb.font = [UIFont boldSystemFontOfSize:16];
        _textlb.textAlignment = NSTextAlignmentCenter;
    }
    return _textlb;
}
@end
