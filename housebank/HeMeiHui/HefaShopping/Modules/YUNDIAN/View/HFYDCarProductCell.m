//
//  HFYDCarProductCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDCarProductCell.h"

@implementation HFYDCarProductCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self hh_setupViews];
    }
    return self;
}
- (void)hh_setupViews {
    [self.contentView addSubview:self.plusBtn];
    [self.contentView addSubview:self.countLb];
    [self.contentView addSubview:self.minBtn];
    [self.contentView addSubview:self.priceLb];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.specialsLb];
}
- (void)domessageDataSomthing {
    self.plusBtn.frame = CGRectMake(ScreenW-24-10, 0, 24, 60);
    self.countLb.frame = CGRectMake(self.plusBtn.left-28, 0, 28, 60);
    self.minBtn.frame = CGRectMake(self.countLb.left-24, 0, 24, 60);
    self.priceLb.frame = CGRectMake(self.minBtn.left-10-80, 0, 80, 60);
    self.nameLb.frame = CGRectMake(10, 0, self.priceLb.left-10-10, 60);
    self.nameLb.text = self.carmodel.productName;
    self.priceLb.text = [NSString stringWithFormat:@"¥%.02f",self.carmodel.price];
    self.countLb.text = [NSString stringWithFormat:@"%ld",self.carmodel.productCount];
    self.specialsLb.text = self.carmodel.specifications;
    CGFloat spH = [HFUntilTool boundWithStr:self.specialsLb.text font:12 maxSize:CGSizeMake(ScreenW-20-24-24-28-20-80-10, MAXFLOAT)].height;
    self.specialsLb.frame = CGRectMake(10, self.nameLb.bottom+5, self.nameLb.width, spH);
}
- (UIButton *)plusBtn {
    if (!_plusBtn) {
        _plusBtn = [HFUIkit image:@"yd_plus" selectImage:@"yd_plus"];
    }
    return _plusBtn;
}
- (UIButton *)minBtn {
    if (!_minBtn) {
        _minBtn = [HFUIkit image:@"yd_min" disableImag:@"car_minus_disable"];
    }
    return _minBtn;
}
- (UILabel *)countLb {
    if (!_countLb) {
        _countLb = [HFUIkit textColor:@"333333" font:16 numberOfLines:1];
        _countLb.hidden = YES;
        _countLb.textAlignment = NSTextAlignmentCenter;
    }
    return _countLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [HFUIkit textColor:@"333333" font:16 numberOfLines:1];
    }
    return _priceLb;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [HFUIkit textColor:@"333333" font:16 numberOfLines:1];
    }
    return _nameLb;
}
- (UILabel *)specialsLb {
    if (!_specialsLb) {
        _specialsLb = [HFUIkit textColor:@"666666" font:12 numberOfLines:0];
    }
    return _specialsLb;
}
@end
