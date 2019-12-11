//
//  WARBrowserMoudleCollectionCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import "WARBrowserMoudleCollectionCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARUIHelper.h"
#import "WARGroupModel.h"
@implementation WARBrowserMoudleCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photoImgV];
 
    
        [self.photoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        

    }
    return self;
}
- (void)setModel:(WARPictureModel *)model{
    _model = model;
    for (UIView *v in self.contentView.subviews) {
        if (v.tag > 10000) {
            [v removeFromSuperview];
        }
    }
    if ([model.type isEqualToString:@"VIDEO"]) {
        [self.photoImgV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(model.getwidth, model.getHeight),model.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(model.getwidth , model.getHeight))];
    }else{
        [self.photoImgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(model.getwidth , model.getHeight),model.pictureId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(model.getwidth , model.getHeight))];
    }

 
 CGSize size =   [model.desc boundingRectWithSize:CGSizeMake(model.getwidth-10, model.getHeight/3) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(12)} context:nil].size;
    if (model.desc.length >0) {

        UIView *maskV = [[UIView alloc] init];
        maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        maskV.tag = 10002;
        [self.contentView addSubview:maskV];
        
        UILabel *desclb = [[UILabel alloc] init];
        desclb.font = kFont(12);
        desclb.textColor = [UIColor whiteColor];
        desclb.numberOfLines = 0;
        desclb.tag = 10001;
        [self.contentView addSubview:desclb];
        desclb.text = WARLocalizedString(model.desc);
        [desclb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@(size.height));
        }];
        [maskV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@(size.height));
        }];
    }

 
    
}

- (UIImageView *)photoImgV{
    if (!_photoImgV) {
        _photoImgV = [[UIImageView alloc] init];
        _photoImgV.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgV.clipsToBounds = YES;
        _photoImgV.layer.cornerRadius = 6;
        _photoImgV.layer.masksToBounds = YES;
    }
    return _photoImgV;
}
- (UILabel *)desclb {
    if (!_desclb) {
        _desclb = [[UILabel alloc] init];
        _desclb.font = kFont(12);
        _desclb.textColor = [UIColor whiteColor];
        _desclb.numberOfLines = 0;
    }
    return _desclb;
}
- (UIView *)maskV {
    if (!_maskV) {
        _maskV = [[UIView alloc] init];
        _maskV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskV;
}
@end
