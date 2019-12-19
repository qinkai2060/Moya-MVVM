//
//  HFFamousCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFFamousCell.h"
#import "HFTextCovertImage.h"
@implementation HFFamousCell
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
    self.goodsDescriptionLb.text =  self.dataModel.productSubtitle;
    CGSize titlesize = [self.goodsTitleLb sizeThatFits:CGSizeMake(0, 40)];
    
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[ManagerTools imageURL:self.dataModel.productImage sizeSignStr:@"!SQ147"]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
   
    if (self.dataModel.promotionPrice <= 0) {
    
        self.goodsPriceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.dataModel.cashPrice] twoText:@""];
    }else {
          self.goodsPriceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[NSString stringWithFormat:@"%@ ",[HFUntilTool thousandsFload:self.dataModel.promotionPrice]] twoText:[NSString stringWithFormat:@"%.02f",self.dataModel.cashPrice]];
    }
    [self.plusBtn setTitle:@"去抢购" forState:UIControlStateNormal];
    self.goodsImageV.frame = CGRectMake(15, 15, 120, 120);
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+15, 15, ScreenW-self.goodsImageV.right-30, titlesize.height);
    self.goodsDescriptionLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsTitleLb.bottom+5, ScreenW-self.goodsImageV.right-30, 15);
    self.gradientLayer.frame = CGRectMake(ScreenW-60-15, self.height-28-25, 60, 25);
    self.plusBtn.frame = self.gradientLayer.frame;
    self.goodsPriceLb.frame = CGRectMake(self.goodsImageV.right+15, self.height-15-19-15, self.plusBtn.left-self.goodsImageV.right-15-5, 15);
  //  if ([HFUntilTool productLevelStr:self.dataModel.productLevel].length == 0) {
        self.typeLb.hidden = YES;
//    }else {
//        if ([[HFUntilTool productLevelStr:self.dataModel.productLevel] isEqualToString:@"I"]) {
//            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"F63019"];
//        }else if ([[HFUntilTool productLevelStr:self.dataModel.productLevel] isEqualToString:@"II"]){
//            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"FF9900"];
//        }else {
//            self.typeLb.backgroundColor = [UIColor colorWithHexString:@"B4B4B4"];
//        }
//        self.typeLb.hidden = NO;
//        self.typeLb.text = [NSString stringWithFormat:@"%@类",[HFUntilTool productLevelStr:self.dataModel.productLevel]];
//
//    }
    if (self.dataModel.promotionTag.length != 0 &&![self.dataModel.promotionTag isEqualToString:@"<null>"] ) {
        self.tagLb.hidden = NO;
        self.tagLb.text = self.dataModel.promotionTag;
    }else {
        self.tagLb.hidden = YES;
    }
     CGSize size = [self.tagLb sizeThatFits:CGSizeMake(120, 15)];
    if (self.typeLb.hidden) {
       
        self.tagLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsPriceLb.top-15-5, size.width+10, 15);
    }else {
        self.typeLb.frame = CGRectMake(self.goodsImageV.right+15, self.goodsPriceLb.top-15-5, 24, 15);
        self.tagLb.frame = CGRectMake(self.typeLb.right+5, self.goodsPriceLb.top-15-5, size.width+10, 15);
    }
    self.lineView.frame = CGRectMake(15, self.height-0.5, ScreenW-30, 0.5);
}
- (NSString *)positiveFormat:(NSString *)text{
//    if(!text || [text floatValue] == 0){
//        return @"0.00";
//    }
//    if (text.floatValue < 1000) {
//        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
//    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}
-(NSString *)ChangeNumberFormat:(NSString *)num
{
    if (num == nil) {
        return @"";
    }
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
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
        _tagLb.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        _tagLb.textColor = [UIColor whiteColor];
        _tagLb.font = [UIFont systemFontOfSize:9];
        _tagLb.textAlignment = NSTextAlignmentCenter;
//        _tagLb.layer.borderWidth = 1;
//        _tagLb.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
        _tagLb.layer.cornerRadius = 2;
        _tagLb.layer.masksToBounds = YES;
        _tagLb.hidden = YES;
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
