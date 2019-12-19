//
//  YunDianNewRefundDetailBugerResultView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailBugerResultView.h"
#import "ReturnLabelHeight.h"
@implementation YunDianNewRefundDetailBugerResultView
- (void) setupButtonWithArr:(NSArray *)array {
    
    if (array.count == 0) {
        
        return;
    }
    [self layoutIfNeeded];
    CGFloat height = 0;
    if (array.count <= 4) {
        height = (ScreenW - 75) / 4 + 15;
    } else {
        height = (ScreenW - 75) / 4 * 2 + 15 +15;
    }
    [self.viewImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.buyerDetailLable.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(height);
    }];
    CGFloat btnW = (ScreenW - 75) / 4;
    CGFloat btnH = btnW;
    for (int i = 0; i < array.count; i ++) {
        NSInteger row = i/4;
        NSInteger col = i%4;
        CGFloat btnX = 15 + (btnW + 15) * col;
        CGFloat btnY = 15 + (btnH + 15) * row;
        
        YunDianNewRefundBuyerOrSellerRefundImagesMode *imageModel = (YunDianNewRefundBuyerOrSellerRefundImagesMode *)array[i];
        NSString *imgurl = [NSString stringWithFormat:@"%@",imageModel.imagePath];
        UIImageView *img = [[UIImageView alloc] init];
        img.tag = 9000 + i;
        img.userInteractionEnabled = YES;
        [img sd_setImageWithURL:[imgurl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        [self.viewImage addSubview:img];
        img.backgroundColor = [UIColor yellowColor];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(btnX);
            make.top.equalTo(self.viewImage).offset(btnY);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction:)];
        [img addGestureRecognizer:tap];
    }
}
- (void)imgTapAction:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
    NSInteger index = img.tag - 9000;
    if (index >= 0 && [self.delegate respondsToSelector:@selector(yunDianNewRefundDetailBugerResultViewDelegateClickImgIndex:)]) {
        [self.delegate yunDianNewRefundDetailBugerResultViewDelegateClickImgIndex:index
         ];
        
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.line];
    
    [self addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.buyerResultLable];
    
    [self.buyerResultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.timeLable.mas_left).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.buyerDetailLable];
    [self.buyerDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyerResultLable);
        make.top.equalTo(self.buyerResultLable.mas_bottom).offset(10);
        make.right.equalTo(self.timeLable);
    }];
    
    
    
    
    
    
    
}
- (void)createBtn{
    [self addSubview:self.viewButton];
    [self.viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        if (_viewImage) {
            make.top.equalTo(self.viewImage.mas_bottom);}
        else {
            make.top.equalTo(self.buyerDetailLable.mas_bottom);
        }
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    [self.viewButton addSubview:self.btnAgree];
    [self.viewButton addSubview:self.btnRefuse];
    
    [self.btnAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewButton).offset(-15);
        make.top.equalTo(self.viewButton).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    [self.btnRefuse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnAgree.mas_left).offset(-10);
        make.top.equalTo(self.viewButton).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 0.8)];
        _line.backgroundColor = HEXCOLOR(0xF5F5F5);
    }
    return _line;
}
- (UILabel *)buyerResultLable{
    if (!_buyerResultLable) {
        _buyerResultLable = [[UILabel alloc] init];
        _buyerResultLable.text = @"";
        _buyerResultLable.font = [UIFont boldSystemFontOfSize:13];
        _buyerResultLable.textColor = HEXCOLOR(0x333333);
        _buyerResultLable.numberOfLines = 1;
        _buyerResultLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _buyerResultLable;
}
- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = @"";
        _timeLable.font = [UIFont systemFontOfSize:13];
        _timeLable.textColor = HEXCOLOR(0x333333);
        _timeLable.numberOfLines = 1;
        _timeLable.textAlignment = NSTextAlignmentRight;
        
    }
    return _timeLable;
}
- (UILabel *)buyerDetailLable{
    if (!_buyerDetailLable) {
        _buyerDetailLable = [[UILabel alloc] init];
        _buyerDetailLable.text = @"";
        _buyerDetailLable.font = [UIFont systemFontOfSize:13];
        _buyerDetailLable.textColor = HEXCOLOR(0x333333);
        _buyerDetailLable.numberOfLines = 0;
        //        _buyerDetailLable.hidden = YES;
        _buyerDetailLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _buyerDetailLable;
}
- (UIView *)viewImage{
    if (!_viewImage) {
        _viewImage = [[UIView alloc] init];
        _viewImage.backgroundColor = [UIColor whiteColor];
    }
    return _viewImage;
}

- (UIView *)viewButton{
    if (!_viewButton) {
        _viewButton = [[UIView alloc] init];
        //        _viewButton.backgroundColor = [UIColor yellowColor];
    }
    return _viewButton;
}
- (UIButton *)btnRefuse{
    if (!_btnRefuse) {
        _btnRefuse = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRefuse setTitle:@"拒绝" forState:(UIControlStateNormal)];
        //        _btnRefuse.hidden = YES;
        _btnRefuse.titleLabel.font = PFR14Font;
        [_btnRefuse setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
        _btnRefuse.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
        _btnRefuse.layer.borderWidth = 0.7;
        _btnRefuse.layer.cornerRadius = 12.5;
        _btnRefuse.layer.masksToBounds = YES;
        [_btnRefuse addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _btnRefuse;
}
- (UIButton *)btnAgree{
    if (!_btnAgree) {
        _btnAgree = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnAgree setTitle:@"同意" forState:(UIControlStateNormal)];
        _btnAgree.titleLabel.font = PFR14Font;
        //        _btnAgree.hidden = YES;333333。DDDDDD
        [_btnAgree setTitleColor:HEXCOLOR(0xF3344A) forState:(UIControlStateNormal)];
        _btnAgree.layer.borderColor = HEXCOLOR(0xF3344A).CGColor;
        _btnAgree.layer.borderWidth = 0.7;
        _btnAgree.layer.cornerRadius = 12.5;
        _btnAgree.layer.masksToBounds = YES;
        [_btnAgree addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnAgree;
}
- (void)btnAction:(UIButton *)btn{
    if (btn == _btnAgree) {
        if ([self.delegate respondsToSelector:@selector(yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:)]) {
            [self.delegate yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:(YunDianNewRefundDetailBugerResultViewTypeRefund)];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:)]) {
            [self.delegate yunDianNewRefundDetailBugerResultViewSeller_Confirm_RefundDelegate:(YunDianNewRefundDetailBugerResultViewTypeRefuse)];
        }
        
    }
}
- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    
    _buyerResultLable.text = @"买家申请退款：";
    _timeLable.text = CHECK_STRING(_refundDetailModel.createDate);

    _buyerDetailLable.text = CHECK_STRING(_refundDetailModel.remark);

 
    
    if (!_viewImage) {
        [self addSubview:self.viewImage];
        [self.viewImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.buyerDetailLable.mas_bottom);
            make.right.equalTo(self);
            make.height.mas_equalTo(0);
        }];
        if (_refundDetailModel.buyerRefundImages.count > 0) {
            [self setupButtonWithArr:_refundDetailModel.buyerRefundImages];
        }
    }
    
    
    if ([_refundDetailModel.returnState integerValue] == 1 && ![_refundDetailModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
        //等待商家处理
        
        if (!_viewButton) {
            [self createBtn];
            
        } else{
            self.viewButton.hidden = NO;
        }
        
    } else {
        self.viewButton.hidden = YES;
    }
}

+ (CGFloat)yunDianNewRefundDetailSellerResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel{
    CGFloat height = 0.f;
    
   height = 45 + [ReturnLabelHeight getHeightByWidth:ScreenW - 30 title:CHECK_STRING(refundDetailModel.remark) font:[UIFont systemFontOfSize:13]];
   
    
    
    if (refundDetailModel.buyerRefundImages.count > 0) {
        if (refundDetailModel.buyerRefundImages.count<=4) {
            height  +=  (ScreenW - 75)/4 + 15;
        } else {
            height  +=   ((ScreenW - 75)/4 ) * 2 + 30;
        }
    }
    
    
    if ([refundDetailModel.returnState integerValue] == 1 && ![refundDetailModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
        //等待商家处理
        
        height  += 50;
        
    }

    if ([refundDetailModel.returnState integerValue] != 1) {
        height += 15;
    }
    
    
    return height;
}
@end
