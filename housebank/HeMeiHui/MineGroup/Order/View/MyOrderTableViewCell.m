//
//  MyOrderTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "JudgeOrderType.h"
@implementation MyOrderTableViewCell
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
        _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store"]];
        _imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgLogo;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"Lenovo/联想 小新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…新潮7000 i5笔记本电脑 轻薄便捷 学生超薄…";
        _titleL.font = PFR12Font;
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
        _moneyLabel.textColor = HEXCOLOR(0x333333);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
    
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"x1";
        _numLabel.font = PFR12Font;
        _numLabel.textColor = HEXCOLOR(0x333333);
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
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
- (UILabel *)mornLabel{
    if (!_mornLabel) {
        _mornLabel = [[UILabel alloc] init];
        _mornLabel.text = @"无早";
        _mornLabel.font = PFR9Font;
        _mornLabel.textColor = HEXCOLOR(0xF3344A);
        _mornLabel.hidden = YES;
        _mornLabel.textAlignment = NSTextAlignmentCenter;
        _mornLabel.layer.cornerRadius = 2;
        _mornLabel.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
        _mornLabel.layer.borderWidth = 0.8;
        _mornLabel.layer.masksToBounds = YES;
    }
    return _mornLabel;
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
- (UILabel *)refundLabel{
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.text = @"退款中";
        _refundLabel.font = PFR12Font;
        _refundLabel.textColor = HEXCOLOR(0x333333);
        _refundLabel.textAlignment = NSTextAlignmentRight;
    }
    return _refundLabel;
}
- (void)creatcellView
{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.imgLogo];
    [self.bgView addSubview:self.moneyLabel];
    [self.bgView addSubview:self.titleL];
    [self.bgView addSubview:self.numLabel];
    [self.bgView addSubview:self.rankLabel];
    [self.bgView addSubview:self.typeLabel];
    [self.bgView addSubview:self.salesLabel];
//    [self.bgView addSubview:self.groupPurchaseLabel];
    [self.bgView addSubview:self.refundLabel];
    [self.bgView addSubview:self.mornLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.bottom.equalTo(self);
    }];
    
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(5);
        make.left.equalTo(self.bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.imgLogo);
        make.height.mas_equalTo(15);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgLogo);
        make.left.equalTo(self.imgLogo.mas_right).offset(10);
        make.right.equalTo(self.moneyLabel.mas_left).offset(-10);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom).offset(5);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self.numLabel.mas_bottom).offset(5);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleL);
        make.top.equalTo(self.rankLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(24, 12));
    }];
    
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(2);
        make.top.equalTo(self.typeLabel);
        make.size.mas_equalTo(CGSizeMake(24, 12));
    }];

    [self.mornLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_typeLabel);
    }];
    
//    [self.groupPurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.salesLabel.mas_right).offset(2);
//        make.top.equalTo(self.typeLabel);
//        make.size.mas_equalTo(CGSizeMake(24, 12));
//    }];
    
}
//除全球家订单的所有cell - model
- (void)setProductModel:(MyOrderProductListModel *)productModel{
    _productModel = productModel;
    [self.imgLogo sd_setImageWithURL:[_productModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
   
    self.titleL.text = productModel.productName;
  //订单状态(1待支付 2待发货 3待收货 4退货中 5已退货 6已取消 7已完成 8已分润 9已终止 10已评价)'
    if ([productModel.orderState integerValue] == 4) {
        self.refundLabel.hidden = NO;
        self.refundLabel.text = @"退款中";
    } else if ([productModel.orderState integerValue] == 5){
        self.refundLabel.hidden = NO;
        self.refundLabel.text = @"已退款";
    } else if ([productModel.state isEqual:@(1)] ){
        self.refundLabel.hidden = NO;
        self.refundLabel.text = @"取消退款";
    } else if ([productModel.state isEqual:@(0)] && [productModel.arbitrateState isEqual:@(2)]){
        self.refundLabel.hidden = NO;
        self.refundLabel.text = @"拒绝退款";
    } else {
        self.refundLabel.hidden = YES;
        self.refundLabel.text = @"";
    }
    
    if ([JudgeOrderType judgeGlobalHomeOrderType:productModel.orderBizCategory]) {
        //全球家订单没有金额与数量
        self.numLabel.text = @"";
        self.moneyLabel.text = @"";
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"x%@",productModel.productCount];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[productModel.salePrice floatValue]]]];
    }
    //规格
    if ([productModel.specifications isKindOfClass:[NSString class]]) {
        self.rankLabel.text = [NSString stringWithFormat:@"%@",CHECK_STRING(productModel.specifications)];
    } else {
        self.rankLabel.text = @"";
    }
    
    //显示 123 促销  无早等标签显示
    [self isShowOtherOrder];
   
}

/**
 全球家model

 @param infoListModel 因为后台s给的数据问题 所以要在这个model中取值
 */
- (void)setInfoListModel:(OrderInfoListModel *)infoListModel{
    _infoListModel = infoListModel;
    self.refundLabel.hidden = YES;
    self.numLabel.text = @"";
    self.moneyLabel.text = @"";
    self.titleL.text = infoListModel.houseTitle;
    self.rankLabel.text = [NSString stringWithFormat:@"%@ - %@ 共%@晚", [JudgeOrderType timeStr:_infoListModel.bookCheckinTime],[JudgeOrderType timeStr:_infoListModel.checkoutTime],_infoListModel.accommodationDays];

    [self.imgLogo sd_setImageWithURL:[_infoListModel.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    [self isGlobalHomeShowTag];
}

/**
 全球家订单标签显示
 */
- (void)isGlobalHomeShowTag{
 
        //全球家订单
        _mornLabel.hidden = NO;
        self.salesLabel.hidden = YES;
        self.typeLabel.hidden = YES;
        
        switch ([_infoListModel.breakfast integerValue]) {
            case 1:
            {
                _mornLabel.text = @"含早";
                
            }
                break;
            case 2:
            {
                _mornLabel.text = @"单早";
                
            }
                break;
                
            default:
                _mornLabel.text = @"无早";
                
                break;
        }
}

/**
 其他订单标签的显示
 */
- (void)isShowOtherOrder{
    //其他订单
    _mornLabel.hidden = YES;
    
    BOOL isShow = [self oneTwoThereClass];
    
    if ([_productModel.priceType integerValue] == 4) {
        self.salesLabel.hidden = NO;
        if (isShow) {
            [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeLabel.mas_right).offset(2);
                make.top.equalTo(self.typeLabel);
                make.size.mas_equalTo(CGSizeMake(24, 12));
            }];
        } else {
            [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_typeLabel);
            }];
        }
    } else {
        self.salesLabel.hidden = YES;
    }
}
/**
 一类 二类 三类 商品显示

 @return 是否有
 */
- (BOOL)oneTwoThereClass{
    BOOL isShow = NO;
    switch ([_productModel.productLevel integerValue]) {
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


@end
