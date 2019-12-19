//
//  HFVIPProductCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVIPProductCell.h"
#import "HFTextCovertImage.h"
@implementation HFVIPProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setupSubviews];
    }
    return self;
}
- (void)hh_setupSubviews {
    [self.contentView addSubview:self.productImagV];
    [self.contentView.layer addSublayer:self.lineLayer];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.stockLb];
    [self.contentView addSubview:self.saleLb];
    [self.contentView addSubview:self.priceLb];
}
- (void)doSommthingData {
    [self.productImagV sd_setImageWithURL:[NSURL URLWithString:self.model.imagUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.model.title;
    self.priceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:[self.model.cashPrice floatValue]] twoText:@""];
    self.stockLb.text = [NSString stringWithFormat:@"库存: %@",self.model.stock];
    self.saleLb.text = [NSString stringWithFormat:@"销量: %@",self.model.saleCount];
    
    CGSize titleSize = [HFUntilTool boundWithStr:self.model.title font:13 maxSize:CGSizeMake(ScreenW-45-80, 30)];
    CGSize stockSize = [HFUntilTool boundWithStr:self.stockLb.text font:11 maxSize:CGSizeMake((ScreenW-45-80)*0.5-20, 15)];
    CGSize saleSize = [HFUntilTool boundWithStr:self.saleLb.text font:11 maxSize:CGSizeMake((ScreenW-45-80)*0.5-20, 15)];
    self.productImagV.frame = CGRectMake(15, 15, 80, 80);
    self.titleLb.frame = CGRectMake(self.productImagV.right+15, 15, ScreenW-45-80, titleSize.height);
    self.stockLb.frame = CGRectMake(self.productImagV.right+15, self.productImagV.bottom-15, stockSize.width, 15);
    self.saleLb.frame = CGRectMake(self.stockLb.right+20, self.stockLb.bottom-15, saleSize.width, 15);
    self.priceLb.frame = CGRectMake(self.productImagV.right+15, self.stockLb.top-7-15, ScreenW-45-80, 15);
    self.lineLayer.frame = CGRectMake(15, 110-1, ScreenW-30, 1);
    
}
- (UIImageView *)productImagV {
    if (!_productImagV) {
        _productImagV = [[UIImageView alloc] init];
    }
    return _productImagV;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.font = [UIFont systemFontOfSize:13];
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}
- (UILabel *)stockLb {
    if (!_stockLb) {
        _stockLb = [[UILabel alloc] init];
        _stockLb.font = [UIFont systemFontOfSize:11];
        _stockLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _stockLb;
}
- (UILabel *)saleLb {
    if (!_saleLb) {
        _saleLb = [[UILabel alloc] init];
        _saleLb.font = [UIFont systemFontOfSize:11];
        _saleLb.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _saleLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
    }
    return _priceLb;
}
- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"].CGColor;
    }
    return _lineLayer;
}
@end
