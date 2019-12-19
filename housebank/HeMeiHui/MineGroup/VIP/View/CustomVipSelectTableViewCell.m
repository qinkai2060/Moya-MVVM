//
//  CustomVipSelectTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustomVipSelectTableViewCell.h"

@implementation CustomVipSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.text = @"主标题";
        _infoLabel.font = PFR13Font;
        _infoLabel.textColor = HEXCOLOR(0x333333);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}
- (void)setPriceInfosModel:(PriceInfos *)priceInfosModel{
    _priceInfosModel = priceInfosModel;
    _infoLabel.text = [NSString stringWithFormat:@"%ld件(含)以上%.2f元/件", (long)_priceInfosModel.countBuy,_priceInfosModel.cashPrice];
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xE5E5E5);
    }
    return _line;
}
- (void)creatcellView
{
    [self addSubview:self.infoLabel];
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.8);
    }];
}

@end

@implementation CustomVipTreturnoOnProfittTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.text = @"主标题";
        _infoLabel.font = PFR13Font;
        _infoLabel.textColor = HEXCOLOR(0x333333);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _infoLabel;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"类型";
        _typeLabel.font = PFR13Font;
        _typeLabel.textColor = HEXCOLOR(0x333333);
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}
- (void)setRebateInfoModel:(RebateInfo *)rebateInfoModel{
    _rebateInfoModel = rebateInfoModel;
    self.typeLabel.text = [self vipNameForVipLevel:_rebateInfoModel.vipLevel];
    self.infoLabel.text = [NSString stringWithFormat:@"%.2f元/件", _rebateInfoModel.rebatePrice];
}
- (NSString *)vipNameForVipLevel:(NSInteger)level{
    NSString *str = @"";
    switch (level) {
        case 1:
            str = @"免费";
            break;
        case 2:
            str = @"银卡";
            break;
        case 3:
            str = @"铂金";
            break;
        case 4:
            str = @"钻石";
            break;
            
        default:
            break;
    }
    return str;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xE5E5E5);
    }
    return _line;
}
- (void)creatcellView
{
    [self addSubview:self.typeLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(75);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(0.8);
    }];
}

@end
