//
//  HFProudctVideoCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFProudctVideoCell.h"
#import "UIButton+CustomButton.h"
@interface HFProudctVideoCell ()
@property(nonatomic,strong)UIImageView *productImageV;
@property(nonatomic,strong)UIButton *xiangqBtn;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *priceLb;
@end
@implementation HFProudctVideoCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.productImageV];
        [self.productImageV addSubview:self.xiangqBtn];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.priceLb];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}
- (void)doSomething {
    self.productImageV.image = [UIImage imageNamed:@"circle_default"];
    self.titleLb.text = @"A.H.C 玻尿酸神...";
    self.priceLb.text = @"￥108";
    self.productImageV.frame = CGRectMake(0, 0, 40, 40);
    self.xiangqBtn.frame = CGRectMake(0, 40-11, 40, 11);
    self.titleLb.frame = CGRectMake(self.productImageV.right+5, 0, 90, 16);
    self.priceLb.frame = CGRectMake(self.productImageV.right+5, 40-14, 90, 14);
//    NSInteger selected = arc4random()%2;
    if (self.select) {
        self.titleLb.hidden = NO;
        self.titleLb.hidden = NO;

    }else {
        self.titleLb.hidden = YES;
        self.titleLb.hidden = YES;

    }
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:11];
        _titleLb.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }
    return _titleLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
        _priceLb.textColor = [UIColor colorWithHexString:@"FF1111"];
        _priceLb.font = [UIFont systemFontOfSize:14];
    }
    return _priceLb;
}
- (UIImageView *)productImageV {
    if (!_productImageV) {
        _productImageV = [[UIImageView alloc] init];
        _productImageV.layer.cornerRadius = 5;
        _productImageV.layer.masksToBounds = YES;
    }
    return _productImageV;
}
- (UIButton *)xiangqBtn {
    if (!_xiangqBtn) {
        _xiangqBtn = [[UIButton alloc] init];
        _xiangqBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [_xiangqBtn setTitle:@"详情" forState:UIControlStateNormal];
        [_xiangqBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [_xiangqBtn setImage:[UIImage imageNamed:@"video_circle_Rectangle"] forState:UIControlStateNormal];
        [_xiangqBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:0];
        _xiangqBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        

    }
    return _xiangqBtn;
}
@end
