//
//  WARFavriteMineCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import "WARFavriteMineCell.h"
#import "UIImage+WARBundleImage.h"
//#import "UIColor+WARCategory.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARProfileFavoriteViewController.h"
#import "WARConfigurationMacros.h"
#define CellW    ([UIScreen mainScreen].bounds.size.width - 30-13.5*2)/3
@implementation WARFavriteMineCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self setCellLayout];

    }
    return self;
}
- (void)initSubViews {
    [self.contentView addSubview:self.bgV];
    [self.contentView addSubview:self.imageV];
    
    [self.imageV addSubview:self.maskV];
    [self.imageV addSubview:self.maskV2];
    [self.imageV addSubview:self.handlerBtn];
    [self.imageV addSubview:self.lockImageV];
    [self.imageV addSubview:self.countlb];
    [self.contentView addSubview:self.titlelb];
}
- (void)setModel:(WARFavoriteInfoModel *)model {
    _model = model;
    [self.imageV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(CellW, 132),model.favoriteCover) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.countlb.text = [NSString stringWithFormat:@"%@张",model.favoriteCount];
    self.titlelb.text = WARLocalizedString(model.favoriteName);
     CGSize sizeLocal = [ self.titlelb.text boundingRectWithSize:CGSizeMake(CellW, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(12)} context:nil].size;
    [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(sizeLocal.height));
    }];
    
}
- (void)alertClick:(UIButton*)btn {
    
    WARProfileFavoriteViewController *vc = [self currentVC:self.contentView];
    [vc actionSheetClick:self.model];
}
- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}
- (void)setCellLayout {
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@152);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@146);
    }];
    [self.maskV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV);
        make.height.equalTo(@30);
        make.left.right.equalTo(self.imageV); 
    }];
    [self.handlerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.top.equalTo(self.imageV);
        make.right.equalTo(self.imageV).offset(-3);
    }];
    [self.maskV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imageV);
        make.height.equalTo(@26);
    }];
    [self.lockImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@13);
        make.height.equalTo(@14);
        make.left.equalTo(self.imageV).offset(5);
        make.bottom.equalTo(self.imageV).offset(-5);
    }];
    [self.countlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageV).offset(-5);
        make.bottom.equalTo(self.imageV).offset(-5);
        make.height.equalTo(@12);
        make.width.equalTo(@45);
    }];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@12);
    }];

}
- (UIImageView *)bgV {
    if (!_bgV) {
        _bgV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"favrite" curClass:[self class] curBundle:@"WARProfile.bundle"]];
//        _bgV.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgV;
}
- (UIImageView *)maskV2 {
    if (!_maskV2) {
        _maskV2 = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"personal_collect_shadow" curClass:[self class] curBundle:@"WARProfile.bundle"]];

    }
    return _maskV2;
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,CellW , 152)];
//        _imageV.layer.shadowColor = [UIColor blackColor].CGColor;
//        _imageV.layer.shadowOffset=CGSizeMake(0, 1);
//        _imageV.layer.shadowOpacity = 0.5f;
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_imageV.bounds];
//        _imageV.layer.shadowPath = shadowPath.CGPath;
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}
- (UIButton *)handlerBtn {
    if (!_handlerBtn) {
        _handlerBtn = [[UIButton alloc] init];
        [_handlerBtn setImage:[UIImage war_imageName:@"personal_collect_more" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_handlerBtn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handlerBtn;
}
- (UIView *)maskV {
    if (!_maskV) {
        _maskV = [[UIView alloc] init];
        _maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskV;
}
- (UIButton *)lockImageV {
    if (!_lockImageV) {
        _lockImageV = [[UIButton alloc] init];
        [_lockImageV setImage:[UIImage war_imageName:@"personal_collect_lockopen" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_lockImageV setImage:[UIImage war_imageName:@"personal_collect_lockoff" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
    }
    return _lockImageV;
}
- (UILabel *)countlb {
    if (!_countlb) {
        _countlb = [[UILabel alloc] init];
        _countlb.textColor = [UIColor whiteColor];
        _countlb.font = kFont(12);
        _countlb.textAlignment = NSTextAlignmentRight;
    }
    return _countlb;
}
- (UILabel *)titlelb {
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.font = kFont(12);
        _titlelb.textColor = ThreeLevelTextColor;
        _titlelb.text = @"Hellow Word";
        _titlelb.numberOfLines = 2;
    }
    return _titlelb;
}
@end
