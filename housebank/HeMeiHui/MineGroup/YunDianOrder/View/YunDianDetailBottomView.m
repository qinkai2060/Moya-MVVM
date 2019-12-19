//
//  YunDianDetailBottomView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianDetailBottomView.h"
#import "UIView+addGradientLayer.h"
@implementation YunDianDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xE5E5E5);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.height.mas_equalTo(0.7);
    }];
    
    [self addSubview:self.btnRight];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];

    [self addSubview:self.btnRightRed];
    [self.btnRightRed mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.btnRight);
    }];
    
    [self addSubview:self.btnLeft];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.btnRight.mas_left).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    
    
    [self layoutIfNeeded];
    [self.btnRightRed addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [self.btnRightRed bringSubviewToFront:self.btnRightRed.titleLabel];
}
- (UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnLeft setTitle:@"" forState:(UIControlStateNormal)];
        _btnLeft.hidden = YES;
        _btnLeft.titleLabel.font = PFR14Font;
        [_btnLeft setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
        _btnLeft.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnLeft.layer.borderWidth = 0.7;
        _btnLeft.layer.cornerRadius = 12.5;
        _btnLeft.layer.masksToBounds = YES;
        [_btnLeft addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _btnLeft;
}
- (UIButton *)btnRight{
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRight setTitle:@"" forState:(UIControlStateNormal)];
        _btnRight.titleLabel.font = PFR14Font;
        _btnRight.hidden = YES;
        [_btnRight setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnRight.backgroundColor = HEXCOLOR(0xF3344A);
        _btnRight.layer.cornerRadius = 12.5;
        _btnRight.layer.masksToBounds = YES;
        [_btnRight addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnRight;
}
- (UIButton *)btnRightRed{
    if (!_btnRightRed) {
        _btnRightRed = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRightRed setTitle:@"" forState:(UIControlStateNormal)];
        _btnRightRed.titleLabel.font = PFR14Font;
        _btnRightRed.hidden = YES;
        [_btnRightRed setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnRightRed.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnRightRed.layer.borderWidth = 0.7;
        _btnRightRed.layer.cornerRadius = 12.5;
        _btnRightRed.layer.masksToBounds = YES;
        [_btnRightRed addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _btnRightRed;
}
- (void)yunDianDetailBottomViewBtnShow:(YunDianOrderListDetailModel *)orderListModel
{
    
    switch ([orderListModel.orderState integerValue]) {
        case 1:
        {
            //待付款
            
        }
            break;
        case 2:
        {
           // 待发货 0：自提，1：快递，2：闪送，3：配送
            _btnRight.hidden = YES;
            _btnLeft.hidden = YES;
            
            if (![orderListModel.shopsType isEqual:@(3)]) {//微店没有发货
                
                if ([orderListModel.isDistribution isEqual:@(0)]) {
                    _btnRightRed.hidden = YES;
                    
                } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                    _btnRightRed.hidden = NO;
                    [_btnRightRed setTitle:@"发货" forState:(UIControlStateNormal)];
                } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                    //闪送
                    _btnRightRed.hidden = YES;
                    
                } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                    
                    _btnRightRed.hidden = YES;
                } else {
                    _btnRightRed.hidden = NO;
                    [_btnRightRed setTitle:@"发货" forState:(UIControlStateNormal)];
                    
                }
            }
          
        }
            break;
        case 3:
        {//代收货
            _btnRight.hidden = NO;
            _btnLeft.hidden = YES;
            _btnRightRed.hidden = YES;
            // 0：自提，1：快递，2：闪送，3：配送
            if ([orderListModel.isDistribution isEqual:@(0)]) {
                [_btnRight setTitle:@"核销" forState:(UIControlStateNormal)];
            } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];

            } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                //没这个状态
            } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                //没这个状态
                [_btnRight setTitle:@"核销" forState:(UIControlStateNormal)];
            } else {
                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];
            }
            
        }
            break;
        case 4:
        {
            //退货中
            
        }
            break;
        case 5:
        {
            //已退货
            
            
        }
            break;
        case 6:
        {
            //已取消
            
            
        }
            break;
        case 7:
        {
            _btnLeft.hidden = YES;
            _btnRightRed.hidden = YES;
            //已完成
            if ([orderListModel.isDistribution isEqual:@(0)]) {
                //没这个状态
                _btnRight.hidden = YES;

            } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                _btnRight.hidden = NO;

                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];
                
            } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                //没这个状态
                _btnRight.hidden = YES;

            } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                //没这个状态
                _btnRight.hidden = YES;

                
            } else {
                _btnRight.hidden = NO;

                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];
            }
        }
            break;
        case 8:
            //已分润
        {
            _btnLeft.hidden = YES;
            _btnRightRed.hidden = YES;
            if ([orderListModel.isDistribution isEqual:@(0)]) {
                //没这个状态
                _btnRight.hidden = YES;

            } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                _btnRight.hidden = NO;

                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];
                
            } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                //没这个状态
                _btnRight.hidden = YES;

            } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                //没这个状态
                _btnRight.hidden = YES;

            } else {
                _btnRight.hidden = NO;

                [_btnRight setTitle:@"查看物流" forState:(UIControlStateNormal)];
            }
        }
            
            
            break;
        case 9:
            //已终止
        {
            
        }
            break;
        case 10:
            //已完成
            break;
            
        default:
            break;
    }
}
- (void)showRefundBtn{
    _btnRight.hidden = NO;
    _btnLeft.hidden = NO;
        _btnRightRed.hidden = YES;
    [_btnRight setTitle:@"拒绝退款" forState:(UIControlStateNormal)];
    [_btnLeft setTitle:@"同意退款" forState:(UIControlStateNormal)];

}
- (void)btnAction:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(yunDianDetailBottomViewBtnClickType:)]) {
        if ([btn.titleLabel.text isEqualToString:@"核销"]){
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeWriteOff];
        }  else if ([btn.titleLabel.text isEqualToString:@"发货"]){
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeDeliverGoods];
        } else if ([btn.titleLabel.text isEqualToString:@"查看物流"]){
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeViewLogistics];
        } else if ([btn.titleLabel.text isEqualToString:@"拒绝退款"]){
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeDonotAgreen];
        } else if ([btn.titleLabel.text isEqualToString:@"同意退款"]){
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeAgreen];
        } else {
            [self.delegate yunDianDetailBottomViewBtnClickType:YunDianDetailBottomViewClickTypeViewOther];
        }
    }
}
@end
