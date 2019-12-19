//
//  HFImageViewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFImageViewCell.h"

@implementation HFImageViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (void)domessageSomeThing {
    [self.imageView  sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.imageView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
