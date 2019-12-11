//
//  WARFavriteGenarContentSubCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import "WARFavriteGenarContentSubCell.h"
#import "WARConfigurationMacros.h"
#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARUIHelper.h"
#define CellW    ([UIScreen mainScreen].bounds.size.width - 30-13.5*2)/3
@implementation WARFavriteGenarContentSubCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self setCellLayout];
    }
    return self;
}
- (void)initSubViews {
    [self.contentView addSubview:self.bgV];
    [self.contentView addSubview:self.coverimageV];
    [self.coverimageV addSubview:self.opaqueV];
    [self.coverimageV addSubview:self.lockImageV];
    [self.coverimageV addSubview:self.countlb];
    [self.contentView addSubview:self.titlelb];
    [self.coverimageV addSubview:self.coverV];
    [self.coverimageV addSubview:self.favriteBtn];
    [self.coverimageV addSubview:self.editingBtn];
}
- (void)setCellLayout {
    [self.bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@152);
    }];
    [self.coverimageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@146);
    }];
    [self.coverV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverimageV);
    }];

    [self.favriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(42);
        make.height.equalTo(@24);
    }];
    [self.editingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.favriteBtn.mas_bottom).offset(14);
        make.height.equalTo(@24);
    }];
    [self.opaqueV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.coverimageV);
        make.height.equalTo(@26);
    }];
    [self.lockImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@13);
        make.height.equalTo(@14);
        make.left.equalTo(self.coverimageV).offset(5);
        make.bottom.equalTo(self.coverimageV).offset(-5);
    }];
    [self.countlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverimageV).offset(-5);
        make.bottom.equalTo(self.coverimageV).offset(-5);
        make.height.equalTo(@12);
        make.width.equalTo(@45);
    }];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverimageV.mas_bottom).offset(8);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@12);
    }];

}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.editingBtn.hidden = !selected;
    self.favriteBtn.hidden = !selected;
    self.coverV.hidden = !selected;
}
- (void)setModel:(WARFavoriteInfoModel *)model {
    _model = model;
    [self.coverimageV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(CellW, 132),model.favoriteCover) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.countlb.text = [NSString stringWithFormat:@"%@张",model.favoriteCount];
    self.titlelb.text = WARLocalizedString(model.favoriteName);
    CGSize sizeLocal = [ self.titlelb.text boundingRectWithSize:CGSizeMake(CellW, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(12)} context:nil].size;
    [self.titlelb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(sizeLocal.height));
    }];
    
}
- (void)editingClick:(UIButton*)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editingClick" object:self.model];
    
}
- (void)favriteClick:(UIButton*)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favriteClick" object:self.model];
}

- (void)setlayerShadow:(UIView*)v {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CellW, 152+39)];
    
    v.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;//阴影颜色
    v.layer.shadowOffset = CGSizeMake(1, 0);//偏移距离
    v.layer.shadowOpacity = 0.5;//不透明度
//    v.layer.shadowRadius = 2;//半径
    
    v.layer.shadowPath = shadowPath.CGPath;
}
- (UIImageView *)bgV {
    if (!_bgV) {
        _bgV = [[UIImageView alloc] initWithImage:[UIImage war_imageName:@"favrite" curClass:[self class] curBundle:@"WARProfile.bundle"]];
        _bgV.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgV;
}
- (UIView *)coverV {
    if (!_coverV) {
        _coverV = [[UIView alloc] init];
        _coverV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.66];
        _coverV.hidden = YES;
    }
    return _coverV;
}
- (UIImageView *)coverimageV {
    if (!_coverimageV) {
        _coverimageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0 , 152)];
        //        _imageV.layer.shadowColor = [UIColor blackColor].CGColor;
        //        _imageV.layer.shadowOffset=CGSizeMake(0, 1);
        //        _imageV.layer.shadowOpacity = 0.5f;
        //        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_imageV.bounds];
        //        _imageV.layer.shadowPath = shadowPath.CGPath;
        _coverimageV.userInteractionEnabled = YES;
    }
    return _coverimageV;
}
- (UIButton *)favriteBtn {
    if (!_favriteBtn) {
        _favriteBtn = [[UIButton alloc] init];
        [_favriteBtn setTitle:WARLocalizedString(@"直接收藏") forState:UIControlStateNormal];
        [_favriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_favriteBtn addTarget:self action:@selector(favriteClick:) forControlEvents:UIControlEventTouchUpInside];
        _favriteBtn.titleLabel.font = kFont(12);
        _favriteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _favriteBtn.layer.borderWidth = 0.5;
        _favriteBtn.layer.cornerRadius = 4;
        _favriteBtn.layer.masksToBounds = YES;
        _favriteBtn.hidden = YES;
    }
    return _favriteBtn;
}
- (UIButton *)editingBtn {
    if (!_editingBtn) {
        _editingBtn = [[UIButton alloc] init];
        [_editingBtn setTitle:WARLocalizedString(@"编辑后收藏") forState:UIControlStateNormal];
        [_editingBtn addTarget:self action:@selector(editingClick:) forControlEvents:UIControlEventTouchUpInside];
         _editingBtn.titleLabel.font = kFont(12);
        _editingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _editingBtn.layer.borderWidth = 0.5;
        _editingBtn.layer.cornerRadius = 4;
        _editingBtn.layer.masksToBounds = YES;
        [_editingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editingBtn.hidden = YES;
    }
    return _editingBtn;
}
- (UIView *)opaqueV {
    if (!_opaqueV) {
        _opaqueV = [[UIView alloc] init];
        _opaqueV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _opaqueV;
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
