//
//  HFWDProductCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFWDProductCell.h"
#import "HFTextCovertImage.h"
@interface HFWDProductCell ()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *saleCountLb;
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)UIButton *addProductBtn;
@property(nonatomic,strong)UILabel *productCountLb;
@property(nonatomic,strong)UIButton *minProductBtn;
@end
@implementation HFWDProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.saleCountLb];
        [self.contentView addSubview:self.priceLb];
        [self.contentView addSubview:self.addProductBtn];
        [self.contentView addSubview:self.productCountLb];
        [self.contentView addSubview:self.minProductBtn];
    }
    return self;
}
- (void)doMessageSomething {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLb.text = self.model.productName;
    self.saleCountLb.text = self.model.productSubtitle;
    self.priceLb.text = [NSString stringWithFormat:@"¥%.02f",self.model.cashPrice];
    if (self.model.yiMCount != 0) {
        self.minProductBtn.hidden = NO;
        self.productCountLb.hidden = NO;
    }else {
        self.minProductBtn.hidden = YES;
        self.productCountLb.hidden = YES;
    }
    self.productCountLb.text = [NSString stringWithFormat:@"%ld",self.model.yiMCount];
    CGSize size = [self.titleLb sizeThatFits:CGSizeMake(self.contentView.width-self.iconImageView.right-12-12, 40)];
    self.iconImageView.frame = CGRectMake(15, 15, 72, 72);
    self.titleLb.frame = CGRectMake(self.iconImageView.right+15, 15, ScreenW -self.iconImageView.right-15-15, size.height);
    self.saleCountLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom+5, self.titleLb.width, 16);
    self.priceLb.frame = CGRectMake(self.titleLb.left, self.saleCountLb.bottom+12, 117, 20);
    self.addProductBtn.frame = CGRectMake(ScreenW-12-24, self.saleCountLb.bottom+12, 24, 24);
    self.productCountLb.frame = CGRectMake(self.addProductBtn.left-28, self.contentView.height-16-20, 28, 20);
    self.minProductBtn.frame = CGRectMake(self.productCountLb.left-24, self.saleCountLb.bottom+12, 24, 24);
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [HFUIkit textColor:@"333333" blodfont:16 numberOfLines:2];
    }
    return _titleLb;
}
- (UILabel *)saleCountLb {
    if (!_saleCountLb) {
        _saleCountLb = [HFUIkit textColor:@"999999" font:12 numberOfLines:1];
    }
    return _saleCountLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
    }
    return _priceLb;
}
- (UIButton *)addProductBtn {
    if (!_addProductBtn) {
        _addProductBtn = [HFUIkit image:@"yd_plus" selectImage:@"yd_plus"];
    }
    return _addProductBtn;
}
- (UIButton *)minProductBtn {
    if (!_minProductBtn) {
        _minProductBtn = [HFUIkit image:@"yd_min" selectImage:@"yd_min"];
        _minProductBtn.hidden = YES;
    }
    return _minProductBtn;
}
- (UILabel *)productCountLb {
    if (!_productCountLb) {
        _productCountLb = [HFUIkit textColor:@"333333" font:14 numberOfLines:1];
        _productCountLb.hidden = YES;
        _productCountLb.textAlignment = NSTextAlignmentCenter;
    }
    return _productCountLb;
}

@end
