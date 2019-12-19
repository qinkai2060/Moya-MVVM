//
//  HFYDProductCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDProductCell.h"
#import "HFTextCovertImage.h"
@interface HFYDProductCell ()
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *saleCountLb;
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)UIButton *addProductBtn;
@property(nonatomic,strong)UILabel *productCountLb;
@property(nonatomic,strong)UIButton *minProductBtn;
@end
@implementation HFYDProductCell
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
    if (self.model.totalSaleVolume == 0) {
        self.saleCountLb.text = @"暂无销售";
    }else {
        self.saleCountLb.text = [NSString stringWithFormat:@"月销售%ld",self.model.totalSaleVolume];
    }
    self.priceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:self.model.cashPrice]] twoText:@""];
    if (self.model.yiMCount != 0) {
        self.minProductBtn.hidden = NO;
        self.productCountLb.hidden = NO;
    }else {
        self.minProductBtn.hidden = YES;
        self.productCountLb.hidden = YES;
    }
    self.productCountLb.text = [NSString stringWithFormat:@"%ld",self.model.yiMCount];
    CGSize size = [HFUntilTool boundWithStr:self.titleLb.text blodfont:16 maxSize:CGSizeMake(ScreenW-86-12-72-12-12, 40)];
    self.iconImageView.frame = CGRectMake(12, 15, 72, 72);
    self.titleLb.frame = CGRectMake(self.iconImageView.right+12, 15, self.contentView.width-self.iconImageView.right-12-12, size.height);
    self.saleCountLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom+4, self.titleLb.width, 16);
    self.priceLb.frame = CGRectMake(self.titleLb.left, self.model.rowHight-16-20, 117, 20);
    self.addProductBtn.frame = CGRectMake(self.contentView.width-12-24, self.model.rowHight-14-24, 24, 24);
    self.productCountLb.frame = CGRectMake(self.addProductBtn.left-28, self.model.rowHight-16-20, 28, 20);
    self.minProductBtn.frame = CGRectMake(self.productCountLb.left-24, self.model.rowHight-14-24, 24, 24);
    @weakify(self)
    [[self.addProductBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
            if ([HFUserDataTools isLogin]) {
//                self.model.yiMCount++;
                if ([self.delegate respondsToSelector:@selector(productCell:selectproductSpecifications:)]) {
                    [self.delegate productCell:self selectproductSpecifications:self.model];
                }
            }else {
                
                if ([self.delegate respondsToSelector:@selector(productCell:loginStatus:)]) {
                    [self.delegate productCell:self loginStatus:[HFUserDataTools isLogin]];
                }
                
            }
        }else {
            [MBProgressHUD showAutoMessage:@"网络似乎已断开"];
        }
    }];
    [[self.minProductBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
            if ([HFUserDataTools isLogin]) {
                if (self.model.yiMCount != 0) {
//                    self.model.yiMCount--;
                    if ([self.delegate respondsToSelector:@selector(productCell:data:)]) {
                        [self.delegate productCell:self data:self.model];
                    }
                }
            }else {

                if ([self.delegate respondsToSelector:@selector(productCell:loginStatus:)]) {
                    [self.delegate productCell:self loginStatus:[HFUserDataTools isLogin]];
                }
           
            }
            
        }else {
            
                [MBProgressHUD showAutoMessage:@"网络似乎已断开"];
       
        }
   
        
    }];
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [HFUIkit textColor:@"333333" blodfont:16 numberOfLines:0];
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
