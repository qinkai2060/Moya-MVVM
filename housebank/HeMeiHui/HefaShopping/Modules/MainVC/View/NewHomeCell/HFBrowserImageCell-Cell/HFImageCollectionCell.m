//
//  HFImageCollectionCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFImageCollectionCell.h"

@implementation HFImageCollectionCell
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
//
//    [[SDWebImageDownloader    sharedDownloader] downloadImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[self.model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],IMGWH(CGSizeMake(ScreenW, 235))]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        
//        NSLog(@"🤙🤙------------------%@-图片%@",error.description,[self.model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//    }];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[self.model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],IMGWH(CGSizeMake(ScreenW*2, 235*2))]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.imageView.frame = CGRectMake(0, 0, ScreenW, self.height);
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.clipsToBounds = YES;
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
