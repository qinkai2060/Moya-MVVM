//
//  CustumDiscountCouponTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustumDiscountCouponTableViewCell.h"
#import "JudgeOrderType.h"
@implementation CustumDiscountCouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}
- (void)creatcellView
{
    [self addSubview:self.imgBg];
    [self.imgBg addSubview:self.moneyLabel];
    [self.imgBg addSubview:self.nameLabel];
    [self.imgBg addSubview:self.conditionLabel];
    [self.imgBg addSubview:self.dateLabel];
    [self.imgBg addSubview:self.getBtn];
    [self.imgBg addSubview:self.promptLabel];
}
- (void)setCouponModel:(DiscountCouponModel *)couponModel{
    _couponModel = couponModel;
    [self moneyLabelForText:_couponModel.couponAmount];//金额
    self.nameLabel.text = [NSString stringWithFormat:@"%@",CHECK_STRING(_couponModel.couponName)];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@",CHECK_STRING(_couponModel.subTitle)];
    if (CHECK_STRING_ISNULL(_couponModel.validityStart) || CHECK_STRING_ISNULL(_couponModel.validityEnd)) {
        self.dateLabel.text = @"";
    } else {
        
     self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[JudgeOrderType timeStr1000:CHECK_STRING(_couponModel.validityStart) formatterType:@"yyyy.MM.dd HH.mm"],[JudgeOrderType timeStr1000:CHECK_STRING(_couponModel.validityEnd) formatterType:@"yyyy.MM.dd HH.mm"]];
    }
    if ([_couponModel.hasReceviedCount integerValue] > 0) {
        self.promptLabel.text = [NSString stringWithFormat:@"已领%@张",_couponModel.hasReceviedCount];
        self.promptLabel.hidden = NO;
    } else {
   
        self.promptLabel.hidden = YES;
    }
    ////领取标识, 1立即领取 2已领完(已达个人上线) 3已领完(库存已领完)
    switch ([_couponModel.recevieFlag integerValue]) {
        case 1:
        {
            if ([_couponModel.hasReceviedCount integerValue] > 0) {
                _getBtn.backgroundColor = HEXCOLOR(0xFF0000);
                [_getBtn setTitle:@"继续领取" forState:(UIControlStateNormal)];
        } else {
            
            _getBtn.backgroundColor = HEXCOLOR(0xFF0000);
            [_getBtn setTitle:@"立即领取" forState:(UIControlStateNormal)];
        }
            _getBtn.userInteractionEnabled = YES;

            
          
        }
            break;
        case 2:
        {
            _getBtn.backgroundColor = HEXCOLOR(0xAAAAAA);
            _getBtn.userInteractionEnabled = NO;
            [_getBtn setTitle:@"已领完" forState:(UIControlStateNormal)];
        }
            break;
        case 3:
        {
            _getBtn.backgroundColor = HEXCOLOR(0xAAAAAA);
            _getBtn.userInteractionEnabled = NO;
            [_getBtn setTitle:@"已领完" forState:(UIControlStateNormal)];
        }
            break;
            
        default:
            break;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WScale(15));
        make.right.equalTo(self).offset(WScale(-15));
        make.top.equalTo(self).offset(WScale(15));
        make.bottom.equalTo(self);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgBg).offset(WScale(15));
        make.top.equalTo(self.imgBg).offset(WScale(20));
        make.height.mas_offset(WScale(24));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right).offset(WScale(25));
        //        make.left.equalTo(self.moneyLabel).offset(WScale(97));

        make.top.equalTo(self.imgBg).offset(WScale(15));
        make.height.mas_offset(WScale(20));
    }];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.mas_offset(WScale(16));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgBg).offset(WScale(15));
        make.bottom.equalTo(self.imgBg).offset(WScale(-15));
        make.height.mas_offset(WScale(16));
    }];
    
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgBg).offset(WScale(-7));
        make.width.mas_offset(WScale(75));
        make.height.mas_offset(WScale(25));
        make.centerY.equalTo(self.imgBg);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.getBtn);
        make.bottom.equalTo(self.getBtn.mas_top).offset(-WScale(5));
        make.height.mas_offset(WScale(17));
    }];
    
}
- (UIImageView *)imgBg{
    if (!_imgBg) {
        _imgBg = [[UIImageView alloc] init];
        _imgBg.image = [UIImage imageNamed:@"icon_vipbg"];
        _imgBg.userInteractionEnabled = YES;
    }
    return _imgBg;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"¥1600";
        _moneyLabel.font = [UIFont boldSystemFontOfSize:20];
        _moneyLabel.textColor = HEXCOLOR(0xFF0000);
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moneyLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"VIP商品优惠券";
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)conditionLabel{
    if (!_conditionLabel) {
        _conditionLabel = [[UILabel alloc] init];
        _conditionLabel.text = @"订单满158使用";
        _conditionLabel.font = [UIFont boldSystemFontOfSize:12];
        _conditionLabel.textColor = HEXCOLOR(0x666666);
        _conditionLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _conditionLabel;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = @"2019.05.19 00:00 - 2019.05.22 23:59";
        _dateLabel.font = [UIFont boldSystemFontOfSize:12];
        _dateLabel.textColor = HEXCOLOR(0x666666);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}
- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = @"已领1张";
        _promptLabel.font = [UIFont boldSystemFontOfSize:12];
        _promptLabel.textColor = HEXCOLOR(0xFF0000);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLabel;
}
- (UIButton *)getBtn{
    if (!_getBtn) {
        _getBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _getBtn.backgroundColor = HEXCOLOR(0xFF0000);
        [_getBtn setTitle:@"立即领取" forState:(UIControlStateNormal)];
        [_getBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _getBtn.titleLabel.font = [UIFont systemFontOfSize:WScale(13)];
        _getBtn.layer.cornerRadius = WScale(12.5);
        _getBtn.layer.masksToBounds = YES;
        [_getBtn addTarget:self action:@selector(getBtnClickAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _getBtn;
}
- (void)getBtnClickAction{
    NSLog(@"点击领取");
    if (self.getBtnActionBlock) {
        self.getBtnActionBlock(self.tag - 1000);
    }
}
- (void)moneyLabelForText:(NSNumber *)money{
    NSInteger intMoney = [money integerValue];
    intMoney = intMoney ?: 0;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%ld",intMoney]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, 1)];
    self.moneyLabel.attributedText = str;

}
@end
