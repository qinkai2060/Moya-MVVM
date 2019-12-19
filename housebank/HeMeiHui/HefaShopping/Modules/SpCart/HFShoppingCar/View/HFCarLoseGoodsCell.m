//
//  HFCarLoseGoodsCell.m
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFCarLoseGoodsCell.h"
@interface HFCarLoseGoodsCell ()
@property (nonatomic,strong) UILabel *loseStateLb;
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *goodsDescriptionLb;
@property (nonatomic,strong) UILabel *goodsStateLb;
@end
@implementation HFCarLoseGoodsCell
+ (void)load {
     [super registerRenderCell:[HFCarLoseGoodsCell class] messageType:2];
}
- (void)yd_setupViews {
    [self.contentView addSubview:self.loseStateLb];
    [self.contentView addSubview:self.goodsImageV];
    [self.contentView addSubview:self.goodsTitleLb];
    [self.contentView addSubview:self.goodsDescriptionLb];
    [self.contentView addSubview:self.goodsStateLb];

    
}
- (void)doMessageRendering {
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self.dataModel.productPic,@"!SQ250"]]];
    self.goodsTitleLb.text = self.dataModel.title;
    self.goodsDescriptionLb.text = @"";
    self.goodsStateLb.text = @"商品已失效";
}
- (UILabel *)goodsStateLb {
    if (!_goodsStateLb) {
        _goodsStateLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 130-30-20, ScreenW-self.goodsImageV.right-20-15-44-5, 20)];
        _goodsStateLb.font = [UIFont systemFontOfSize:13];
        _goodsStateLb.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _goodsStateLb;
}
- (UILabel *)goodsDescriptionLb {
    if (!_goodsDescriptionLb) {
        _goodsDescriptionLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, self.goodsTitleLb.bottom+5, ScreenW-self.goodsImageV.right-20-15-44-5, 20)];
        _goodsDescriptionLb.font = [UIFont systemFontOfSize:12];
        _goodsDescriptionLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _goodsDescriptionLb;
}
- (UILabel *)goodsTitleLb {
    if (!_goodsTitleLb) {
        _goodsTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 20, ScreenW-self.goodsImageV.right-20-15, 20)];
        _goodsTitleLb.numberOfLines = 0;
        _goodsTitleLb.textColor = [UIColor colorWithHexString:@"999999"];
        _goodsTitleLb.font = [UIFont systemFontOfSize:15];
    }
    return _goodsTitleLb;
}
- (UIImageView *)goodsImageV {
    if (!_goodsImageV) {
        _goodsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.loseStateLb.right+10, (130-90)*0.5, 71, 90)];
        _goodsImageV.image = [UIImage imageNamed:@"product_4"];
    }
    return _goodsImageV;
}
- (UILabel *)loseStateLb {
    if (!_loseStateLb) {
        _loseStateLb = [[UILabel alloc] initWithFrame: CGRectMake(15, (130-15)*0.5, 30, 15)];
        _loseStateLb.backgroundColor = [UIColor colorWithHexString:@"CCCCCC"];
        _loseStateLb.textAlignment = NSTextAlignmentCenter;
        _loseStateLb.font = [UIFont systemFontOfSize:10];
        _loseStateLb.textColor = [UIColor whiteColor];
        _loseStateLb.text = @"失效";
        _loseStateLb.layer.cornerRadius = 8;
        _loseStateLb.layer.masksToBounds = YES;
    }
    return _loseStateLb;
}
@end
