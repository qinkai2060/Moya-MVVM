//
//  WARPhotoDetailCollectionCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoDetailCollectionCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARUIHelper.h"
#import "WARGroupModel.h"

@implementation WARPhotoDetailCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photoImgV];
        [self.contentView addSubview:self.selectimage];
        [self.contentView addSubview:self.maskView];
        [self.contentView addSubview:self.timeDurationlb];
        [self.photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.selectimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@40);
            make.width.equalTo(@30);
        }];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@20);
        }];
        [self.timeDurationlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@20);
        }];
    }
    return self;
}
- (void)setModel:(WARPictureModel *)model{
    _model = model;

    if ([model.type isEqualToString:@"VIDEO"]) {
        self.timeDurationlb.hidden = NO;
        self.maskView.hidden = NO;
    }else{
        self.timeDurationlb.hidden = YES;
        self.maskView.hidden = YES;
    }
     self.timeDurationlb.text = model.timelength;
   

    if ([model.type isEqualToString:@"VIDEO"]) {
         [self.photoImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake((kScreenWidth-3)/4 , (kScreenWidth-3)/4),model.videoId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-3)/4 , (kScreenWidth-3)/4))];
    }else{
        [self.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake((kScreenWidth-3)/4 , (kScreenWidth-3)/4),model.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake((kScreenWidth-3)/4 , (kScreenWidth-3)/4))];
    }


    self.selectimage.selected = model.isSelect;

}


- (void)setCSSStyle:(WARPhotoDetailViewType)type{
    if (type == WARPhotoDetailViewTypeDefualt) {
        self.selectimage.hidden = NO;
    }else if (type  == WARPhotoDetailViewTypeCover){
        self.selectimage.hidden = YES;
    }else{
        self.selectimage.hidden = YES;
    }

}
- (void)selectPhoto:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    self.model.isSelect = btn.selected;
    
    if (self.block) {
        self.block(btn, self.model);
    }
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
- (UIButton *)selectimage{
    if (!_selectimage ) {
        _selectimage = [[UIButton alloc] init];
        [_selectimage setImage:[UIImage war_imageName:@"hook" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
        [_selectimage setImage:[UIImage war_imageName:@"personal_set_select" curClass:self curBundle:@"WARProfile.bundle"] forState:UIControlStateSelected];
        [_selectimage addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
  
        
    }
    return _selectimage;
}
- (UIImageView *)photoImgV{
    if (!_photoImgV) {
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgV.clipsToBounds = YES;
    }
    return _photoImgV;
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
@end
