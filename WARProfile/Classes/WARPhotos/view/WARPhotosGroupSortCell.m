//
//  WARPhotosGroupSortCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/3.
//

#import "WARPhotosGroupSortCell.h"
#import "UIColor+WARCategory.h"
#import "Masonry.h"
#import "WARUIHelper.h"
#import "WARBaseMacros.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WARBundleImage.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h"
@interface WARPhotosGroupSortCell ()
/**图片*/
@property (nonatomic,strong) UIImageView *imageV;
/**str*/
@property (nonatomic,strong) UIImageView *sideIconImageV;

/**line*/
@property (nonatomic,strong) UIView  *lineView;

@property(nonatomic,strong)UILabel *titlelb;
@end
@implementation WARPhotosGroupSortCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    [self addSubview:self.imageV];
   [self.contentView addSubview:self.sideIconImageV];
    [self addSubview:self.lineView];
    [self addSubview:self.titlelb];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo (self);
        make.height.width.equalTo(@35);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.sideIconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.width.equalTo(@25);
    }];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self);
       make.right.equalTo(self.sideIconImageV.mas_left).offset(-50);
        //make.height.equalTo(@200);
        make.left.equalTo(self.imageV.mas_right).offset(8);
        make.height.equalTo(@16);
    }];
}
- (void)setModel:(WARGroupModel *)model {
    _model = model;
    self.titlelb.text = [NSString stringWithFormat:@"%@",model.name];
    if ([model.coverType isEqualToString:@"VIDEO"]) {
        [self.imageV sd_setImageWithURL:kVideoCoverUrlWithImageSize(CGSizeMake(35 , 35),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(35 , 35))];;
    }else{
        [self.imageV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(35 , 35),model.coverId) placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(35 , 35))];;
    }
    
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.layer.cornerRadius = 3;
        _imageV.layer.masksToBounds = YES;
    }
    return _imageV;
}
- (UIImageView *)sideIconImageV {
    if (!_sideIconImageV) {
        _sideIconImageV = [[UIImageView alloc] init];
        _sideIconImageV.image = [UIImage war_imageName:@"personal_photo_seqencing" curClass:[self class] curBundle:@"WARProfile.bundle"];
    }
    return _sideIconImageV;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = SeparatorColor;
    }
    return _lineView;
}
- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] init];
        _titlelb.font = kFont(16);
        _titlelb.textColor = TextColor;
        _titlelb.text = WARLocalizedString(@"一醉方休");
    }
    return _titlelb;
}
@end
