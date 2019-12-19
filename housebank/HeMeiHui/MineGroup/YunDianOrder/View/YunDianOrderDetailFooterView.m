//
//  YunDianOrderDetailFooterView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderDetailFooterView.h"
#import "JudgeOrderType.h"
@interface YunDianOrderDetailFooterView()

/**
 待入账总计
 */
@property (nonatomic, strong) UILabel *totalRecordedLa;
/**
 商品总金额
 */
@property (nonatomic, strong) UILabel *goodsTotalMoneyLaLeft;
/**
平台佣金
 */
@property (nonatomic, strong) UILabel *platformCommissionLeft;

/**
 运费
 */
@property (nonatomic, strong) UILabel *freightLabelLeft;

/**
 抵扣券
 */
@property (nonatomic, strong) UILabel *voucherLabelLeft;

/**
 注册券
 */
@property (nonatomic, strong) UILabel *registrationVouchersLabelLeft;

/**
 现金
 */
@property (nonatomic, strong) UILabel *cashLabelLeft;

/**
 注册券下
 */
@property (nonatomic, strong) UILabel *registrationVoucherBottomLabelLeft;

/**
 商家应收现金
 */
@property (nonatomic, strong) UILabel * merchantCashLeftLabel;

@end

@implementation YunDianOrderDetailFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setDetailFooterModel:(YunDianOrderListDetailModel *)detailFooterModel{
    _detailFooterModel = detailFooterModel;
    
    [self makeUpNewUI];
    
    // 订单编号
    self.orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",_detailFooterModel.orderNo];
    //下单时间
    self.orderTimeLabel.text = CHECK_STRING_ISNULL(_detailFooterModel.orderCreatTime) ? @"下单时间：":[NSString stringWithFormat:@"下单时间：%@",  [JudgeOrderType timeStr1000:_detailFooterModel.orderCreatTime formatterType:@"yyyy-MM-dd HH:mm:ss"]];
    // 付款时间
    self.payTimeLabel.text = CHECK_STRING_ISNULL(_detailFooterModel.payDate) ?  @"付款时间：" : [NSString stringWithFormat:@"付款时间：%@",[JudgeOrderType timeStr1000:_detailFooterModel.payDate formatterType:@"yyyy-MM-dd HH:mm:ss"]];
    
    // 发货时间
    self.dispatchGoodsTLabel.text = CHECK_STRING_ISNULL(_detailFooterModel.deliverTime)? @"发货时间：": [NSString stringWithFormat:@"发货时间：%@",[JudgeOrderType timeStr1000:_detailFooterModel.deliverTime formatterType:@"yyyy-MM-dd HH:mm:ss"]];
    
    
    self.buyerRemark.text = CHECK_STRING_ISNULL(_detailFooterModel.remarks)? @"买家留言：": [NSString stringWithFormat:@"买家留言：%@",_detailFooterModel.remarks];
    //运费
    self.freightLabel.text = [NSString stringWithFormat:@"+￥%.2f",[_detailFooterModel.transportPrice floatValue]];
    
    //抵扣券
    self.voucherLabel.text = [NSString stringWithFormat:@"-￥%.2f",[_detailFooterModel.sysPrice floatValue]];
    
    // 注册券
    self.registrationVouchersLabel.text = [NSString stringWithFormat:@"-￥%.2f",[_detailFooterModel.regCoupon floatValue]];
    
    //现金
    self.cashLabel.text = [NSString stringWithFormat:@"￥%.2f",[_detailFooterModel.price floatValue]];
    
    //注册券下
    self.registrationVoucherBottomLabel.text = [NSString stringWithFormat:@"￥%.2f",[_detailFooterModel.regCoupon floatValue]];
    
    self.platformCommission.text = [NSString stringWithFormat:@"-￥%.2f",[_detailFooterModel.platformCommission floatValue]];
    
     self.merchantCash.text = [NSString stringWithFormat:@"￥%.2f",[_detailFooterModel.businessCashReceivable floatValue]];
    

}

- (void)setUI{
    UIView *cellBottow = [[UIView alloc] init];
    cellBottow.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellBottow];
    [cellBottow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    
    [self addSubview:self.orderInfoView];
    [self.orderInfoView addSubview:self.orderNoLabel];
    [self.orderInfoView addSubview:self.orderNoCopyLabel];
    [self.orderInfoView addSubview:self.orderTimeLabel];
    [self.orderInfoView addSubview:self.payTimeLabel];
    [self.orderInfoView addSubview:self.dispatchGoodsTLabel];
    [self.orderInfoView addSubview:self.buyerRemark];
    
    //frame
    [self.orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(cellBottow.mas_bottom).offset(10);
        make.height.mas_equalTo(171);
    }];
    
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.orderInfoView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.orderNoCopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNoLabel.mas_right).offset(10);
        make.centerY.equalTo(self.orderNoLabel);
        make.size.mas_equalTo(CGSizeMake(46, 20));
    }];
    
    [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.orderNoLabel);
        make.height.mas_equalTo(20);
    }];
    [self.payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderTimeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.orderNoLabel);
        make.height.mas_equalTo(20);
    }];
    [self.dispatchGoodsTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTimeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.orderNoLabel);
        make.height.mas_equalTo(20);
    }];
    [self.buyerRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dispatchGoodsTLabel.mas_bottom).offset(10);
        make.left.equalTo(self.orderNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.billView];
    [self.billView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(10);
        make.height.mas_equalTo(250);
    }];
    
    [self.billView addSubview:self.totalRecordedLa];
    [self.totalRecordedLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.billView).offset(15);
        make.top.equalTo(self.billView).offset(15);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.billView addSubview:self.goodsTotalMoneyLaLeft];
    [self.billView addSubview:self.goodsTotalMoneyLa];
    [self.goodsTotalMoneyLaLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalRecordedLa);
        make.top.equalTo(self.totalRecordedLa.mas_bottom).offset(18);
        make.height.mas_equalTo(20);
        
    }];
    [self.goodsTotalMoneyLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.billView).offset(-15);
        make.centerY.equalTo(self.goodsTotalMoneyLaLeft);
        make.height.mas_equalTo(20);
        
    }];
}

- (void)hiddenSomeLabel:(BOOL)show {
    self.voucherLabelLeft.hidden = !show;
    self.voucherLabel.hidden = !show;
    self.platformCommissionLeft.hidden = !show;
    self.platformCommission.hidden = !show;
    self.registrationVouchersLabelLeft.hidden = !show;
    self.registrationVouchersLabel.hidden = !show;
    self.cashLabelLeft.hidden = !show;
    self.cashLabel.hidden = !show;
    self.registrationVoucherBottomLabelLeft.hidden = !show;
    self.registrationVoucherBottomLabel.hidden = !show;
    if(![_detailFooterModel.sysPrice isNotNil] || [_detailFooterModel.sysPrice isEqualToString:@"0"]){
        self.voucherLabel.hidden = YES;
        self.voucherLabelLeft.hidden = YES;
    }
}

- (void)addUpdateStore{
    /**
     福利订单、直供订单、RM礼包订单、代理订单
     显示商品成本（订单中商品成本价的总和）
     不显示平台佣金。抵扣券
     */

    if([_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_WELFARE_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_DIRECT_SUPPLY_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_REGISTRATION_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_PROXY_REG_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_UPREGISTRATION_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_RM_GIFT_PACKS_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_BIZ_AGENT_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_VIP_WHOLESALE_ORDER"] ||
       [_detailFooterModel.orderBizCategory isEqualToString:@"P_VIP_GIFT_ORDER"]){
        self.goodsTotalMoneyLaLeft.text = @"商品成本";
        self.goodsTotalMoneyLa.text = [NSString stringWithFormat:@"+￥%.2f",[_detailFooterModel.costPrice floatValue]];
        self.totalRecordedLa.text = @"预计收益";
        [self hiddenSomeLabel:NO];
        
    }else {
        [self hiddenSomeLabel:YES];
        
        if ([_detailFooterModel.orderState isEqualToString:@"7"] || [_detailFooterModel.orderState isEqualToString:@"8"]) {
            self.totalRecordedLa.text = @"收益总计";
        }else {
            self.totalRecordedLa.text = @"预计收益";
        }
        //商品总金额
        self.goodsTotalMoneyLaLeft.text = @"商品总额";
        self.goodsTotalMoneyLa.text = [NSString stringWithFormat:@"￥%.2f",[_detailFooterModel.orderPrice floatValue]];
    }
}

#pragma mark -- 根据OTO 和 商城，显示的界面不通 1:商城
- (void)makeUpNewUI {
    
    if ([self.detailFooterModel.shopsType integerValue] == 1) {
        
        // 运费
        [self.billView addSubview:self.freightLabelLeft];
        [self.billView addSubview:self.freightLabel];
        [self.freightLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.goodsTotalMoneyLaLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.freightLabelLeft);
            make.height.mas_equalTo(20);
            
        }];

        [self.billView addSubview:self.voucherLabelLeft];
        [self.billView addSubview:self.voucherLabel];
        [self.voucherLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.freightLabelLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.voucherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.voucherLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        // 平台佣金
        [self.billView addSubview:self.platformCommissionLeft];
        [self.billView addSubview:self.platformCommission];
        [self.platformCommissionLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.voucherLabelLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        
        
        if(![_detailFooterModel.sysPrice isNotNil] || [_detailFooterModel.sysPrice isEqualToString:@"0"]){
            self.voucherLabel.hidden = YES;
            self.voucherLabelLeft.hidden = YES;
            [self.platformCommissionLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.freightLabelLeft.mas_bottom).offset(10);
                make.height.mas_equalTo(20);
                make.left.equalTo(self.totalRecordedLa);
            }];
        }
        
        [self.platformCommission mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.platformCommissionLeft);
            make.height.mas_equalTo(20);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEXCOLOR(0xE5E5E5);
        [self.billView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.right.equalTo(self.goodsTotalMoneyLa);
            make.top.equalTo(self.platformCommissionLeft.mas_bottom).offset(15);
            make.height.mas_equalTo(0.7);
        }];
        
        // 商家应收现金
        [self.billView addSubview:self.merchantCashLeftLabel];
        [self.billView addSubview:self.merchantCash];
        
        [self.merchantCashLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(line.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.merchantCash mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.merchantCashLeftLabel);
            make.height.mas_equalTo(20);
        }];
        
        [self addUpdateStore];
        
    }else {
        [self.billView addSubview:self.freightLabelLeft];
        [self.billView addSubview:self.freightLabel];
        [self.freightLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.goodsTotalMoneyLaLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.freightLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        [self.billView addSubview:self.voucherLabelLeft];
        [self.billView addSubview:self.voucherLabel];
        [self.voucherLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.freightLabelLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.voucherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.voucherLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        
        [self.billView addSubview:self.registrationVouchersLabelLeft];
        [self.billView addSubview:self.registrationVouchersLabel];
        [self.registrationVouchersLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.voucherLabelLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
    
        
        [self.registrationVouchersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.registrationVouchersLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEXCOLOR(0xE5E5E5);
        [self.billView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.right.equalTo(self.goodsTotalMoneyLa);
            make.top.equalTo(self.registrationVouchersLabelLeft.mas_bottom).offset(15);
            make.height.mas_equalTo(0.7);
        }];
        
        [self.billView addSubview:self.cashLabelLeft];
        [self.billView addSubview:self.cashLabel];
        [self.cashLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(line.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.cashLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        [self.billView addSubview:self.registrationVoucherBottomLabelLeft];
        [self.billView addSubview:self.registrationVoucherBottomLabel];
        [self.registrationVoucherBottomLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalRecordedLa);
            make.top.equalTo(self.cashLabelLeft.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        [self.registrationVoucherBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.billView).offset(-15);
            make.centerY.equalTo(self.registrationVoucherBottomLabelLeft);
            make.height.mas_equalTo(20);
            
        }];
        
        self.goodsTotalMoneyLa.text = [NSString stringWithFormat:@"￥%.2f",[_detailFooterModel.orderPrice floatValue]];
      }
}
/**
 物流试图
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
- (UILabel *)orderNoLabel{
    if (!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc] init];
        //        _orderNoLabel.text = @"订单编号：9283198903128981";
        _orderNoLabel.font = [UIFont systemFontOfSize:13];
        _orderNoLabel.textColor = HEXCOLOR(0x333333);
        _orderNoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNoLabel;
    
}
- (UILabel *)orderNoCopyLabel{
    if (!_orderNoCopyLabel) {
        _orderNoCopyLabel = [[UILabel alloc] init];
        _orderNoCopyLabel.text = @"复制";
        _orderNoCopyLabel.font = [UIFont systemFontOfSize:13];
        _orderNoCopyLabel.textColor = HEXCOLOR(0x666666);
        _orderNoCopyLabel.textAlignment = NSTextAlignmentCenter;
        _orderNoCopyLabel.layer.cornerRadius = 10;
        _orderNoCopyLabel.userInteractionEnabled = YES;
        _orderNoCopyLabel.layer.borderWidth = 0.5;
        _orderNoCopyLabel.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        
        UITapGestureRecognizer *tapCopy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCopyAction)];
        [_orderNoCopyLabel addGestureRecognizer:tapCopy];
    }
    return _orderNoCopyLabel;
}
- (void)tapCopyAction{
    if (!CHECK_STRING_ISNULL(_detailFooterModel.orderNo)) {
        
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        
        pastboard.string = _detailFooterModel.orderNo;
        [SVProgressHUD showSuccessWithStatus:@"已复制到剪贴板!"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}
/**
 下单时间
 */
- (UILabel *)orderTimeLabel{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        //        _orderTimeLabel.text = @"下单时间：2018-06-14 11:28:32";
        _orderTimeLabel.font = [UIFont systemFontOfSize:13];
        _orderTimeLabel.textColor = HEXCOLOR(0x333333);
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderTimeLabel;
    
}
/**
 付款时间
 */
- (UILabel *)payTimeLabel{
    if (!_payTimeLabel) {
        _payTimeLabel = [[UILabel alloc] init];
        //        _payTimeLabel.text = @"付款时间：2018-06-14 11:28:32";
        _payTimeLabel.font = [UIFont systemFontOfSize:13];
        _payTimeLabel.textColor = HEXCOLOR(0x333333);
        _payTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _payTimeLabel;
}
/**
 发货时间
 */
- (UILabel *)dispatchGoodsTLabel{
    if (!_dispatchGoodsTLabel) {
        _dispatchGoodsTLabel = [[UILabel alloc] init];
        //        _dispatchGoodsTLabel.text = @"发货时间：2018-06-14 11:28:32";
        _dispatchGoodsTLabel.font = [UIFont systemFontOfSize:13];
        _dispatchGoodsTLabel.textColor = HEXCOLOR(0x333333);
        _dispatchGoodsTLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dispatchGoodsTLabel;
}
//买家留言
- (UILabel *)buyerRemark{
    if (!_buyerRemark) {
        _buyerRemark = [[UILabel alloc] init];
    
        _buyerRemark.font = [UIFont systemFontOfSize:13];
        _buyerRemark.textColor = HEXCOLOR(0x333333);
        _buyerRemark.textAlignment = NSTextAlignmentLeft;
    }
    return _buyerRemark;
}

- (UIView *)billView{
    if (!_billView) {
        _billView = [[UIView alloc] init];
        _billView.backgroundColor = [UIColor whiteColor];
    }
    return _billView;
}
/**
 待入账总计
 */
- (UILabel *)totalRecordedLa{
    if (!_totalRecordedLa) {
        _totalRecordedLa = [[UILabel alloc] init];
        _totalRecordedLa.text = @"待入账总计";
        _totalRecordedLa.font = [UIFont boldSystemFontOfSize:14];
        _totalRecordedLa.textColor = HEXCOLOR(0x333333);
        _totalRecordedLa.textAlignment = NSTextAlignmentLeft;
    }
    return _totalRecordedLa;
}
/**
 商品总金额
 */
- (UILabel *)goodsTotalMoneyLaLeft{
    if (!_goodsTotalMoneyLaLeft) {
        _goodsTotalMoneyLaLeft = [[UILabel alloc] init];
        _goodsTotalMoneyLaLeft.text = @"商品总额";
        _goodsTotalMoneyLaLeft.font = [UIFont systemFontOfSize:13];
        _goodsTotalMoneyLaLeft.textColor = HEXCOLOR(0x333333);
        _goodsTotalMoneyLaLeft.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsTotalMoneyLaLeft;
}

- (UILabel *)goodsTotalMoneyLa{
    if (!_goodsTotalMoneyLa) {
        _goodsTotalMoneyLa = [[UILabel alloc] init];
        //        _goodsTotalMoneyLa.text = @"￥3218.00";
        _goodsTotalMoneyLa.font = [UIFont systemFontOfSize:13];
        _goodsTotalMoneyLa.textColor = HEXCOLOR(0x333333);
        _goodsTotalMoneyLa.textAlignment = NSTextAlignmentRight;
    }
    return _goodsTotalMoneyLa;
}

- (UILabel *)platformCommissionLeft {
    if (!_platformCommissionLeft) {
        _platformCommissionLeft = [[UILabel alloc] init];
        _platformCommissionLeft.text = @"平台佣金 ";
        _platformCommissionLeft.font = [UIFont systemFontOfSize:13];
        _platformCommissionLeft.textColor = HEXCOLOR(0x333333);
        _platformCommissionLeft.textAlignment = NSTextAlignmentLeft;
    }
    return _platformCommissionLeft;
}

- (UILabel *)platformCommission {
    if (!_platformCommission) {
        _platformCommission = [[UILabel alloc] init];
        _platformCommission.font = [UIFont systemFontOfSize:13];
        _platformCommission.textColor = HEXCOLOR(0x333333);
        _platformCommission.textAlignment = NSTextAlignmentRight;
    }
    return _platformCommission;
}

/**
 运费
 */
- (UILabel *)freightLabelLeft{
    if (!_freightLabelLeft) {
        _freightLabelLeft = [[UILabel alloc] init];
        _freightLabelLeft.text = @"运费";
        _freightLabelLeft.font = [UIFont systemFontOfSize:13];
        _freightLabelLeft.textColor = HEXCOLOR(0x333333);
        _freightLabelLeft.textAlignment = NSTextAlignmentLeft;
    }
    return _freightLabelLeft;
}
- (UILabel *)freightLabel{
    if (!_freightLabel) {
        _freightLabel = [[UILabel alloc] init];
        //        _freightLabel.text = @"￥18.00";
        _freightLabel.font = [UIFont systemFontOfSize:13];
        _freightLabel.textColor = HEXCOLOR(0x333333);
        _freightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _freightLabel;
}

/**
 抵扣券
 */
- (UILabel *)voucherLabelLeft{
    if (!_voucherLabelLeft) {
        _voucherLabelLeft = [[UILabel alloc] init];
        _voucherLabelLeft.text = @"抵扣券";
        _voucherLabelLeft.font = [UIFont systemFontOfSize:13];
        _voucherLabelLeft.textColor = HEXCOLOR(0x333333);
        _voucherLabelLeft.textAlignment = NSTextAlignmentRight;
    }
    return _voucherLabelLeft;
}
- (UILabel *)voucherLabel{
    if (!_voucherLabel) {
        _voucherLabel = [[UILabel alloc] init];
        //        _voucherLabel.text = @"￥19.00";
        _voucherLabel.font = [UIFont systemFontOfSize:13];
        _voucherLabel.textColor = HEXCOLOR(0x333333);
        _voucherLabel.textAlignment = NSTextAlignmentRight;
    }
    return _voucherLabel;
}


/**
 注册券
 */
- (UILabel *)registrationVouchersLabelLeft{
    if (!_registrationVouchersLabelLeft) {
        _registrationVouchersLabelLeft = [[UILabel alloc] init];
        _registrationVouchersLabelLeft.text = @"注册券";
        _registrationVouchersLabelLeft.font = [UIFont systemFontOfSize:13];
        _registrationVouchersLabelLeft.textColor = HEXCOLOR(0x333333);
        _registrationVouchersLabelLeft.textAlignment = NSTextAlignmentRight;
    }
    return _registrationVouchersLabelLeft;
}
- (UILabel *)registrationVouchersLabel{
    if (!_registrationVouchersLabel) {
        _registrationVouchersLabel = [[UILabel alloc] init];
        //        _registrationVouchersLabel.text = @"￥14.00";
        _registrationVouchersLabel.font = [UIFont systemFontOfSize:13];
        _registrationVouchersLabel.textColor = HEXCOLOR(0x333333);
        _registrationVouchersLabel.textAlignment = NSTextAlignmentRight;
    }
    return _registrationVouchersLabel;
}

/**
 现金
 */
- (UILabel *)cashLabelLeft{
    if (!_cashLabelLeft) {
        _cashLabelLeft = [[UILabel alloc] init];
        _cashLabelLeft.text = @"现金";
        _cashLabelLeft.font = [UIFont boldSystemFontOfSize:13];
        _cashLabelLeft.textColor = HEXCOLOR(0x333333);
        _cashLabelLeft.textAlignment = NSTextAlignmentRight;
    }
    return _cashLabelLeft;
}
- (UILabel *)cashLabel{
    if (!_cashLabel) {
        _cashLabel = [[UILabel alloc] init];
        //        _cashLabel.text = @"￥1.00";
        _cashLabel.font = [UIFont boldSystemFontOfSize:13];
        _cashLabel.textColor = HEXCOLOR(0xFF0000);
        _cashLabel.textAlignment = NSTextAlignmentRight;
    }
    return _cashLabel;
}

/**
 注册券下
 */
- (UILabel *)registrationVoucherBottomLabelLeft{
    if (!_registrationVoucherBottomLabelLeft) {
        _registrationVoucherBottomLabelLeft = [[UILabel alloc] init];
        _registrationVoucherBottomLabelLeft.text = @"注册券";
        _registrationVoucherBottomLabelLeft.font = [UIFont boldSystemFontOfSize:13];
        _registrationVoucherBottomLabelLeft.textColor = HEXCOLOR(0x333333);
        _registrationVoucherBottomLabelLeft.textAlignment = NSTextAlignmentRight;
    }
    return _registrationVoucherBottomLabelLeft;
}
- (UILabel *)registrationVoucherBottomLabel{
    if (!_registrationVoucherBottomLabel) {
        _registrationVoucherBottomLabel = [[UILabel alloc] init];
        //        _registrationVoucherBottomLabel.text = @"￥2.00";
        _registrationVoucherBottomLabel.font = [UIFont boldSystemFontOfSize:13];
        _registrationVoucherBottomLabel.textColor = HEXCOLOR(0xFF0000);
        _registrationVoucherBottomLabel.textAlignment = NSTextAlignmentRight;
    }
    return _registrationVoucherBottomLabel;
}

- (UILabel *)merchantCashLeftLabel {
    if (!_merchantCashLeftLabel) {
        _merchantCashLeftLabel = [[UILabel alloc] init];
        _merchantCashLeftLabel.text = @"商家应收现金";
        _merchantCashLeftLabel.font = [UIFont boldSystemFontOfSize:13];
        _merchantCashLeftLabel.textColor = HEXCOLOR(0x333333);
        _merchantCashLeftLabel.textAlignment = NSTextAlignmentRight;
    }
    return _merchantCashLeftLabel;
}

- (UILabel *)merchantCash {
    if (!_merchantCash) {
        _merchantCash = [[UILabel alloc] init];
        _merchantCash.font = [UIFont boldSystemFontOfSize:13];
        _merchantCash.textColor = HEXCOLOR(0xFF0000);
        _merchantCash.textAlignment = NSTextAlignmentRight;
    }
    return _merchantCash;
}
@end
