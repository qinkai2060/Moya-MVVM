//
//  YunDianOrderListTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderListTableViewCell.h"
#import "JudgeOrderType.h"
@implementation YunDianOrderListTableViewCell

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
    [self.bgView addSubview:self.refundLabel];
    
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
    
    //    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.typeLabel.mas_right).offset(2);
    //        make.top.equalTo(self.typeLabel);
    //        make.size.mas_equalTo(CGSizeMake(24, 12));
    //    }];
    
    
    
    
    
}
- (void)setProductsModel:(YunDianOrderProductsModel *)productsModel{
    _productsModel = productsModel;
    [self.imgLogo sd_setImageWithURL:[_productsModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
    self.titleL.text = _productsModel.productName;
    
    self.numLabel.text = [NSString stringWithFormat:@"x%@",_productsModel.productCount];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[_productsModel.salePrice floatValue]]]];
    
    //规格
    if ([_productsModel.specifications isKindOfClass:[NSString class]]) {
        self.rankLabel.text = [NSString stringWithFormat:@"%@",_productsModel.specifications];
    } else {
        self.rankLabel.text = @"";
    }
    
    //显示 123 促销  无早等标签显示
    [self oneTwoThereClass];
    
    
    if (self.state < 4) {
        if ([_productsModel.returnState isEqual:@(1)]) {
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"退款待处理";
        } else if ([_productsModel.returnState isEqual:@(4)]){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"已退款";
        } else if ([_productsModel.returnState isEqual:@(2)] ){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"取消退款";
        } else if ([_productsModel.returnState isEqual:@(3)]){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"商家拒绝";
        } else if ([_productsModel.returnState isEqual:@(5)]){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"退款待仲裁";
        }else if ([_productsModel.returnState isEqual:@(6)]){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"拒绝退款";
        } else if ([_productsModel.returnState isEqual:@(7)]){
            self.refundLabel.hidden = NO;
            self.refundLabel.text = @"已退款";
        } else {
            self.refundLabel.hidden = YES;
            self.refundLabel.text = @"";
        }
    } else {
//        if ([_productsModel.returnState isEqual:@(5)]){
//            self.refundLabel.hidden = NO;
//            self.refundLabel.text = @"退款待仲裁";
//        }else if ([_productsModel.returnState isEqual:@(6)]){
//            self.refundLabel.hidden = NO;
//            self.refundLabel.text = @"拒绝退款";
//        } else if ([_productsModel.returnState isEqual:@(7)]){
//            self.refundLabel.hidden = NO;
//            self.refundLabel.text = @"已退款";
//        } else {
            self.refundLabel.hidden = YES;
            self.refundLabel.text = @"";

//        }
    }
    
}
- (void)setOrderListModel:(YunDianOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    self.titleL.text = _orderListModel.shopsName;
    self.rankLabel.text = @"到店扫码消费";
    
}
/**
 其他订单标签的显示
 */
//- (void)isShowOtherOrder{
//    //其他订单
//
//    BOOL isShow = [self oneTwoThereClass];
//
//    if ([_productModel.priceType integerValue] == 4) {
//        self.salesLabel.hidden = NO;
//        if (isShow) {
//            [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.typeLabel.mas_right).offset(2);
//                make.top.equalTo(self.typeLabel);
//                make.size.mas_equalTo(CGSizeMake(24, 12));
//            }];
//        } else {
//            [self.salesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(_typeLabel);
//            }];
//        }
//    } else {
//        self.salesLabel.hidden = YES;
//    }
//}
/**
 一类 二类 三类 商品显示
 
 @return 是否有
 */
- (BOOL)oneTwoThereClass{
    BOOL isShow = NO;
    switch ([_productsModel.productLevel integerValue]) {
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
