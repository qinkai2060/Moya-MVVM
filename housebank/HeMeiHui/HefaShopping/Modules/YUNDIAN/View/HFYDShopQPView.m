//
//  HFYDShopQPView.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDShopQPView.h"
@interface HFYDShopQPView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *shopTitleLb;
@property(nonatomic,strong)UILabel *addressLb;
@property(nonatomic,strong)UIButton *yuDBtn;
@property(nonatomic,strong)UIImageView *imageView;
@end
@implementation HFYDShopQPView

- (void)hh_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.shopTitleLb];
    [self.bgView addSubview:self.yuDBtn];
    [self.bgView addSubview:self.addressLb];
    [self addSubview:self.imageView];
}
- (void)setShopTitle:(NSString *)shopTitle {
    _shopTitle = shopTitle;
    self.shopTitleLb.text = shopTitle;
}
- (void)setAddress:(NSString *)address {
    _address = address;
    self.addressLb.text = address;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-43*2, 70)];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UILabel *)shopTitleLb {
    if (!_shopTitleLb) {
        _shopTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.bgView.width-30-self.yuDBtn.width, 20)];
        _shopTitleLb.font = [UIFont systemFontOfSize:14];
        _shopTitleLb.textColor = [UIColor blackColor];
    }
    return _shopTitleLb;
}
- (UILabel *)addressLb {
    if (!_addressLb) {
        _addressLb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.shopTitleLb.bottom+5, self.bgView.width-30-self.yuDBtn.width, 20)];
        _addressLb.font = [UIFont systemFontOfSize:12];
        _addressLb.textColor = [UIColor colorWithHexString:@"666666"];
        
    }
    return _addressLb;
}
- (UIButton *)yuDBtn {
    if (!_yuDBtn) {
        _yuDBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bgView.width-60, 0, 60, self.bgView.height)];
        [_yuDBtn setTitle:@"预定" forState:UIControlStateNormal];
        _yuDBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _yuDBtn.backgroundColor = [UIColor colorWithHexString:@"ED0505"];
        [_yuDBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    return _yuDBtn;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bgView.bottom+10, 40, 40)];
        _imageView.centerX = self.bgView.centerX;
        _imageView.image = [UIImage imageNamed:@"location_fill"];
        
    }
    return _imageView;
}
@end
