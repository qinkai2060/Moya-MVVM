//
//  YunDianNewRefundDetailPingTaiResultView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailPingTaiResultView.h" 
#import "ReturnLabelHeight.h"
@implementation YunDianNewRefundDetailPingTaiResultView
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
    
    [self addSubview:self.pingTaiResultLable];
    
    [self.pingTaiResultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.timeLable.mas_left).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.pingTaiDetailLable];
    [self.pingTaiDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pingTaiResultLable);
        make.top.equalTo(self.pingTaiResultLable.mas_bottom).offset(10);
        make.right.equalTo(self.timeLable);
    }];
    
    
    
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 0.8)];
        _line.backgroundColor = HEXCOLOR(0xF5F5F5);
    }
    return _line;
}
- (UILabel *)pingTaiResultLable{
    if (!_pingTaiResultLable) {
        _pingTaiResultLable = [[UILabel alloc] init];
        _pingTaiResultLable.text = @"平台仲裁结果为同意退款";
        _pingTaiResultLable.font = [UIFont boldSystemFontOfSize:13];
        _pingTaiResultLable.textColor = HEXCOLOR(0x333333);
        _pingTaiResultLable.numberOfLines = 1;
//        _pingTaiResultLable.hidden = YES;
        _pingTaiResultLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _pingTaiResultLable;
}
- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = @"2018-08-10 22:00";
        _timeLable.font = [UIFont systemFontOfSize:13];
        _timeLable.textColor = HEXCOLOR(0x333333);
        _timeLable.numberOfLines = 1;
//        _timeLable.hidden = YES;
        _timeLable.textAlignment = NSTextAlignmentRight;
        
    }
    return _timeLable;
}
- (UILabel *)pingTaiDetailLable{
    if (!_pingTaiDetailLable) {
        _pingTaiDetailLable = [[UILabel alloc] init];
        _pingTaiDetailLable.text = @"平台同意理由平台同意理由平台同意理由平台同意理由平台同意理由平台同意理由平台同意理由";
        _pingTaiDetailLable.font = [UIFont systemFontOfSize:13];
        _pingTaiDetailLable.textColor = HEXCOLOR(0x333333);
        _pingTaiDetailLable.numberOfLines = 0;
//        _pingTaiDetailLable.hidden = YES;
        _pingTaiDetailLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _pingTaiDetailLable;
}
- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    switch ([_refundDetailModel.returnState integerValue]) {
        case 6:
             _pingTaiResultLable.text = @"平台仲裁结果为拒绝退款";
            break;
        case 7:
             _pingTaiResultLable.text = @"平台仲裁结果为同意退款";
            break;
            
        default:
            _pingTaiResultLable.text = @"";
            break;
    }
    _timeLable.text = CHECK_STRING(_refundDetailModel.arbitrateDate);
    
    _pingTaiDetailLable.text = CHECK_STRING(_refundDetailModel.arbitrateRemark);
    
}
+(CGFloat)yunDianNewRefundDetailPingTaiResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel{
    CGFloat height= 0.f;
    height = 60 + [ReturnLabelHeight getHeightByWidth:ScreenW - 30 title:CHECK_STRING(refundDetailModel.arbitrateRemark) font:[UIFont systemFontOfSize:13]];
    return height;
}

@end
