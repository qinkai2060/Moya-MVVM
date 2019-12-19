//
//  VipPlayDetailBottomView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipPlayDetailBottomView.h"

@implementation VipPlayDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.bottomView addSubview:self.bottomImage];
        [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView).offset(WScale(15));
            make.left.equalTo(self.bottomView).offset(15);
            make.bottom.equalTo(self.bottomView).offset(-(WScale(15)));
            make.width.equalTo(@(WScale(80)));
        }];
        
        [self.bottomView addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomImage);
            make.left.equalTo(self.bottomImage.mas_right).offset(15);
            make.right.equalTo(self.bottomView).offset(-15);
        }];
        
        [self.bottomView addSubview:self.nowPriceLabel];
        [self.nowPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomImage).offset(-7);
            make.left.equalTo(self.bottomLabel);
            make.height.equalTo(@15);
        }];
        
        [self.bottomView addSubview:self.beforePriceLabel];
        [self.beforePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nowPriceLabel.mas_right).offset(7);
            make.top.height.equalTo(self.nowPriceLabel);
        }];
        
        [self.bottomView addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nowPriceLabel);
            make.right.equalTo(self.bottomView).offset(-15);
            make.width.equalTo(@68);
            make.height.equalTo(@25);
        }];
        
        @weakify(self);
        [[self.buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.block) {
                self.block();
            }
        }];
    }
    return self;
}

- (void)setUpDetailUIWtihDic:(NSDictionary *)dic withBlock:(callBackBlock)block{
    self.block = block;
    
    if ([[dic objectForKey:@"imageUrl"] isNotNil]) {
        [self.bottomImage sd_setImageWithURL:[[dic objectForKey:@"imageUrl"] get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }
    if ([[dic objectForKey:@"productName"] isNotNil]) {
        self.bottomLabel.text = [dic objectForKey:@"productName"];
    }
    if ([dic objectForKey:@"cashPrice"]) {
        NSString * nowPrice = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"cashPrice"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nowPrice];
        [str addAttribute:NSFontAttributeName value:kFONT(10) range:NSMakeRange(0,1)];
        self.nowPriceLabel.attributedText = str;
    }
    if ([dic objectForKey:@"salePrice"]) {
        NSString * before = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"salePrice"]];
        self.beforePriceLabel.text = before;
        NSUInteger length = [self.beforePriceLabel.text length];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.beforePriceLabel.text];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, length)];
        [self.beforePriceLabel setAttributedText:attri];
    }
}

#pragma mark -- lazy load
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.8f];
        _bottomView.userInteractionEnabled = YES;
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIImageView *)bottomImage {
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc]init];
        _bottomImage.backgroundColor = [UIColor whiteColor];
        _bottomImage.contentMode = UIViewContentModeScaleAspectFit;
        _bottomView.frame = CGRectMake(0, 0, kWidth, WScale(110));
        // 左上和右上为圆角
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc] init];
        cornerRadiusLayer.frame = _bottomView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _bottomView.layer.mask = cornerRadiusLayer;
    }
    return _bottomImage;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _bottomLabel.font = kFONT(13);
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}

- (UILabel *)nowPriceLabel {
    if (!_nowPriceLabel) {
        _nowPriceLabel = [UILabel new];
        _nowPriceLabel.textColor = [UIColor colorWithHexString:@"#F3344A"];
        _nowPriceLabel.font = kFONT_BOLD(17);
        _nowPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nowPriceLabel;
}

- (UILabel *)beforePriceLabel {
    if (!_beforePriceLabel) {
        _beforePriceLabel = [UILabel new];
        _beforePriceLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _beforePriceLabel.font = kFONT(13);
        _beforePriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _beforePriceLabel;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyBtn setTitle:@"去购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _buyBtn.layer.borderWidth = 1;
        _buyBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 12.5;
        _buyBtn.titleLabel.font = kFONT(12);
    }
    return _buyBtn;
}
@end
