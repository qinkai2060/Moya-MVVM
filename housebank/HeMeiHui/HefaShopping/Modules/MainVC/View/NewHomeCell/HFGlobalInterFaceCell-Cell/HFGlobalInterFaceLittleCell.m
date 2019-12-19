//
//  HFGlobalInterFaceLittleCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFGlobalInterFaceLittleCell.h"

@implementation HFGlobalInterFaceLittleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupSubViews];
    }
    return self;
}
- (void)hh_setupSubViews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLb];
}
- (void)doMessageRendering {
  
    self.titleLb.text = self.model.title;
    self.imageView.frame = CGRectMake((self.width-40)*0.5, 10, 40, 40);
    self.titleLb.frame = CGRectMake(0, self.imageView.bottom+5, self.width, 15);

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.titleImageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:12];
        _titleLb.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}

@end
