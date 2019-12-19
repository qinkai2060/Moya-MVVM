//
//  HFHighEndGoodsCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHighEndGoodsCell.h"
#import "HFTextCovertImage.h"
@implementation HFHighEndGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setupViews];
    }
    return self;
}
- (void)hh_setupViews {
     [self.contentView addSubview:self.goodsImageV];
     [self.contentView addSubview:self.goodsTitleLb];
     [self.contentView addSubview:self.goodsDescriptionLb];
      [self.contentView addSubview:self.typeLb];
     [self.contentView addSubview:self.tagLb];
   
     [self.contentView addSubview:self.goodsPriceLb];
     [self.contentView.layer addSublayer:self.gradientLayer];
     [self.contentView addSubview:self.plusBtn];
     [self.contentView addSubview:self.lineView];
}
- (void)dosomethingMessage {
    self.goodsImageV.image = [UIImage imageNamed:@"product_4"];
    self.goodsTitleLb.text = self.dataModel.productName;
    self.goodsDescriptionLb.text =  self.dataModel.shopName;

    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[ManagerTools imageURL:self.dataModel.imageUrl sizeSignStr:@"!SQ147"]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.goodsPriceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.dataModel.cashPrice] twoText:@""];
    [self.plusBtn setTitle:@"去抢购" forState:UIControlStateNormal];
    self.goodsImageV.frame = CGRectMake(15, 15, 120, 120);
    CGSize size = [self.goodsTitleLb sizeThatFits:CGSizeMake(0, 40)];
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+15, 15, ScreenW-self.goodsImageV.right-30, size.height);
    self.goodsDescriptionLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsTitleLb.bottom+5, ScreenW-self.goodsImageV.right-30, 15);
    self.gradientLayer.frame = CGRectMake(ScreenW-60-15, self.height-28-25, 60, 25);

    self.plusBtn.frame = self.gradientLayer.frame;
    self.goodsPriceLb.frame = CGRectMake(self.goodsImageV.right+15, self.height-15-19-15, self.plusBtn.left-self.goodsImageV.right-15-5, 15);
//    self.tagLb.text = @"促销";
//    self.typeLb.text = @"I类";

    
    if ([HFUntilTool productLevelStr:self.dataModel.productLevel].length == 0) {
        self.typeLb.hidden = YES;
    }else {
        if ([[HFUntilTool productLevelStr:self.dataModel.productLevel] isEqualToString:@"I"]) {
            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"F63019"];
        }else if ([[HFUntilTool productLevelStr:self.dataModel.productLevel] isEqualToString:@"II"]){
            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"FF9900"];
        }else {
            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"B4B4B4"];
        }
        self.typeLb.hidden = NO;
        self.typeLb.text = [NSString stringWithFormat:@"%@类",[HFUntilTool productLevelStr:self.dataModel.productLevel]];
    }
    if (self.dataModel.tag.length != 0&&self.dataModel.useRegisterCoupon == YES) {
        self.tagLb.hidden = NO;
        self.tagLb.text = @"可用注册券";
    }else {
        self.tagLb.hidden = YES;
        
    }
    CGSize promotionTagsize = [self.tagLb sizeThatFits:CGSizeMake(100, 15)];
    if (self.typeLb.hidden) {
        self.tagLb.frame = CGRectMake(self.goodsImageV.right+20, self.goodsPriceLb.top-15-5, promotionTagsize.width+10, 15);
        
    }else {
        self.typeLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsPriceLb.top-15-5, 24, 15);
        self.tagLb.frame = CGRectMake(self.typeLb.right+5, self.goodsPriceLb.top-15-5, promotionTagsize.width+10, 15);
    }
    self.typeLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsPriceLb.top-15-5, 24, 15);
    self.lineView.frame = CGRectMake(15, self.height-0.5, ScreenW-30, 0.5);
}
- (void)dosomethingMessage2 {
    self.goodsImageV.image = [UIImage imageNamed:@"product_4"];
    self.goodsTitleLb.text = @"价值3500元 GUCCI古驰黑色牛皮做";//self.dataModel.productName;
    self.goodsDescriptionLb.text =@"价值3500元 GUCCI古驰黑色牛皮做";//  self.dataModel.shopName;
    self.tagLb.text = @"促销";
    self.typeLb.text = @"I类";

//    if (self.dataModel.promotionPrice > 0) {
//        self.tagLb.hidden = NO;
//        if (self.dataModel.promotionTag.length == 0) {
//            self.tagLb.text = @"促销";
//        }else {
//            self.tagLb.text = self.dataModel.promotionTag;
//        }
//        if (self.typeLb.hidden) {
//            self.tagLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsDescriptionLb.bottom+5, 24, 15);
//        }else {
//            self.tagLb.frame = CGRectMake(self.typeLb.right+5, self.goodsDescriptionLb.bottom+5, 24, 15);
//        }
//    }else {
//        self.tagLb.hidden = YES;
//    }

    self.goodsPriceLb.attributedText = [HFTextCovertImage exchangeTextStyle:@"¥3500.00" twoText:@"¥3500"];
    [self.plusBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    self.goodsImageV.frame = CGRectMake(15, 15, 120, 120);
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+15, 15, ScreenW-self.goodsImageV.right-30, 40);
    self.goodsDescriptionLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsTitleLb.bottom+5, ScreenW-self.goodsImageV.right-30, 15);
//    self.typeLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsDescriptionLb.bottom+5, 24, 14);
//    self.tagLb.frame = CGRectMake(self.typeLb.right+5, self.goodsDescriptionLb.bottom+5, 24, 14);
    
    self.gradientLayer.frame = CGRectMake(ScreenW-70-15, self.height-28-25, 70, 25);
    self.plusBtn.frame = self.gradientLayer.frame;
    self.goodsPriceLb.frame = CGRectMake(self.goodsImageV.right+15, self.height-15-19-15, self.plusBtn.left-self.goodsImageV.right-15-5, 15);
    self.lineView.frame = CGRectMake(15, self.height-0.5, ScreenW-30, 0.5);
}
- (void)plusClick {
    if (self.didSelect) {
        self.didSelect(self.dataModel);
    }
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView =[[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _lineView;
}
- (UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [[UILabel alloc] init];
        _typeLb.backgroundColor = [UIColor colorWithHexString:@"F63019"];
        _typeLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _typeLb.font = [UIFont systemFontOfSize:9];
        _typeLb.textAlignment = NSTextAlignmentCenter;
        _typeLb.layer.cornerRadius = 2;
        _typeLb.layer.masksToBounds = YES;
    }
    return _typeLb;
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        _tagLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _tagLb.font = [UIFont systemFontOfSize:9];
        _tagLb.textAlignment = NSTextAlignmentCenter;
        _tagLb.layer.borderWidth = 1;
        _tagLb.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
        _tagLb.layer.cornerRadius = 2;
        _tagLb.layer.masksToBounds = YES;
    }
    return _tagLb;
}
- (UIButton *)plusBtn {
    if (!_plusBtn) {
        _plusBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_plusBtn setImage:[UIImage imageNamed:@"car_plussign"] forState:UIControlStateNormal];
//        [_plusBtn setImage:[UIImage imageNamed:@"car_plussign"] forState:UIControlStateDisabled];
        [_plusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _plusBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _plusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
//        [_plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
             _plusBtn.userInteractionEnabled = NO;
    }
    return _plusBtn;
}
- (UILabel *)goodsPriceLb {
    if (!_goodsPriceLb) {
        _goodsPriceLb = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _goodsPriceLb;
}
- (UILabel *)goodsDescriptionLb {
    if (!_goodsDescriptionLb) {
        _goodsDescriptionLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsDescriptionLb.font = [UIFont systemFontOfSize:12];
        _goodsDescriptionLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _goodsDescriptionLb;
}
- (UILabel *)goodsTitleLb {
    if (!_goodsTitleLb) {
        _goodsTitleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTitleLb.font = [UIFont boldSystemFontOfSize:15];
        _goodsTitleLb.numberOfLines = 2;
    }
    return _goodsTitleLb;
}
- (UIImageView *)goodsImageV {
    if (!_goodsImageV) {
        _goodsImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageV.image = [UIImage imageNamed:@"product_4"];
    }
    return _goodsImageV;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];


        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];//渐变数组
        gradientLayer.cornerRadius = 13;
        gradientLayer.masksToBounds = YES;
        _gradientLayer = gradientLayer;
        //        [self.layer addSublayer:gradientLayer];
    }
    return _gradientLayer;
}

@end
