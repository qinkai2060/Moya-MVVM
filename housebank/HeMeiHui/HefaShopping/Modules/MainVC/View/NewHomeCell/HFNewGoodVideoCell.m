//
//  HFNewGoodVideoCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNewGoodVideoCell.h"
#import "HFGoodsVideoModel.h"
@implementation HFNewGoodVideoCell
+ (void)load {
    [super registerRenderCell:[self class] messageType:HHFHomeBaseModelTypeGoodsVideo];
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.videoImageV];
    [self.videoImageV addSubview:self.playBtn];
    [self.contentView.layer addSublayer:self.lineLayer];
}
- (void)doMessageRendering {
    self.admodel = [self.model.dataArray firstObject];
    [self.videoImageV sd_setImageWithURL:[NSURL URLWithString:self.admodel.img] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.videoImageV.frame = CGRectMake(15, 5, ScreenW-30, 268.5);
    self.playBtn.frame = CGRectMake((self.videoImageV.width-50)*0.5, (268.5-50)*0.5, 50, 50);
//    self.playBtn.center = self.videoImageV.center;
    self.lineLayer.frame = CGRectMake(0, self.videoImageV.bottom+15, ScreenW, 10);
}
- (UIImageView *)videoImageV {
    if (!_videoImageV) {
        _videoImageV = [[UIImageView alloc] init];
        
    }
    return _videoImageV;
}
- (UIImageView *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIImageView alloc] init];
        _playBtn.image = [UIImage imageNamed:@"Vip_play_icon"];
    }
    return _playBtn;
}
- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    }
    return _lineLayer;
}
@end
