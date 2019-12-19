//
//  HFCarLikeGoodsCell.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarOutStockGoodsCell.h"
@interface HFCarOutStockGoodsCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *selectTypeLb;
@property (nonatomic,strong) UIButton *goodsResetSelectBtn;
@end
@implementation HFCarOutStockGoodsCell
+ (void)load {
     [super registerRenderCell:[HFCarOutStockGoodsCell class] messageType:3];
}
- (void)yd_setupViews {
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.goodsImageV];
    [self.contentView addSubview:self.goodsTitleLb];
    [self.contentView addSubview:self.selectTypeLb];
    [self.contentView addSubview:self.goodsResetSelectBtn];
}
- (void)doMessageRendering {
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self.dataModel.productPic,@"!SQ250"]]];
    self.goodsTitleLb.text = self.dataModel.title;
    CGSize size =  [self.goodsTitleLb sizeThatFits:CGSizeMake(ScreenW-self.goodsImageV.right-20-15, 40)];
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+20, 20, size.width, size.height);
    self.selectTypeLb.frame = CGRectMake(self.goodsImageV.right+20,130-15-25 , ScreenW - self.goodsImageV.right-20-44-15, 15);
    
}
- (void)selectClick:(UIButton*)btn {
   
}
- (void)resetClick {
    if ([self.delegate respondsToSelector:@selector(cellWithdidSelectWithSpecifications:)]) {
        
        [self.delegate cellWithdidSelectWithSpecifications:self];
    }
}
- (UIButton *)goodsResetSelectBtn {
    if (!_goodsResetSelectBtn) {
        _goodsResetSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-44-15, 130-20-22, 44 , 20)];
        [_goodsResetSelectBtn setTitle:@"重选" forState:UIControlStateNormal];
        [_goodsResetSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_goodsResetSelectBtn setBackgroundImage:[UIImage imageNamed:@"disable_reset"] forState:UIControlStateNormal];
        _goodsResetSelectBtn.backgroundColor = [UIColor colorWithHexString:@"FF0000"];
        _goodsResetSelectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _goodsResetSelectBtn.layer.cornerRadius = 10;
        _goodsResetSelectBtn.layer.masksToBounds = YES;
        [_goodsResetSelectBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goodsResetSelectBtn;
}
- (UILabel *)selectTypeLb {
    if (!_selectTypeLb) {
        _selectTypeLb = [[UILabel alloc] init];
        _selectTypeLb.textColor = [UIColor  blackColor];
        _selectTypeLb.font = [UIFont systemFontOfSize:12];
        _selectTypeLb.text = @"请重新选择商品规格";
        
    }
    return _selectTypeLb;
}
- (UILabel *)goodsTitleLb {
    if (!_goodsTitleLb) {
        _goodsTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 20, ScreenW-self.goodsImageV.right-10-15, 20)];
        _goodsTitleLb.font = [UIFont systemFontOfSize:12];
        _goodsTitleLb.textColor = [UIColor colorWithHexString:@"999999"];
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
        _selectBtn.enabled = NO;
        
    }
    return _selectBtn;
}
@end
