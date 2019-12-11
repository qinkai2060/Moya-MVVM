//
//  WARFriendCycleTableHeaderView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/18.
//

#import "WARFriendCycleTableHeaderView.h"
#import "Masonry.h"
#import "WARProfileUserModel.h"
#import "WARUIHelper.h"
#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WARBundleImage.h"
 
#define kHeaderView (347)

@interface WARFriendCycleTableHeaderView()

@property (nonatomic,strong)UIImageView *themeimgV; // 主题
//@property (nonatomic,strong)UIImageView *bottomimgv;// 蒙层
@property (nonatomic,strong)UIImageView *shadowImageV;// 蒙层

@property (nonatomic,strong)UIImageView *iconImgv; // 头像
@property (nonatomic,strong)UIImageView *iconImgBoder; // 头像
@property (nonatomic, strong) UILabel *nameLabel; // 名字
@property (nonatomic,strong)UIImageView *ageimgv;// 年龄
@property (nonatomic,strong)UILabel *agelabel; // 年龄
@property (nonatomic,strong)UIImageView *solarimgv; // 星座]

@end

@implementation WARFriendCycleTableHeaderView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.themeimgV];
//    [self addSubview:self.bottomimgv];
    [self addSubview:self.shadowImageV];
    [self addSubview:self.iconImgBoder];
    [self addSubview:self.iconImgv];
    [self addSubview:self.ageimgv];
    [self addSubview:self.agelabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.solarimgv];
    
    [self setLayout];
}

- (void)setLayout{
    [self.themeimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kHeaderView - 27));
    }];
//    [self.bottomimgv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.themeimgV);
//    }];
    [self.shadowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.themeimgV);
    }];
    
    [self.iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.right.mas_equalTo(-11.5);
        make.bottom.mas_equalTo(@(-6));
    }];
    
    [self.iconImgBoder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@74);
        make.right.mas_equalTo(-9.5);
        make.bottom.mas_equalTo(@(-4));
    }];
 
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.bottom.equalTo(self.themeimgV.mas_bottom).offset(-13);
        make.right.equalTo(self.iconImgv.mas_left).offset(-18);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - Event Response

- (void)didHeader:(UITapGestureRecognizer *)ges {
    if([self.delegate respondsToSelector:@selector(headerViewDidUserHeader:)]) {
        [self.delegate headerViewDidUserHeader:self];
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setModel:(WARProfileMasksModel *)model {
    _model = model;
    
    [self.themeimgV sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kScreenWidth, kHeaderView), _model.bgId) placeholderImage:[WARUIHelper war_placeholderBackground]];
    [self.iconImgv sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(70, 70), _model.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    
    self.nameLabel.text = WARLocalizedString(_model.nickname);
    
    if (_model.bornDay.length!=0) {
        self.solarimgv.image = [WARUIHelper war_constellationImgWithMonth:[_model.month integerValue] day:[_model.day integerValue] gender:_model.gender];
        NSString *ageStr = [WARUIHelper war_birthdayToAge:_model.year month:_model.month day:_model.day];
        self.agelabel.text = ageStr;
        if (ageStr.length) {
            self.agelabel.hidden = NO;
            self.agelabel.backgroundColor = [WARUIHelper ageBgColorByGender:_model.gender];
        }else {
            self.agelabel.hidden = YES;
        }
    }
}

- (UIImageView *)themeimgV{
    if (!_themeimgV) {
        _themeimgV = [[UIImageView alloc] init];
        _themeimgV.contentMode = UIViewContentModeScaleAspectFill;
        _themeimgV.clipsToBounds = YES;
        _themeimgV.userInteractionEnabled = YES;
        
    }
    return _themeimgV;
}

- (UIImageView *)shadowImageV{
    if (!_shadowImageV) {
        _shadowImageV = [[UIImageView alloc] init];
//        _shadowImageV.contentMode = UIViewContentModeScaleToFill;
        // informationedit_mass_down@3x  friendgroupbg_shadow
        UIImage *image = [UIImage war_imageName:@"personalinformation_shadow" curClass:self curBundle:@"WARProfile.bundle"];
        _shadowImageV.image = image;
    }
    return _shadowImageV;
}

- (UIImageView *)iconImgv{
    if (!_iconImgv) {
        _iconImgv = [[UIImageView alloc] init];
        _iconImgv.layer.cornerRadius = 0;
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.userInteractionEnabled = YES;
        _iconImgv.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeader:)];
        [_iconImgv addGestureRecognizer:tap];
    }
    return _iconImgv;
}

- (UIImageView *)iconImgBoder{
    if (!_iconImgBoder) {
        _iconImgBoder = [[UIImageView alloc] init];
        _iconImgBoder.backgroundColor = [UIColor whiteColor];
        _iconImgBoder.layer.shadowColor = HEXCOLOR(0x999999).CGColor;
        _iconImgBoder.layer.shadowOffset = CGSizeMake(0, 0);
        _iconImgBoder.layer.shadowOpacity = 1.0;
        _iconImgBoder.layer.shadowRadius = 1.0;
    }
    return _iconImgBoder;
}

- (UIImageView *)ageimgv{
    if (!_ageimgv) {
        _ageimgv = [[UIImageView alloc] init];
        _ageimgv.layer.cornerRadius = 2;
        _ageimgv.layer.masksToBounds = YES;
    }
    return _ageimgv;
}

- (UIImageView *)solarimgv{
    if (!_solarimgv) {
        _solarimgv = [[UIImageView alloc] init];
    }
    return _solarimgv;
}

- (UILabel *)agelabel{
    if (!_agelabel) {
        _agelabel = [[UILabel alloc] init];
        _agelabel.textColor = [UIColor whiteColor];
        _agelabel.font = [UIFont systemFontOfSize:10];
        _agelabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _agelabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0xFFFBF2);
        _nameLabel.numberOfLines = 0;
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _nameLabel;
}

@end
