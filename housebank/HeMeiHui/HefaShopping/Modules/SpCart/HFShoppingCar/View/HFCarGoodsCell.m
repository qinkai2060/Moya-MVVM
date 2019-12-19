//
//  HFCarGoodsCell.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarGoodsCell.h"

@interface HFCarGoodsCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *goodsDescriptionLb;
@property (nonatomic,strong) UILabel *goodsPriceLb;
@property (nonatomic,strong) UILabel *purchaseLimitationLb;// 限购
@property (nonatomic,strong) UIButton *plusBtn;
@property (nonatomic,strong) UIButton *minusBtn;
@property (nonatomic,strong) UITextField *goodsCountTF;
//@property (nonatomic,strong) UIButton *goodsResetSelectBtn;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) UILabel *typeLb;
@end
@implementation HFCarGoodsCell
+ (void)load {
    [super registerRenderCell:[HFCarGoodsCell class] messageType:1];
}
- (void)yd_setupViews {
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.goodsImageV];
    [self.contentView addSubview:self.goodsTitleLb];
    [self.contentView addSubview:self.goodsDescriptionLb];
    [self.contentView addSubview:self.purchaseLimitationLb];
    [self.contentView addSubview:self.goodsPriceLb];
    [self.contentView addSubview:self.plusBtn];
    [self.contentView addSubview:self.goodsCountTF];
    [self.contentView addSubview:self.minusBtn];
    [self.contentView addSubview:self.tagLb];
    [self.contentView addSubview:self.typeLb];
}
- (NSInteger)getTextFiledShoppingCount {
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    if (![numberPredicate evaluateWithObject:self.goodsCountTF.text]) {
          [MBProgressHUD showAutoMessage:@"输入有误"];
        if (self.dataModel.purchaseLimitation!=0) {
             self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",self.dataModel.purchaseLimitation];
        }else {
             self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",self.dataModel.stock];
        }
       
    }
    return [self.goodsCountTF.text integerValue];
}
- (void)doMessageRendering {
    [self recoveryData];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[ManagerTools imageURL:self.dataModel.productPic sizeSignStr:@"!SQ147"]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.goodsTitleLb.text = self.dataModel.title;
    self.selectBtn.frame = CGRectMake(0, (self.dataModel.rowHeight-40)*0.5, 40, 40);
    self.goodsImageV.frame = CGRectMake(self.selectBtn.right+10, (self.dataModel.rowHeight-90)*0.5, 70, 90);
    CGSize size =  [self.goodsTitleLb sizeThatFits:CGSizeMake(ScreenW-self.goodsImageV.right-20-15, 40)];
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+20, self.goodsImageV.top, size.width, size.height);
    self.goodsDescriptionLb.text = self.dataModel.typeTitle;
    CGSize descSize =  [self.goodsDescriptionLb sizeThatFits:CGSizeMake(ScreenW-self.goodsImageV.right-20-15-44-5, 15)];
    self.goodsDescriptionLb.frame = CGRectMake(self.goodsImageV.right+20, self.goodsTitleLb.bottom+5, descSize.width, descSize.height);

    self.tagLb.hidden = self.dataModel.pricePrice.overdue;

    self.goodsPriceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.dataModel.pricePrice.cashPrice] twoText:@""];
    self.goodsPriceLb.frame = CGRectMake(self.goodsImageV.right+20, self.dataModel.rowHeight-22-15, ScreenW-self.goodsImageV.right-10-15-80-5, 15);
    self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",self.dataModel.shoppingCount];
    self.typeLb.hidden = YES;
    if (self.dataModel.purchaseLimitation != 0) {
        self.purchaseLimitationLb.text = [NSString stringWithFormat:@"限购%ld件",self.dataModel.purchaseLimitation];
    }else {
        self.purchaseLimitationLb.text = @"";
    }
    if (self.dataModel.promotionTag.length != 0) {
        self.tagLb.hidden = NO;
        self.tagLb.text = self.dataModel.promotionTag;
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
    if (!self.tagLb.hidden || !self.typeLb.hidden) {
       self.purchaseLimitationLb.frame = CGRectMake(self.goodsImageV.right+20, self.goodsDescriptionLb.bottom+5+15+5, ScreenW-self.goodsImageV.right-20-20, 15);
    }else {
        self.purchaseLimitationLb.frame = CGRectMake(self.goodsImageV.right+20, self.goodsDescriptionLb.bottom+5, ScreenW-self.goodsImageV.right-20-20, 15);
    }
    if (self.dataModel.editing) {
      self.selectBtn.selected = self.dataModel.editingRowSelected;
    }else {
       self.selectBtn.selected = self.dataModel.isRowSelected;
    }
    
    self.minusBtn.enabled = self.dataModel.shoppingCount == 1 ? NO:YES;
    self.plusBtn.frame = CGRectMake(ScreenW-20-15, self.dataModel.rowHeight-40-20,60, 60);
    self.goodsCountTF.frame = CGRectMake(self.plusBtn.left-40, self.dataModel.rowHeight-20-20, 40, 20);
    self.minusBtn.frame = CGRectMake(self.goodsCountTF.left-60, self.dataModel.rowHeight-40-20, 60, 60);
}
- (void)dataSwitchNoneType {
    self.plusBtn.hidden = YES;
    self.goodsCountTF.hidden = YES;
    self.minusBtn.hidden = YES;
    self.goodsPriceLb.hidden = YES;
}
- (void)recoveryData {
    self.plusBtn.hidden = NO;
    self.goodsCountTF.hidden = NO;
    self.minusBtn.hidden = NO;
    self.goodsPriceLb.hidden = NO;
}
- (void)selectClick:(UIButton*)btn {
   // btn.selected = !btn.selected;
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(btn.isSelected);
    }
}
- (void)plusClick {
    if (self.didPulsPhotoBlock) {
        self.didPulsPhotoBlock(self);
    }
}
- (void)minClick {
    if (self.didMinPhotoBlock) {
        self.didMinPhotoBlock(self);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(cellBaseTextfiledBegainEditing:textfiled:)]) {
        [self.delegate cellBaseTextfiledBegainEditing:self textfiled:textField];
    }
}
- (UILabel *)typeLb {
    if (!_typeLb) {
        _typeLb = [[UILabel alloc] init];
        _typeLb.backgroundColor = [UIColor colorWithHexString:@"F63019"];
        _typeLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _typeLb.font = [UIFont systemFontOfSize:9];
        _typeLb.textAlignment = NSTextAlignmentCenter;
      //  _typeLb.layer.borderWidth = 1;
      //  _typeLb.layer.borderColor = [UIColor colorWithHexString:@"f"].CGColor;
        _typeLb.layer.cornerRadius = 2;
        _typeLb.layer.masksToBounds = YES;
    }
    return _typeLb;
}
- (UILabel *)tagLb {
    if (!_tagLb) {
        _tagLb = [[UILabel alloc] init];
        _tagLb.backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        _tagLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _tagLb.font = [UIFont systemFontOfSize:9];
        _tagLb.textAlignment = NSTextAlignmentCenter;
//        _tagLb.layer.borderWidth = 1;
//        _tagLb.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
        _tagLb.layer.cornerRadius = 2;
        _tagLb.layer.masksToBounds = YES;
    }
    return _tagLb;
}
- (UITextField *)goodsCountTF {
    if (!_goodsCountTF) {
        _goodsCountTF = [[UITextField alloc] initWithFrame:CGRectMake(self.plusBtn.left-40, 131-20-20, 40, 20)];
        _goodsCountTF.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        _goodsCountTF.layer.borderWidth = 0.5;
        _goodsCountTF.textColor = [UIColor colorWithHexString:@"999999"];
        _goodsCountTF.font = [UIFont systemFontOfSize:10];
        _goodsCountTF.text = @"1";
        _goodsCountTF.textAlignment = NSTextAlignmentCenter;
        _goodsCountTF.keyboardType =  UIKeyboardTypeNumberPad;
        _goodsCountTF.delegate = self;
//        _goodsCountTF.userInteractionEnabled = NO;
        
    }
    return _goodsCountTF;
}
- (UIButton *)plusBtn {
    if (!_plusBtn) {
         _plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-20-15, 131-40-20,60, 60)];
        [_plusBtn setImage:[UIImage imageNamed:@"car_plussign"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"car_plussign"] forState:UIControlStateDisabled];
        _plusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        [_plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusBtn;
}
- (UIButton *)minusBtn {
    if (!_minusBtn) {
         _minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.goodsCountTF.left-60, 131-40-20, 60, 60)];
        [_minusBtn setImage:[UIImage imageNamed:@"min"] forState:UIControlStateNormal];
        [_minusBtn setImage:[UIImage imageNamed:@"car_minus_disable"] forState:UIControlStateDisabled];
        [_minusBtn addTarget:self action:@selector(minClick) forControlEvents:UIControlEventTouchUpInside];
         _minusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    }
    return _minusBtn;
}

- (UILabel *)goodsPriceLb {
    if (!_goodsPriceLb) {
         _goodsPriceLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 131-22-15, ScreenW-self.goodsImageV.right-10-15-80-5, 15)];
    }
    return _goodsPriceLb;
}
- (UILabel *)goodsDescriptionLb {
    if (!_goodsDescriptionLb) {
         _goodsDescriptionLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 20, ScreenW-self.goodsImageV.right-10-15-44-5, 20)];
         _goodsDescriptionLb.font = [UIFont systemFontOfSize:12];
         _goodsDescriptionLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _goodsDescriptionLb;
}
- (UILabel *)goodsTitleLb {
    if (!_goodsTitleLb) {
        _goodsTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 20, ScreenW-self.goodsImageV.right-10-15, 20)];
        _goodsTitleLb.font = [UIFont systemFontOfSize:12];
        _goodsTitleLb.numberOfLines = 2;
    }
    return _goodsTitleLb;
}
- (UIImageView *)goodsImageV {
    if (!_goodsImageV) {
        _goodsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectBtn.right+10, (130-90)*0.5, 70, 90)];
        _goodsImageV.image = [UIImage imageNamed:@"product_4"];
    }
    return _goodsImageV;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
         _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (130-40)*0.5, 40, 40)];
        [_selectBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [_selectBtn setImage:[UIImage imageNamed:@"car_disable_icon"] forState:UIControlStateDisabled];
        [_selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
//        _selectBtn.enabled = NO;
        
    }
    return _selectBtn;
}
- (UILabel *)purchaseLimitationLb {
    if (!_purchaseLimitationLb) {
        _purchaseLimitationLb = [[UILabel alloc] init];
        _purchaseLimitationLb.textColor = [UIColor colorWithHexString:@"F3344A"];
        _purchaseLimitationLb.font = [UIFont systemFontOfSize:12];
    }
    return _purchaseLimitationLb;
}
@end
