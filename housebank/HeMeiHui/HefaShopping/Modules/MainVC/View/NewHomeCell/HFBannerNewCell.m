//
//  HFBannerNewCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFBannerNewCell.h"


@implementation HFBannerNewCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeAdType];
}
- (void)hh_setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.adImageView];
//    [self.contentView addSubview:self.btn];
}
- (void)doMessageRendering {
    self.admodel = (HFAdModel*)self.model;
    self.topView.frame = CGRectMake(0, 0, ScreenW, 10);
    HFAdModel *model   =  [self.admodel.dataArray firstObject];
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.adImageView.frame = CGRectMake(0, self.topView.bottom+10, ScreenW, self.admodel.rowheight-20-10);
   // self.btn.frame =  self.adImageView.frame;

    
}
//- (UIButton*)btn {
//    if (!_btn) {
//        UIButton *btn = [[UIButton alloc] init];
//        [btn addTarget:self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _btn;
//}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _topView;
}
- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _adImageView.userInteractionEnabled = YES;
        
    }
    return _adImageView;
}
@end
