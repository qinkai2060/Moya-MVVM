//
//  YunDianOrderDetailTableViewCell.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderDetailTableViewCell.h"

@implementation YunDianOrderDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatcellView];
    }
    return self;
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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imgLogo];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.titleL];
    [self addSubview:self.numLabel];
    [self addSubview:self.rankLabel];
//    [self addSubview:self.typeLabel];
//    [self addSubview:self.salesLabel];
    [self addSubview:self.refundLabel];
}
//商城 订单状态（1：待支付，2：待发货，3：待收货，4：退货中，5：已退货，6：已取消，7：已完成，8：已分润，9：已终止，10：已评价）

- (void)setProductModel:(YunDianorderDetailProductListModel *)productModel{
    _productModel = productModel;
    self.numLabel.text = [NSString stringWithFormat:@"x%@",CHECK_STRING(productModel.productCount)];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[productModel.salePrice floatValue]];
    self.titleL.text = CHECK_STRING(productModel.productName);
    self.rankLabel.text = CHECK_STRING(productModel.specifications);
    [self.imgLogo sd_setImageWithURL:[productModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
    
            if ([productModel.returnState isEqual:@(1)]) {
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"退款待处理";
            } else if ([productModel.returnState isEqual:@(4)]){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"已退款";
            } else if ([productModel.returnState isEqual:@(2)] ){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"取消退款";
            } else if ([productModel.returnState isEqual:@(3)]){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"商家拒绝";
            } else if ([productModel.returnState isEqual:@(5)]){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"退款待仲裁";
            }else if ([productModel.returnState isEqual:@(6)]){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"拒绝退款";
            } else if ([productModel.returnState isEqual:@(7)]){
                self.refundLabel.hidden = NO;
                self.refundLabel.text = @"已退款";
            } else {
                self.refundLabel.hidden = YES;
                self.refundLabel.text = @"";
            }
      
    
   

}
- (void)setDetailModel:(YunDianOrderListDetailModel *)detailModel{
    _detailModel = detailModel;
    self.titleL.text = CHECK_STRING(detailModel.shopsName);
    self.rankLabel.text = @"到店扫码消费";
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
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
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self.numLabel.mas_bottom);
        make.height.mas_equalTo(18);
    }];

    
}


@end
