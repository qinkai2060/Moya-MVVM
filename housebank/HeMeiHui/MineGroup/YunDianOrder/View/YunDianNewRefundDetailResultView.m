//
//  YunDianNewRefundDetailResultView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailResultView.h"

@implementation YunDianNewRefundDetailResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self addSubview:self.result2Label];
    [self.result2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    
    [self addSubview:self.result1Label];
    [self.result1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.result2Label.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
}

- (UILabel *)result2Label{
    if (!_result2Label) {
        _result2Label = [[UILabel alloc] init];
        _result2Label.text = @"";
        _result2Label.font = [UIFont systemFontOfSize:14];
        _result2Label.textColor = HEXCOLOR(0x333333);
        _result2Label.numberOfLines = 1;
        _result2Label.textAlignment = NSTextAlignmentLeft;
        
    }
    return _result2Label;
}
- (UILabel *)result1Label{
    if (!_result1Label) {
        _result1Label = [[UILabel alloc] init];
        _result1Label.text = @"";
        _result1Label.font = [UIFont boldSystemFontOfSize:13];
        _result1Label.textColor = HEXCOLOR(0x333333);
        _result1Label.numberOfLines = 1;
        _result1Label.hidden = YES;
        _result1Label.textAlignment = NSTextAlignmentLeft;
        
    }
    return _result1Label;
}
- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    switch ([_refundDetailModel.returnState integerValue]) {
        case 1://(买家=退款中，卖家=退款待处理）
        {
          _result2Label.text = @"买家已申请退款，请及时处理。";
            _result1Label.text = @"商家同意后，系统将退款给买家。";
            _result1Label.hidden = NO;

            
        }
            break;
        case 2://撤销退款
        {
           _result2Label.text = @"买家已撤销本次退款申请";
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
        case 3://(商家拒绝退款）
        {
           _result2Label.text = @"商家拒绝了退款申请。";
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
        case 4://（商家同意退款)
        {
            if ([self.refundDetailModel.autoRefund  integerValue] == 1) {
                 _result2Label.text = @"商家超时未发货，系统自动退款。";
            } else {
                _result2Label.text = @"商家已同意退款申请，系统自动退款给买家。";

            }
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
        case 5://(退款待仲裁）
        {
                       if ([_refundDetailModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
                           _result2Label.text = @"买家发起了退款申请，等待平台仲裁。";

                       } else {
         _result2Label.text = @"买家发起了退款仲裁，等待平台仲裁。";
                       }
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
        case 6://（仲裁拒绝退款）
        {
            
           _result2Label.text = @"平台仲裁结果为拒绝退款。";
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
        case 7://（仲裁同意退款)
        {
           _result2Label.text = @"平台仲裁结果为同意退款 。";
            _result1Label.text = @"";
            _result1Label.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
}
@end
