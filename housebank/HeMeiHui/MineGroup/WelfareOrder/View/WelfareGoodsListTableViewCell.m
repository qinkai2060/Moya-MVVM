//
//  WelfareGoodsListTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WelfareGoodsListTableViewCell.h"
#import "UIView+addGradientLayer.h"

@implementation WelfareGoodsListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)imgLogo{
    if (!_imgLogo) {
        _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        _imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgLogo;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"Lenovo/联想 小新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…";
        _titleL.font = PFR15Font;
        _titleL.textColor = HEXCOLOR(0x333333);
        _titleL.numberOfLines = 2;
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"12000";
        _moneyLabel.font = PFR12Font;
        _moneyLabel.textColor = HEXCOLOR(0xF3344A);
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moneyLabel;
    
}


- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.text = @"6GB+128GB/全网通4G";
        _rankLabel.font = PFR12Font;
        _rankLabel.textColor = HEXCOLOR(0x999999);
        _rankLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rankLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"Ⅱ类";
        _typeLabel.font = PFR9Font;
        //        _typeLabel.hidden = YES;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.backgroundColor = HEXCOLOR(0xFF9900);
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}


//- (UILabel *)groupPurchaseLabel{
//    if (!_groupPurchaseLabel) {
//        _groupPurchaseLabel = [[UILabel alloc] init];
//        _groupPurchaseLabel.text = @"拼团";
//        _groupPurchaseLabel.font = PFR9Font;
//        _groupPurchaseLabel.textColor = HEXCOLOR(0xF3344A);
//        _groupPurchaseLabel.textAlignment = NSTextAlignmentCenter;
//        _groupPurchaseLabel.layer.cornerRadius = 2;
//        _groupPurchaseLabel.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
//        _groupPurchaseLabel.layer.borderWidth = 0.8;
//        _groupPurchaseLabel.layer.masksToBounds = YES;
//    }
//    return _groupPurchaseLabel;
//}

- (UILabel *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc] init];
        _couponLabel.text = @"可用注册券";
        _couponLabel.font = PFR9Font;
        _couponLabel.textColor = HEXCOLOR(0xF3344A);
        _couponLabel.textAlignment = NSTextAlignmentCenter;
        _couponLabel.layer.cornerRadius = 2;
        _couponLabel.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
        _couponLabel.layer.borderWidth = 0.8;
        _couponLabel.hidden = YES;
        _couponLabel.layer.masksToBounds = YES;
    }
    return _couponLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
        _buyBtn.titleLabel.font = PFR13Font;
        _buyBtn.userInteractionEnabled = NO;
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _buyBtn.backgroundColor = HEXCOLOR(0xF3344A);
        _buyBtn.layer.cornerRadius = 12.5;
        _buyBtn.layer.masksToBounds = YES;
    }
    return _buyBtn;
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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.imgLogo];
    [self.bgView addSubview:self.titleL];
    [self.bgView addSubview:self.rankLabel];
    [self.bgView addSubview:self.typeLabel];
    [self.bgView addSubview:self.couponLabel];
//    [self.bgView addSubview:self.salesLabel];
    [self.bgView addSubview:self.buyBtn];
    [self.bgView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.line];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.left.equalTo(self.bgView).offset(15);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgLogo);
        make.left.equalTo(self.imgLogo.mas_right).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
    }];
    
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).offset(5);
    }];
    
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.rankLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(24, 12));
    }];
    
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(2);
        make.top.equalTo(self.typeLabel);
        make.size.mas_equalTo(CGSizeMake(50, 12));
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.bgView).offset(-13);
        make.size.mas_equalTo(CGSizeMake(72, 25));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.centerY.equalTo(self.buyBtn);
        make.height.mas_equalTo(15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.bottom.equalTo(self.bgView).offset(-0.7);
        make.height.mas_equalTo(0.7);
    }];
    
    [self layoutIfNeeded];
    
    [self.buyBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [self.buyBtn bringSubviewToFront:_buyBtn.titleLabel];
    
}
- (void)setModel:(WelfareGoodsListModel *)model
{
    _model = model;
    
    [self.imgLogo sd_setImageWithURL:[_model.imageUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
    self.titleL.text = _model.productName;
    
    [self moneyLabelTextMoreColor:_model.cashPrice];
    //规格
    if ([_model.productSubtitle isKindOfClass:[NSString class]]) {
        self.rankLabel.text = [NSString stringWithFormat:@"%@",_model.productSubtitle];
    } else {
        self.rankLabel.text = @"";
    }
   
    [self oneTwoThereClass];
    
    if (!CHECK_STRING_ISNULL(_model.useRegisterCoupon) &&[_model.useRegisterCoupon isEqual:@(1)]) {
        self.couponLabel.hidden = NO;
        if (_typeLabel.hidden) {
            [self.couponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleL);
                make.top.equalTo(self.typeLabel);
                make.size.mas_equalTo(CGSizeMake(50, 12));
            }];
        } else {
            [self.couponLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeLabel.mas_right).offset(2);
                make.top.equalTo(self.typeLabel);
                make.size.mas_equalTo(CGSizeMake(50, 12));
            }];
        }
       
    } else {
        self.couponLabel.hidden = YES;
    }
    
}
- (void)moneyLabelTextMoreColor:(NSNumber *)money{
  
    CGFloat moneyFloat = [money floatValue];
    NSString *strMoney = [NSString stringWithFormat:@"￥%.2f", moneyFloat];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
   if (moneyFloat < 1) {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, strMoney.length - 1)];
    } else {
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1, strMoney.length - 3)];
    }
    _moneyLabel.attributedText = str;
    
}
- (BOOL)oneTwoThereClass{
    BOOL isShow = NO;
    switch ([_model.productLevel integerValue]) {
        case 1:
            _typeLabel.hidden = NO;
            isShow = YES;
            _typeLabel.text = @"Ⅰ类";
            _typeLabel.backgroundColor = HEXCOLOR(0xF63019);
            break;
        case 2:
            _typeLabel.hidden = NO;
            isShow = YES;
            _typeLabel.text = @"Ⅱ类";
            _typeLabel.backgroundColor = HEXCOLOR(0xFF9900);
            
            break;
        case 3:
            _typeLabel.hidden = NO;
            isShow = YES;
            _typeLabel.text = @"Ⅲ类";
            _typeLabel.backgroundColor = HEXCOLOR(0xB4B4B4);
            
            break;
            
        default:
            isShow = NO;
            _typeLabel.hidden = YES;
            break;
    }
    return isShow;
}


@end
