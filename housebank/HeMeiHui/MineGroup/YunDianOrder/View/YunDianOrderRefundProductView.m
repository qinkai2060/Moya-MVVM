//
//  YunDianOrderRefundProductView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderRefundProductView.h"

@implementation YunDianOrderRefundProductView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (UIView *)productView{
    if (!_productView) {
        _productView = [[UIView alloc] init];
        _productView.backgroundColor = [UIColor whiteColor];
    }
    return _productView;
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
        _titleL.text = @"";
        _titleL.font = PFR13Font;
        _titleL.textColor = HEXCOLOR(0x333333);
        _titleL.numberOfLines = 2;
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"";
        _moneyLabel.font = PFR12Font;
        _moneyLabel.textColor = HEXCOLOR(0x333333);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
    
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"";
        _numLabel.font = PFR12Font;
        _numLabel.textColor = HEXCOLOR(0x333333);
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}
- (UILabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.text = @"";
        _rankLabel.font = PFR12Font;
        _rankLabel.textColor = HEXCOLOR(0x666666);
        _rankLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rankLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"Ⅱ类";
        _typeLabel.font = PFR9Font;
        _typeLabel.hidden = YES;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.backgroundColor = HEXCOLOR(0xFF9900);
        _typeLabel.layer.cornerRadius = 2;
        _typeLabel.layer.masksToBounds = YES;
    }
    return _typeLabel;
}
- (UILabel *)salesLabel{
    if (!_salesLabel) {
        _salesLabel = [[UILabel alloc] init];
        _salesLabel.text = @"促销";
        _salesLabel.font = PFR9Font;
        _salesLabel.textColor = [UIColor whiteColor];
        _salesLabel.hidden = YES;
        _salesLabel.textAlignment = NSTextAlignmentCenter;
        _salesLabel.backgroundColor = HEXCOLOR(0xF63019);
        _salesLabel.layer.cornerRadius = 2;
        _salesLabel.layer.masksToBounds = YES;
    }
    return _salesLabel;
}


- (UILabel *)groupPurchaseLabel{
    if (!_groupPurchaseLabel) {
        _groupPurchaseLabel = [[UILabel alloc] init];
        _groupPurchaseLabel.text = @"拼团";
        _groupPurchaseLabel.font = PFR9Font;
        _groupPurchaseLabel.textColor = HEXCOLOR(0xF3344A);
        _groupPurchaseLabel.textAlignment = NSTextAlignmentCenter;
        _groupPurchaseLabel.layer.cornerRadius = 2;
        _groupPurchaseLabel.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
        _groupPurchaseLabel.layer.borderWidth = 0.8;
        _groupPurchaseLabel.layer.masksToBounds = YES;
    }
    return _groupPurchaseLabel;
}



/**
 订单信息
 */
- (UIView *)orderInfoView{
    if (!_orderInfoView) {
        _orderInfoView = [[UIView alloc] init];
        _orderInfoView.backgroundColor = [UIColor whiteColor];
    }
    return _orderInfoView;
}


/**
 订单编号
 */
- (UILabel *)refundNoLabel{
    if (!_refundNoLabel) {
        _refundNoLabel = [[UILabel alloc] init];
        _refundNoLabel.text = @"退 款 编 号 ：";
        _refundNoLabel.font = [UIFont systemFontOfSize:13];
        _refundNoLabel.textColor = HEXCOLOR(0x333333);
        _refundNoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundNoLabel;
    
}

/**
 申请时间
 */
- (UILabel *)applyForTimeLabel{
    if (!_applyForTimeLabel) {
        _applyForTimeLabel = [[UILabel alloc] init];
        _applyForTimeLabel.text = @"申 请 时 间 ：";
        _applyForTimeLabel.font = [UIFont systemFontOfSize:13];
        _applyForTimeLabel.textColor = HEXCOLOR(0x333333);
        _applyForTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _applyForTimeLabel;
    
}
/**
 退款状态
 */
- (UILabel *)refundStateLabel{
    if (!_refundStateLabel) {
        _refundStateLabel = [[UILabel alloc] init];
        _refundStateLabel.text = @"退 款 状 态 ：";
        _refundStateLabel.font = [UIFont systemFontOfSize:13];
        _refundStateLabel.textColor = HEXCOLOR(0x333333);
        _refundStateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundStateLabel;
}
/**
 退款金额
 */
- (UILabel *)refundMoneyLabel{
    if (!_refundMoneyLabel) {
        _refundMoneyLabel = [[UILabel alloc] init];
        _refundMoneyLabel.text = @"退 款 现 金 ：";
        _refundMoneyLabel.font = [UIFont systemFontOfSize:13];
        _refundMoneyLabel.textColor = HEXCOLOR(0x333333);
        _refundMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundMoneyLabel;
}
/**
 退款运费
 */
- (UILabel *)refundFreightLabel{
    if (!_refundFreightLabel) {
        _refundFreightLabel = [[UILabel alloc] init];
        _refundFreightLabel.text = @"退 款 运 费 ：";
        _refundFreightLabel.font = [UIFont systemFontOfSize:13];
        _refundFreightLabel.textColor = HEXCOLOR(0x333333);
        _refundFreightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundFreightLabel;
}

/**
 退款抵扣券
 */
- (UILabel *)refundVoucherLabel{
    if (!_refundVoucherLabel) {
        _refundVoucherLabel = [[UILabel alloc] init];
        _refundVoucherLabel.text = @"退款抵扣券：";
        _refundVoucherLabel.font = [UIFont systemFontOfSize:13];
        _refundVoucherLabel.textColor = HEXCOLOR(0x333333);
        _refundVoucherLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundVoucherLabel;
}
/**
 退款注册券
 */
- (UILabel *)refundRegistrationVouchersLabel{
    if (!_refundRegistrationVouchersLabel) {
        _refundRegistrationVouchersLabel = [[UILabel alloc] init];
        _refundRegistrationVouchersLabel.text = @"退款注册券：";
        _refundRegistrationVouchersLabel.font = [UIFont systemFontOfSize:13];
        _refundRegistrationVouchersLabel.textColor = HEXCOLOR(0x333333);
        _refundRegistrationVouchersLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundRegistrationVouchersLabel;
}
- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.productView];
    [self.productView addSubview:self.imgLogo];
    [self.productView addSubview:self.moneyLabel];
    [self.productView addSubview:self.titleL];
    [self.productView addSubview:self.numLabel];
    [self.productView addSubview:self.rankLabel];
    //    [self addSubview:self.typeLabel];
    //    [self addSubview:self.salesLabel];
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(90);
    }];
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView).offset(15);
        make.left.equalTo(self.productView).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.productView).offset(-15);
        make.top.equalTo(self.imgLogo);
        make.height.mas_equalTo(18);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgLogo);
        make.left.equalTo(self.imgLogo.mas_right).offset(15);
        make.right.equalTo(self.moneyLabel.mas_left).offset(-15);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom);
    }];
    
    
    [self addSubview:self.orderInfoView];
    [self.orderInfoView addSubview:self.refundNoLabel];
    [self.orderInfoView addSubview:self.applyForTimeLabel];
    [self.orderInfoView addSubview:self.refundStateLabel];
    [self.orderInfoView addSubview:self.refundMoneyLabel];
    
    
    [self.orderInfoView addSubview:self.refundVoucherLabel];
    [self.orderInfoView addSubview:self.refundRegistrationVouchersLabel];
    [self.orderInfoView addSubview:self.refundFreightLabel];
    
    
    //frame
    
    [self.orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.height.mas_equalTo(230);
    }];
    
    [self.refundNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.orderInfoView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.applyForTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundNoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyForTimeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    [self.refundMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundStateLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundVoucherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundMoneyLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundRegistrationVouchersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundVoucherLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundFreightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundRegistrationVouchersLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    

}


- (void)setRefundDetailModel:(YunDianRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    self.numLabel.text = [NSString stringWithFormat:@"x%@",_refundDetailModel.productCount];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[_refundDetailModel.salePrice floatValue]];
    self.titleL.text = _refundDetailModel.productName;
    self.rankLabel.text = _refundDetailModel.specificationsName;
    [self.imgLogo sd_setImageWithURL:[_refundDetailModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
  
    
    self.refundNoLabel.text = [NSString stringWithFormat:@"退 款 编 号 ：%@", CHECK_STRING(_refundDetailModel.orderReturnId)];
    /**
     申请时间
     */
    self.applyForTimeLabel.text  = [NSString stringWithFormat:@"申 请 时 间 ：%@", _refundDetailModel.createDate];
    /**
     退款状态
     */
    if ([refundDetailModel.returnState integerValue] == 3) {
        [self label:self.refundStateLabel oristr:[NSString stringWithFormat:@"退 款 状 态 ：拒绝退款"] changestr:@"拒绝退款"];
    } else if ([refundDetailModel.returnState integerValue] == 1) {
        [self label:self.refundStateLabel oristr:[NSString stringWithFormat:@"退 款 状 态 ：退款中"] changestr:@"退款中"];
    } else if ([refundDetailModel.returnState integerValue] == 4) {
        [self label:self.refundStateLabel oristr:[NSString stringWithFormat:@"退 款 状 态 ：已退款"] changestr:@"已退款"];
    }else if ([refundDetailModel.returnState integerValue] == 2) {
        [self label:self.refundStateLabel oristr:[NSString stringWithFormat:@"退 款 状 态 ：取消退款"] changestr:@"取消退款"];
    } else {
        self.refundStateLabel.text = @"退 款 状 态 ：";
    }
 
    [self label:self.refundMoneyLabel oristr:[NSString stringWithFormat:@"退 款 现 金 ：%@",[NSString stringWithFormat:@"¥%.2f",[CHECK_STRING(_refundDetailModel.returnMoney) floatValue]]]  changestr:[NSString stringWithFormat:@"¥%.2f",[CHECK_STRING(_refundDetailModel.returnMoney) floatValue]]];
    
    [self label:self.refundVoucherLabel oristr:[NSString stringWithFormat:@"退款抵扣券：%@",[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.sysPrice) floatValue]]]  changestr:[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.sysPrice) floatValue]]];

    [self label:self.refundRegistrationVouchersLabel oristr:[NSString stringWithFormat:@"退款注册券：%@",[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.regCoupon) floatValue]]]  changestr:[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.regCoupon) floatValue]]];

    [self label:self.refundFreightLabel oristr:[NSString stringWithFormat:@"退 款 运 费 ：%@",[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.transportPrice) floatValue]]]  changestr:[NSString stringWithFormat:@"%.2f",[CHECK_STRING(_refundDetailModel.transportPrice) floatValue]]];
    
}
- (void)label:(UILabel *)label oristr:(NSString*)oristr changestr:(NSString *)changestr{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oristr];
    NSRange range1 = [[str string] rangeOfString:changestr];
    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF3344A) range:range1];
    label.attributedText = str;
}

@end
