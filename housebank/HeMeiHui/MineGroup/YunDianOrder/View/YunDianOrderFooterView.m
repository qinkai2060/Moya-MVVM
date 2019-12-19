//
//  YunDianOrderFooterView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderFooterView.h"
#import "UIView+addGradientLayer.h"
#import "JudgeOrderType.h"
@implementation YunDianOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
//计算商品总数
- (NSInteger) calculateNum{
    NSArray *arr = [NSArray arrayWithArray:_orderListModel.orderProducts];
    NSInteger count = 0;
    for (int i = 0; i < arr.count; i++) {
        YunDianOrderProductsModel *model = (YunDianOrderProductsModel *)arr[i];
        count = count + [model.productCount integerValue];
    }
    return count;
}
#pragma mark - model
- (void)setOrderListModel:(YunDianOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    _numLabel.text = [NSString stringWithFormat:@"共%ld件商品   合计：￥",(long)[self calculateNum]];
    _moneyLabel.text =  [JudgeOrderType positiveFormat:[NSString stringWithFormat:@"%.2f",[_orderListModel.totalPrice floatValue]]];
    [self shoppingCentreOrderFooterInformation];
}

//商城 订单状态（1：待支付，2：待发货，3：待收货，4：退货中，5：已退货，6：已取消，7：已完成，8：已分润，9：已终止，10：已评价）
- (void)shoppingCentreOrderFooterInformation{
    
    if (CHECK_STRING_ISNULL(_orderListModel.returnState)) {
        switch ([_orderListModel.orderState integerValue]) {
            case 1:
            {
                //待付款
                
            }
                break;
            case 2:
            {
                //商城: 待发货 (退款, 发货)云店 _商家配送: 待配送(退款 配送) 云店 _自取: 待取货(退款 核销)   0：自提，1：快递，2：闪送，3：配送
                if (![_orderListModel.shopsType isEqual:@(3)]) {// 微店没有发货
                    if ([_orderListModel.distribution isEqual:@(0)]) {
                        
                    } else if ([_orderListModel.distribution isEqual:@(1)]) {
                        //发货
                        [self isShowBtn:@[self.btnDispatchGoods]];//快递
                    } else if ([_orderListModel.distribution isEqual:@(2)]) {
                        //闪送
                    } else if ([_orderListModel.distribution isEqual:@(3)]) {
                        
                    } else {
                        //发货
                        if (![_orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流

                        [self isShowBtn:@[self.btnDispatchGoods]];//快递
                        }
                    }

                }
                
                
            }
                break;
            case 3:
            {
                
                //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
                // 0：自提，1：快递，2：闪送，3：配送
                if ([_orderListModel.distribution isEqual:@(0)]) {
                    //核销
                    [self isShowBtn:@[self.btnVerifyCode]];
                    
                } else if ([_orderListModel.distribution isEqual:@(1)]) {
                    //查看物流
                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                } else if ([_orderListModel.distribution isEqual:@(2)]) {
                    //闪送
                } else if ([_orderListModel.distribution isEqual:@(3)]) {
                    [self isShowBtn:@[self.btnVerifyCode]];
                } else {
                    if (![_orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流

                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                    }
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
                //已完成
                if ([_orderListModel.distribution isEqual:@(0)]) {
                    
                } else if ([_orderListModel.distribution isEqual:@(1)]) {
                    //查看物流
                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                } else if ([_orderListModel.distribution isEqual:@(2)]) {
                    //闪送
                } else if ([_orderListModel.distribution isEqual:@(3)]) {

                } else {
                    if (![_orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                    }
                }
                
            }
                break;
            case 8:
                //已完成
            {
                //已完成
                if ([_orderListModel.distribution isEqual:@(0)]) {
                    
                } else if ([_orderListModel.distribution isEqual:@(1)]) {
                    //查看物流
                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                } else if ([_orderListModel.distribution isEqual:@(2)]) {
                    //闪送
                } else if ([_orderListModel.distribution isEqual:@(3)]) {
                    
                } else {
                    if (![_orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                    [self isShowBtn:@[self.btnViewLogistics]];//快递
                    }
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
    } else {
        
        if ( [_orderListModel.returnState isEqual:@(2)]) {
            //取消退款
            [self isShowBtn:@[self.btnReason_R]];

        }else if ( [_orderListModel.returnState isEqual:@(3)]) {
            //拒绝退款
            [self isShowBtn:@[self.btnReason_R]];

        }else if ( [_orderListModel.returnState isEqual:@(1)]) {
            //退款中
            //查看详情 退款
            //微店没有   oto不是快递的没有 
           
            if ([_orderListModel.shopsType isEqual:@(1)]) {
                [self isShowBtn:@[self.btnReason_M, self.btnRefun_R]];

            } else if ([_orderListModel.shopsType isEqual:@(2)]){
                
                if ([_orderListModel.distribution isEqual:@(0)]) {
                    [self isShowBtn:@[self.btnReason_R]];

                } else if ([_orderListModel.distribution isEqual:@(1)]) {
                    //查看物流
                    [self isShowBtn:@[self.btnReason_M, self.btnRefun_R]];
                } else if ([_orderListModel.distribution isEqual:@(2)]) {
                    //闪送
                    [self isShowBtn:@[self.btnReason_R]];

                } else if ([_orderListModel.distribution isEqual:@(3)]) {
                    
                } else {
                    [self isShowBtn:@[self.btnReason_M, self.btnRefun_R]];
                }
            } else {
                  [self isShowBtn:@[self.btnReason_R]];

            }
            
            
            
            
            
            

           
        }else if ( [_orderListModel.returnState isEqual:@(4)]) {
            //已退款"
            [self isShowBtn:@[self.btnReason_R]];

        } else {
            [self isShowBtn:@[self.btnReason_R]];

        }
        
    }
    
    
    
   
}

/**
 显示btn
 
 @param arr 传入要显示的btn
 */

- (void)isShowBtn:(NSArray *)arr{
    for (UIButton *btn in arr) {
        
        [self.bgView addSubview:btn];
        
        if (btn == self.btnDispatchGoods|| btn == self.btnViewLogistics || btn == self.btnVerifyCode ||  btn == self.btnRefun_R || btn == self.btnReason_R) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bgView).offset(-15);
                make.right.equalTo(self.bgView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(75, 25));
            }];
            
        } else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bgView).offset(-15);
                make.right.equalTo(self.bgView).offset(-95);
                make.size.mas_equalTo(CGSizeMake(75, 25));
            }];
        }
        
        if (btn == self.btnDispatchGoods || btn == self.btnVerifyCode || btn == self.btnRefun_R) {
            [self layoutIfNeeded];
            [btn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
            [btn bringSubviewToFront:btn.titleLabel];
        }
    }
}

- (void)createView{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.numLabel];
    
    [self.bgView addSubview:self.moneyLabel];
    
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.bgView);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
        make.right.equalTo(self.moneyLabel.mas_left);
        make.centerY.equalTo(self.moneyLabel);
    }];

    
}
- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"共3件商品   合计：￥";
        _numLabel.font = PFR12Font;
        _numLabel.textColor = HEXCOLOR(0x333333);
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"16888.90";
        _moneyLabel.font = [UIFont boldSystemFontOfSize:13];
        _moneyLabel.textColor = HEXCOLOR(0x333333);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

/**
 背景图
 */
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenW - 20, self.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerBottomLeft |  UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _bgView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    return _bgView;
}




//退款
- (void)btnRefunAction{
    if (self.clickBlock) {
        self.clickBlock(YunDianOrderFooterViewTypeRefun, self.tag - 2000);
    }
}

- (UIButton *)btnRefun_R{
    if (!_btnRefun_R) {
        _btnRefun_R = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRefun_R setTitle:@"退款" forState:(UIControlStateNormal)];
        [_btnRefun_R setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnRefun_R.backgroundColor = HEXCOLOR(0xFF0000);
        _btnRefun_R.layer.cornerRadius = 12.5;
        _btnRefun_R.titleLabel.font = PFR13Font;
        _btnRefun_R.layer.masksToBounds = YES;
        [_btnRefun_R addTarget:self action:@selector(btnRefunAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnRefun_R;
}

/**
 查看物流
 */
- (void)ViewLogisticsAction{
    if (self.clickBlock) {
        self.clickBlock(YunDianOrderFooterViewTypeViewLogistics, self.tag - 2000);
    }
}

- (UIButton *)btnViewLogistics{
    if (!_btnViewLogistics) {
        _btnViewLogistics = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnViewLogistics setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [_btnViewLogistics setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnViewLogistics.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnViewLogistics.layer.borderWidth = 1;
        _btnViewLogistics.layer.cornerRadius = 12.5;
        _btnViewLogistics.titleLabel.font = PFR13Font;
        _btnViewLogistics.layer.masksToBounds = YES;
        [_btnViewLogistics addTarget:self action:@selector(ViewLogisticsAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnViewLogistics;
}


//核销码
- (void)btnVerifyCodeAction{
    if (self.clickBlock) {
        self.clickBlock(YunDianOrderFooterViewTypeVerifyCode, self.tag - 2000);
    }
}
- (UIButton *)btnVerifyCode{
    if (!_btnVerifyCode) {
        _btnVerifyCode = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnVerifyCode setTitle:@"核销" forState:(UIControlStateNormal)];
        [_btnVerifyCode setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnVerifyCode.backgroundColor = HEXCOLOR(0xFF0000);
        _btnVerifyCode.layer.cornerRadius = 12.5;
        _btnVerifyCode.titleLabel.font = PFR13Font;
        _btnVerifyCode.layer.masksToBounds = YES;
        [_btnVerifyCode addTarget:self action:@selector(btnVerifyCodeAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnVerifyCode;
}


//发货
- (void)btnDispatchGoodsAction{
    if (self.clickBlock) {
        self.clickBlock(YunDianOrderFooterViewTypeDispatchGoods, self.tag - 2000);
    }
}
- (UIButton *)btnDispatchGoods{
    if (!_btnDispatchGoods) {
        _btnDispatchGoods = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnDispatchGoods setTitle:@"发货" forState:(UIControlStateNormal)];
        [_btnDispatchGoods setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnDispatchGoods.backgroundColor = HEXCOLOR(0xFF0000);
        _btnDispatchGoods.layer.cornerRadius = 12.5;
        _btnDispatchGoods.titleLabel.font = PFR13Font;
        _btnDispatchGoods.layer.masksToBounds = YES;
        [_btnDispatchGoods addTarget:self action:@selector(btnDispatchGoodsAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnDispatchGoods;
}

//查看详情
- (void)btnReasonAction{
    if (self.clickBlock) {
        self.clickBlock(YunDianOrderFooterViewTypeReason, self.tag - 2000);
    }
}
- (UIButton *)btnReason_M{
    if (!_btnReason_M) {
        _btnReason_M = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnReason_M setTitle:@"查看详情" forState:(UIControlStateNormal)];
        [_btnReason_M setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnReason_M.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnReason_M.layer.borderWidth = 1;
        _btnReason_M.layer.cornerRadius = 12.5;
        _btnReason_M.titleLabel.font = PFR13Font;
        _btnReason_M.layer.masksToBounds = YES;
        [_btnReason_M addTarget:self action:@selector(btnReasonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnReason_M;
}
- (UIButton *)btnReason_R{
    if (!_btnReason_R) {
        _btnReason_R = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnReason_R setTitle:@"查看详情" forState:(UIControlStateNormal)];
        [_btnReason_R setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnReason_R.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnReason_R.layer.borderWidth = 1;
        _btnReason_R.layer.cornerRadius = 12.5;
        _btnReason_R.titleLabel.font = PFR13Font;
        _btnReason_R.layer.masksToBounds = YES;
        [_btnReason_R addTarget:self action:@selector(btnReasonAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnReason_R;
}

@end
