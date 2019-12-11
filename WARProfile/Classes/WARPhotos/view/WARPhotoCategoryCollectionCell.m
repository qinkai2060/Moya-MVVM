//
//  WARPhotoCategoryCollectionCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import "WARPhotoCategoryCollectionCell.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
@implementation WARPhotoCategoryCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self setLayout];
    }
    return self;
}
- (void)initUI {
    [self.contentView addSubview:self.photoImgV];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.timeDurationlb];
    [self.contentView addSubview:self.videoimage];

}
- (void)setLayout {
    [self.photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    [self.videoimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView);
    }];
    [self.timeDurationlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoimage.mas_right);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@20);
    }];
}

- (void)setVideoModel:(WARPictureModel *)videoModel {
    _videoModel = videoModel;
    self.timeDurationlb.text = videoModel.timelength;
    self.maskView.hidden = NO;
    
    if ([videoModel.type isEqualToString:@"VIDEO"]) {
        [self.photoImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake((kScreenWidth-25)/4 ,(kScreenWidth-25)/4),videoModel.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4))];
    }else{
        [self.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4),videoModel.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4))];
    }
}
- (void)setAlbumModel:(WARPictureModel *)albumModel {
    _albumModel = albumModel;
    self.maskView.hidden = YES;
    if ([albumModel.type isEqualToString:@"VIDEO"]) {
        [self.photoImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake((kScreenWidth-25)/4 ,(kScreenWidth-25)/4),albumModel.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4))];
    }else{
        [self.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4),albumModel.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4))];
    }
}

- (UIImageView *)videoimage {
    if (!_videoimage) {
        _videoimage = [[UIImageView alloc] init];
        _videoimage.image = [UIImage war_imageName:@"" curClass:[self class] curBundle:@""];
    }
    return _videoimage;
}
- (UIImageView *)maskView {
    if (!_maskView) {
        _maskView = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"personal_video_shadow" curClass:[self class] curBundle:@"WARProfile.bundle"]];
//        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
     
    }
    return _maskView;
}
- (UILabel *)timeDurationlb{
    if (!_timeDurationlb) {
        _timeDurationlb = [[UILabel alloc] init];
        _timeDurationlb.font = [UIFont boldSystemFontOfSize:11];
        _timeDurationlb.textColor = [UIColor whiteColor];
        _timeDurationlb.textAlignment = NSTextAlignmentRight;
        //        _timeDurationlb.text = WARLocalizedString(@"02:30");
    }
    return _timeDurationlb;
}
- (UIImageView *)photoImgV {
    if (!_photoImgV) {
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgV.clipsToBounds = YES;
        _photoImgV.image = DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-25)/4 , (kScreenWidth-25)/4));

    }
    return _photoImgV;
}
@end
