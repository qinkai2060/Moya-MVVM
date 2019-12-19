//
//  HFPayMentShoppsCell.m
//  housebank
//
//  Created by usermac on 2018/11/14.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFPayMentShoppsCell.h"
@interface HFPayMentShoppsCell ()
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *goodsPriceLb;
@property (nonatomic,strong) UILabel *goodsCountLb;
@property (nonatomic,strong) UILabel *goodsDescriptionLb;
@property (nonatomic,strong) UIView *lineView;
@end
@implementation HFPayMentShoppsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.goodsImageV];
        [self.contentView addSubview:self.goodsTitleLb];
        [self.contentView addSubview:self.goodsPriceLb];
        [self.contentView addSubview:self.goodsCountLb];
        [self.contentView addSubview:self.goodsDescriptionLb];
    }
    return self;
}
- (void)doDataSomthing {
    self.lineView.frame = CGRectMake(0, 0, ScreenW, 5);
    self.goodsImageV.frame = CGRectMake(15,  self.lineView.bottom+10, 75, 75);
    [self.goodsImageV sd_setImageWithURL:[NSURL URLWithString:[ManagerTools imageURL:self.productModel.imgPath sizeSignStr:@"!SQ147"]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    NSLog(@"商品title%@",self.productModel.name);
    self.goodsTitleLb.text = self.productModel.name;
    CGSize size =  [self.goodsTitleLb sizeThatFits:CGSizeMake(ScreenW-75-15-15-10, 100-12-15-10)];
    self.goodsTitleLb.frame = CGRectMake(self.goodsImageV.right+10, self.lineView.bottom+10, size.width, size.height);
    self.goodsPriceLb.text =[NSString stringWithFormat:@"¥%.2f",self.productModel.price];
    if (self.productModel.code1.length != 0) {
        self.goodsDescriptionLb.text = [NSString stringWithFormat:@"规格:%@",self.productModel.typeTitle];
    }else {
        self.goodsDescriptionLb.text = @"";
    }
    
    CGSize descSize =  [self.goodsDescriptionLb sizeThatFits:CGSizeMake(ScreenW-self.goodsImageV.right-20-15-44-5, 15)];
    self.goodsDescriptionLb.frame = CGRectMake(self.goodsImageV.right+10, self.goodsTitleLb.bottom+5, descSize.width, descSize.height);
    CGSize sizePrice =  [self.goodsPriceLb sizeThatFits:CGSizeMake(ScreenW-75-15-15-10-60, 15)];
    self.goodsPriceLb.frame = CGRectMake(self.goodsImageV.right+10, 100-10-15, sizePrice.width, sizePrice.height);
    self.goodsCountLb.text = [NSString stringWithFormat:@"X%ld",self.productModel.count];
    CGSize sizeCount =  [self.goodsCountLb sizeThatFits:CGSizeMake(60, 15)];
    self.goodsCountLb.frame = CGRectMake(ScreenW-sizeCount.width-15, 100-10-15, sizeCount.width, sizeCount.height);
    
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    }
    return _lineView;
}
- (UILabel *)goodsCountLb {
    if (!_goodsCountLb) {
        _goodsCountLb = [[UILabel alloc] init];
        _goodsCountLb.textColor = [UIColor colorWithHexString:@"333333"];
        _goodsCountLb.font = [UIFont systemFontOfSize:12];
    }
    return _goodsCountLb;
}
- (UILabel *)goodsPriceLb {
    if (!_goodsPriceLb) {
        _goodsPriceLb = [[UILabel alloc] init];
        _goodsPriceLb.font = [UIFont systemFontOfSize:12];
    }
    return _goodsPriceLb;
}
- (UIImageView *)goodsImageV {
    if (!_goodsImageV) {
        _goodsImageV = [[UIImageView alloc] init];
        _goodsImageV.image = [UIImage imageNamed:@"product_4"];
        _goodsImageV.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        _goodsImageV.layer.borderWidth = 1;
        _goodsImageV.layer.cornerRadius = 5;
        _goodsImageV.layer.masksToBounds = YES;
    }
    return _goodsImageV;
}
- (UILabel *)goodsTitleLb {
    if (!_goodsTitleLb) {
        _goodsTitleLb = [[UILabel alloc] init];
        _goodsTitleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _goodsTitleLb.font = [UIFont systemFontOfSize:13];
        _goodsTitleLb.numberOfLines = 0;
    }
    return _goodsTitleLb;
}
- (UILabel *)goodsDescriptionLb {
    if (!_goodsDescriptionLb) {
        _goodsDescriptionLb = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageV.right+20, 20, ScreenW-self.goodsImageV.right-10-15-44-5, 20)];
        _goodsDescriptionLb.font = [UIFont systemFontOfSize:12];
        _goodsDescriptionLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _goodsDescriptionLb;
}

@end
