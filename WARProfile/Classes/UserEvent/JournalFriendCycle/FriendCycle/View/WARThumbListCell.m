//
//  WARThumbListCell.m
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import "WARThumbListCell.h"
#import "WARMacros.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"

@interface WARThumbListCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
/** 年龄 */
@property (nonatomic, strong) UILabel *ageLab;
/** 年龄背景图 */
@property (nonatomic, strong) UIImageView *ageIV;
/** 星座 */
@property (nonatomic, strong) UIImageView *constellationIV;

@end

@implementation WARThumbListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headerImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.ageIV];
        [self.contentView addSubview:self.ageLab];
        [self.contentView addSubview:self.constellationIV];
        
        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(9);
            make.width.height.mas_equalTo(36);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
            make.top.mas_equalTo(8.5);
            make.height.mas_equalTo(16);
            
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8.5);
            make.height.mas_equalTo(13);
            make.right.mas_equalTo(-10);
        }];
        [_ageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.top.mas_equalTo(11);
            make.width.height.mas_equalTo(13);
        }];
        [_ageIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(5);
            make.top.mas_equalTo(11);
            make.width.height.mas_equalTo(13);
        }];
        [_constellationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ageIV.mas_right).offset(3);
            make.top.mas_equalTo(11);
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

- (void)setModel:(WARNewUserDiaryUser *)model {
    _model = model;
    self.nameLabel.text = model.nickname;
    [self.headerImageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(36, 36), model.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    // 星座性别年龄
    if (model.year.length && model.month.length && model.day.length && [model.year intValue] > 0 && [model.month intValue] > 0 && [model.day intValue] > 0) {
        self.constellationIV.hidden = NO;
        self.ageLab.hidden = NO;
        self.ageIV.hidden = NO;
        
        self.constellationIV.image = [WARUIHelper war_coloredConstellationImgWithMonth:[model.month integerValue] day:[model.day integerValue]];
        self.ageLab.text = [WARUIHelper war_birthdayToAge:model.year month:model.month day:model.day];
        self.ageIV.image = [WARUIHelper ageImgByGender:model.gender];
        
    }else {
        self.constellationIV.hidden = YES;
        self.ageLab.hidden = YES;
        self.ageIV.hidden = YES;
    }
    
    self.detailLabel.text = model.sign;
}

- (UIImageView *)headerImageView{
    if(!_headerImageView){
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.cornerRadius = 3;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = HEXCOLOR(0x576B95);
    }
    return _nameLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = HEXCOLOR(0x737373);
    }
    return _detailLabel;
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
