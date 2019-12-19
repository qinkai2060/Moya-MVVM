//
//  ManageOrderFooterView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOrderFooterView.h"
#import "JudgeOrderType.h"
@interface ManageOrderFooterView ()
@property (nonatomic, strong) UILabel * countLabel ;
@property (nonatomic, strong) UILabel * priceLabel ;
@end

@implementation ManageOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.priceLabel];
        
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(@50);
        }];
        
        UIView * footView = [UIView new];
        footView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.contentView addSubview:footView];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(bgView.mas_bottom);
        }];
        
        [bgView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-15);
            make.height.equalTo(@20);
        }];
        
        UILabel * totalLabel  = [UILabel new];
        totalLabel.text = @"合计：";
        totalLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        totalLabel.font = kFONT(12);
        totalLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.priceLabel.mas_left);
            make.centerY.equalTo(bgView);
            make.width.equalTo(@38);
            make.height.equalTo(@20);
        }];
        
        [self.contentView addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.right.equalTo(totalLabel.mas_left).offset(-10);
            make.width.equalTo(@53);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)setFooterModel:(ManageOrderModel *)footerModel {
    _footerModel = footerModel;
    self.countLabel.text = [NSString stringWithFormat:@"共%@件商品",objectOrEmptyStr(self.footerModel.productCount)];
       self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.footerModel.orderPrice floatValue]]]];
}

#pragma mark -- lazy load
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.text = @"共1件商品";
        _countLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _countLabel.font = kFONT(12);
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.text = @"￥16880.00";
        _priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _priceLabel.font = kFONT_BOLD(13);
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
@end
