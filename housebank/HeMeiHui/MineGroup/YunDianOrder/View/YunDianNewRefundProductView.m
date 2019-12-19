//
//  YunDianNewRefundProductView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundProductView.h"
#import "YunDianNewRefundOrderProductModel.h"
@implementation YunDianNewRefundProductView

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
        _productView.backgroundColor = HEXCOLOR(0xF5F5F5);
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

- (UIView *)hearderView{
    if (!_hearderView) {
        _hearderView = [[UIView alloc] init];
        _hearderView.backgroundColor = [UIColor whiteColor];
    }
    return _hearderView;
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
 一类 二类 三类 商品显示

 @return 是否有
 */
- (BOOL)oneTwoThereClass{
    BOOL isShow = NO;
    YunDianNewRefundOrderProductModel *productModel = (YunDianNewRefundOrderProductModel *)_refundDetailModel.orderProduct;
    switch ([productModel.productLevel integerValue]) {
        case 1:
            _typeLabel.hidden = NO;
            _typeLabel.text = @"Ⅰ类";

            _typeLabel.backgroundColor = HEXCOLOR(0xF63019);
            break;
        case 2:
            _typeLabel.hidden = NO;
            _typeLabel.text = @"Ⅱ类";
            _typeLabel.backgroundColor = HEXCOLOR(0xFF9900);

            break;
        case 3:
            _typeLabel.hidden = NO;
            _typeLabel.text = @"Ⅲ类";

            _typeLabel.backgroundColor = HEXCOLOR(0xB4B4B4);

            break;
            
        default:
            _typeLabel.hidden = YES;
            break;
    }
    return isShow;
}


- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    YunDianNewRefundOrderProductModel *productModel = (YunDianNewRefundOrderProductModel *)_refundDetailModel.orderProduct;

    [self.imgLogo sd_setImageWithURL:[productModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    /**
     标题
     */
    self.titleL.text = CHECK_STRING(productModel.productName);
    /**
     钱
     */
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", [productModel.salePrice floatValue]]];
    UIFont *font = [UIFont systemFontOfSize:10];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,1)];    
    self.moneyLabel.attributedText = attrString;
    /**
     数量
     */
    self.numLabel.text =  [NSString stringWithFormat:@"x%@", productModel.productCount];
    /**
     规格
     */
    self.rankLabel.text = CHECK_STRING(productModel.specifications);
  
    /**
     促销标签
     */
//    @property (nonatomic, strong) UILabel *salesLabel;
    /**
     拼团标签
     */
//    @property (nonatomic, strong) UILabel *groupPurchaseLabel;


   
    /**
     退款编号
     */
   self.refundNoLabel.text = [NSString stringWithFormat:@"退 款 编 号 ：%@", _refundDetailModel.refundNo];
    /**
     申请时间
     */
   self.applyForTimeLabel.text = [NSString stringWithFormat:@"申 请 时 间 ：%@", _refundDetailModel.createDate];

    /**
     退款现金
     */
    self.refundMoneyLabel.text = [NSString stringWithFormat:@"退 款 现 金 ：¥%.2f", [_refundDetailModel.returnMoney floatValue]];
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
//- (UILabel *)refundStateLabel{
//    if (!_refundStateLabel) {
//        _refundStateLabel = [[UILabel alloc] init];
//        _refundStateLabel.text = @"退 款 状 态 ：";
//        _refundStateLabel.font = [UIFont systemFontOfSize:13];
//        _refundStateLabel.textColor = HEXCOLOR(0x333333);
//        _refundStateLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _refundStateLabel;
//}
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
//- (UILabel *)refundFreightLabel{
//    if (!_refundFreightLabel) {
//        _refundFreightLabel = [[UILabel alloc] init];
//        _refundFreightLabel.text = @"退 款 运 费 ：";
//        _refundFreightLabel.font = [UIFont systemFontOfSize:13];
//        _refundFreightLabel.textColor = HEXCOLOR(0x333333);
//        _refundFreightLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _refundFreightLabel;
//}

/**
 退款抵扣券
 */
//- (UILabel *)refundVoucherLabel{
//    if (!_refundVoucherLabel) {
//        _refundVoucherLabel = [[UILabel alloc] init];
//        _refundVoucherLabel.text = @"退款抵扣券：";
//        _refundVoucherLabel.font = [UIFont systemFontOfSize:13];
//        _refundVoucherLabel.textColor = HEXCOLOR(0x333333);
//        _refundVoucherLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _refundVoucherLabel;
//}
/**
 退款注册券
 */
//- (UILabel *)refundRegistrationVouchersLabel{
//    if (!_refundRegistrationVouchersLabel) {
//        _refundRegistrationVouchersLabel = [[UILabel alloc] init];
//        _refundRegistrationVouchersLabel.text = @"退款注册券：";
//        _refundRegistrationVouchersLabel.font = [UIFont systemFontOfSize:13];
//        _refundRegistrationVouchersLabel.textColor = HEXCOLOR(0x333333);
//        _refundRegistrationVouchersLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    return _refundRegistrationVouchersLabel;
//}
- (void)setUI
{

    
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.hearderView];
    [self.hearderView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(50);

    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self.hearderView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *refundLabel = [[UILabel alloc] init];
    refundLabel.text = @"退款信息";
    refundLabel.font = [UIFont boldSystemFontOfSize:13];
    refundLabel.textColor = HEXCOLOR(0x333333);
    [self.hearderView addSubview:refundLabel];
    [refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(40);
    }];
    [self addSubview:self.productView];
    [self.productView addSubview:self.imgLogo];
    [self.productView addSubview:self.moneyLabel];
    [self.productView addSubview:self.titleL];
    [self.productView addSubview:self.numLabel];
    [self.productView addSubview:self.rankLabel];
    [self.productView addSubview:self.typeLabel];
    [self.productView addSubview:self.salesLabel];
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hearderView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(113);
    }];
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView).offset(10);
        make.left.equalTo(self.productView).offset(15);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
   
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgLogo);
        make.left.equalTo(self.imgLogo.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.right.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom);
    }];
     [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.titleL);
           make.top.equalTo(self.rankLabel.mas_bottom).offset(5);
           make.size.mas_equalTo(CGSizeMake(24, 12));
       }];
    
  [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         
      make.right.equalTo(self.productView).offset(-15);
      make.bottom.equalTo(self.productView).offset(-10);
      make.height.mas_equalTo(15);
      }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgLogo.mas_right).offset(10);
        make.centerY.equalTo(self.numLabel);
         make.height.mas_equalTo(15);
    }];
    

      
   
    
    
    [self addSubview:self.orderInfoView];
    [self.orderInfoView addSubview:self.refundNoLabel];
    [self.orderInfoView addSubview:self.applyForTimeLabel];
//    [self.orderInfoView addSubview:self.refundStateLabel];
    [self.orderInfoView addSubview:self.refundMoneyLabel];
    [self.orderInfoView addSubview:self.orderNoCopyLabel];

    
//    [self.orderInfoView addSubview:self.refundVoucherLabel];
//    [self.orderInfoView addSubview:self.refundRegistrationVouchersLabel];
//    [self.orderInfoView addSubview:self.refundFreightLabel];
    
    
    //frame
    
    [self.orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.productView.mas_bottom).offset(0);
        make.height.mas_equalTo(120);
    }];
    
    [self.refundMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.orderInfoView).offset(15);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
   
    
    [self.applyForTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundMoneyLabel.mas_bottom).offset(10);
        make.left.equalTo(self.refundNoLabel);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.top.equalTo(self.applyForTimeLabel.mas_bottom).offset(10);

    }];
    
    
    [self.orderNoCopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.refundNoLabel.mas_right).offset(10);
           make.centerY.equalTo(self.refundNoLabel);
           make.size.mas_equalTo(CGSizeMake(46, 20));
       }];
    
    
    
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
    if (!CHECK_STRING_ISNULL(_refundDetailModel.refundNo)) {
        
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        
        pastboard.string = [NSString stringWithFormat:@"%@",_refundDetailModel.refundNo];
        [SVProgressHUD showSuccessWithStatus:@"已复制到剪贴板!"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}
- (void)setIsRefuseRefund:(BOOL)isRefuseRefund{
    _isRefuseRefund = isRefuseRefund;
    if (_isRefuseRefund) {
        self.hearderView.hidden = _isRefuseRefund;
        [self.productView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(113);
        }];
    }
}

- (void)label:(UILabel *)label oristr:(NSString*)oristr changestr:(NSString *)changestr{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oristr];
    NSRange range1 = [[str string] rangeOfString:changestr];
    [str addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xF3344A) range:range1];
    label.attributedText = str;
}



@end
