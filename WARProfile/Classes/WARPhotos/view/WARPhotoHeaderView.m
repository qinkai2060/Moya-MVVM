//
//  WARPhotoHeaderView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/20.
//

#import "WARPhotoHeaderView.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARUIHelper.h"
#import "WARBaseMacros.h"
#import "UIImageView+WebCache.h"
#import "WARGroupModel.h"
#define  HeaderScreenW   [UIScreen mainScreen].bounds.size.width
@implementation WARPhotoHeaderView

- (instancetype)initWithType:(WARPhotoHeaderViewType)type{
    if (self = [super init]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        [self setUI];
        [self setWARPhotoHeaderViewType:type];
        
    }
    return self;
}
- (void)setWARPhotoHeaderViewType:(WARPhotoHeaderViewType*)type{

    if (type == WARPhotoHeaderViewTypeDefualt) {
     
      //  self.maskV.image = [UIImage war_imageName:@"personalinformation_qh" curClass:self curBundle:@"WARProfile.bundle"];
        self.titlelb.hidden = YES;
        self.lockImgV.hidden = YES;
        self.countlb.hidden = YES;
        self.phototypelb.hidden = YES;
        self.maskV.hidden = YES;
    }else{
        self.titlelb.hidden = NO;
        self.lockImgV.hidden = NO;
        self.countlb.hidden = NO;
        self.phototypelb.hidden = NO;
        self.maskV.hidden = NO;
        self.titlelb.text = WARLocalizedString(@"说走就走的旅行");
        self.phototypelb.text = WARLocalizedString(@"旅行");
        
    }
}
- (void)setGroupModel:(WARGroupModel *)model{
    
    self.titlelb.text = WARLocalizedString(model.name);
    self.phototypelb.text = WARLocalizedString(model.type);
      self.countlb.text = model.pictureCount;
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(kScreenWidth , 178),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth , 178))];;
    }else{
        [self sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth , 178),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth , 178))];;
    }

}

- (void)setCoveriD:(NSString *)coverID{
        [self sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, 178),coverID) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(kScreenWidth , 178))];
}
- (void)setUI{
//    [self addSubview:self.bgView];
    [self addSubview:self.maskV];
    [self addSubview:self.titlelb];
    [self addSubview:self.lockImgV];
    [self addSubview:self.countlb];
    [self addSubview:self.phototypelb];

//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    [self.maskV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lockImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@10);
        make.height.equalTo(@13);
    }];
    [self.countlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lockImgV.mas_right).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(@13);
        make.width.equalTo(@60);
    }];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.bottom.equalTo(self.countlb.mas_top).offset(-12);
        make.width.equalTo(@(HeaderScreenW-20));
        make.height.equalTo(@20);
    }];
    [self.phototypelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@22);
        make.width.equalTo(@55);
    }];

}
//- (UIImageView *)bgView{
//    if (!_bgView) {
//        _bgView = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"" curClass:self curBundle:@""]];
//    }
//    return _bgView;
//}
- (UIImageView *)maskV{
    if (!_maskV) {
        _maskV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"" curClass:self curBundle:@""]];
           _maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _maskV;
}
-(UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.textColor = [UIColor whiteColor];
        _titlelb.font =[UIFont boldSystemFontOfSize:21];
    }
    return _titlelb;
}
- (UIImageView *)lockImgV{
    if (!_lockImgV) {
        _lockImgV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"xiangce_suo" curClass:self curBundle:@"WARProfile.bundle"]];
    }
    return _lockImgV;
}
- (UILabel *)countlb{
    if (!_countlb) {
        _countlb = [[UILabel alloc] init];
        _countlb.textColor = [UIColor whiteColor];
        _countlb.font =kFont(15);
    }
    return _countlb;
}
- (UILabel *)phototypelb{
    if (!_phototypelb) {
        _phototypelb = [[UILabel alloc] init];
        _phototypelb.textColor = [UIColor whiteColor];
        _phototypelb.font =kFont(14);
        _phototypelb.backgroundColor = [UIColor colorWithHexString:@"9BB7F0"];
        _phototypelb.textAlignment = NSTextAlignmentCenter;
        _phototypelb.layer.cornerRadius = 3;
        _phototypelb.layer.masksToBounds = YES;
    }
    return _phototypelb;
}
@end
