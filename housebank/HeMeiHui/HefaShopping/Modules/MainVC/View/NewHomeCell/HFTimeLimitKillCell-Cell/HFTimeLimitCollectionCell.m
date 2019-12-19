//
//  HFTimeLimitCollectionCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFTimeLimitCollectionCell.h"
#import "HFTextCovertImage.h"

@implementation HFTimeLimitCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupSubViews];
    }
    return self;
}
- (void)hh_setupSubViews {
    [self.contentView addSubview:self.imageview];
    [self.contentView addSubview:self.titleLb];
    [self.contentView addSubview:self.priceLb];
}
- (void)doMessageRendering {
ManagerTools *managerTools   = [ManagerTools ManagerTools];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@!%@",managerTools.appInfoModel.imageServerUrl,self.smallModel.productImage,IMGWH(CGSizeMake(103, 103))]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.smallModel.productName;
    if(self.smallModel.promotionPrice <= 0) {
        self.priceLb.attributedText =  [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.smallModel.cashPrice] twoText:@""];
    }else {
//          self.priceLb.attributedText =  [HFTextCovertImage exchangeTextStyle:[NSString stringWithFormat:@"¥%.02f ",self.smallModel.promotionPrice] twoText:[NSString stringWithFormat:@"¥%.02f ",self.smallModel.cashPrice]];
//         self.priceLb.attributedText =  [HFTextCovertImage exchangeTextStyle:[NSString stringWithFormat:@"¥%.02f ",self.smallModel.promotionPrice] twoText:@""];
        self.priceLb.attributedText =  [HFTextCovertImage exchangeTextStyle:[HFUntilTool thousandsFload:self.smallModel.promotionPrice] twoText:@""];
    }
    
    self.imageview.frame = CGRectMake(10, 10, self.contentView.width-20, self.contentView.width-20);
    self.titleLb.frame = CGRectMake(10, self.imageview.bottom+5, self.width-20, 15);
    self.priceLb.frame = CGRectMake(10, self.titleLb.bottom+7, self.width-20, 15);
}
- (UIImageView *)imageview {
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
//        _imageview.contentMode = UIViewContentModeScaleAspectFit;
//        _imageview.backgroundColor = [UIColor blueColor];
    }
    return _imageview;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:12];
        _titleLb.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLb;
}
@end
