//
//  WARContactsFriendManageBaseCell.m
//  WARContacts
//
//  Created by Hao on 2018/4/23.
//

#import "WARCycleOfFriendMaskCell.h"

#import "Masonry.h"
#import "WARConfigurationMacros.h"
#import "WARUIHelper.h"
#import "WARMacros.h"

#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"

@interface WARCycleOfFriendMaskCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLab;
/** 年龄背景图 */
@property (nonatomic, strong) UIImageView *ageIV;
/** 星座 */
@property (nonatomic, strong) UIImageView *constellationIV;

@property (nonatomic, strong) UIView *defaultView;
@property (nonatomic, strong) UILabel *defaultLabel;

@end

@implementation WARCycleOfFriendMaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.selectImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.ageIV];
        [self.contentView addSubview:self.ageLab];
        [self.contentView addSubview:self.constellationIV];

        [self.headerImageView addSubview:self.defaultView];
        [self.defaultView addSubview:self.defaultLabel];
        
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(8);
            make.width.height.mas_equalTo(24);
        }];
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.selectImageView.mas_right).offset(11);
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
            make.width.mas_equalTo(self.headerImageView.mas_height);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.headerImageView);
            make.height.mas_equalTo(10);
        }];
        
        [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.defaultView);
        }];
        
        [_ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.nameLabel);
            make.width.height.mas_equalTo(13);
        }];
        [_ageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(self.nameLabel);
            make.width.height.mas_equalTo(13);
        }];
        [_constellationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ageIV.mas_right).offset(3);
            make.centerY.mas_equalTo(self.nameLabel);
            make.width.height.mas_equalTo(13);
        }];
        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = SeparatorColor;
        [self.contentView addSubview:lineV];
        
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)setMaskModel:(WARDBCycleOfFriendMaskModel *)maskModel {
    
    if (!maskModel.isAllFriends) {
        [self.headerImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(36, 36), maskModel.faceImg) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    } else {
        self.headerImageView.image = [UIImage war_imageName:@"allfriends" curClass:self.class curBundle:@"WARProfile.bundle"];
    }
    self.nameLabel.text = maskModel.remark;
    
    // 星座性别年龄
    if (maskModel.year.length && maskModel.month.length && maskModel.day.length && [maskModel.year intValue] > 0 && [maskModel.month intValue] > 0 && [maskModel.day intValue] > 0) {
        self.constellationIV.hidden = NO;
        self.ageLab.hidden = NO;
        self.ageIV.hidden = NO;
        
        self.constellationIV.image = [WARUIHelper war_coloredConstellationImgWithMonth:[maskModel.month integerValue] day:[maskModel.day integerValue]];
        self.ageLab.text = [WARUIHelper war_birthdayToAge:maskModel.year month:maskModel.month day:maskModel.day];
        self.ageIV.image = [WARUIHelper ageImgByGender:maskModel.gender];
        
    }else {
        self.constellationIV.hidden = YES;
        self.ageLab.hidden = YES;
        self.ageIV.hidden = YES;
    }
    
    if (maskModel.defaults) {
        self.defaultView.hidden = NO;
    }else {
        self.defaultView.hidden = YES;
    }
}

- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc] init];
    }
    return _headerImageView;
}

- (UIImageView *)selectImageView{
    if(!_selectImageView){
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage war_imageName:@"friendset_unselect" curClass:self.class curBundle:@"WARProfile.bundle"];
//        _selectImageView.tintColor = ThemeColor;
    }
    return _selectImageView;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _nameLabel.textColor = TextColor;
    }
    return _nameLabel;
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [[UIView alloc] init];
        _defaultView.backgroundColor = SecondaryColor;
        _defaultView.hidden = YES;
    }
    return _defaultView;
}

- (UILabel *)defaultLabel{
    if(!_defaultLabel){
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.font = [UIFont systemFontOfSize:6];
        _defaultLabel.textColor = [UIColor whiteColor];
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.text = WARLocalizedString(@"公开");
    }
    return _defaultLabel;
}

- (UILabel *)ageLab {
    if (!_ageLab) {
        _ageLab = [UILabel new];
        _ageLab.font = kFont(8);
        _ageLab.textColor = kColor(whiteColor);
        _ageLab.textAlignment = NSTextAlignmentCenter;
        _ageLab.backgroundColor = kColor(clearColor);
    }
    
    return _ageLab;
}

- (UIImageView *)ageIV{
    if (!_ageIV) {
        _ageIV = [[UIImageView alloc]init];
        _ageIV.contentMode = UIViewContentModeCenter;
    }
    return _ageIV;
}

- (UIImageView *)constellationIV {
    if (!_constellationIV) {
        _constellationIV = [[UIImageView alloc] init];
        _constellationIV.contentMode = UIViewContentModeCenter;
    }
    return _constellationIV;
}

@end
