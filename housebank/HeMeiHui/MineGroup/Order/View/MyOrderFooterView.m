//
//  MyOrderFooterView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderFooterView.h"
#import "UIView+addGradientLayer.h"
#import "JudgeOrderType.h"
@implementation MyOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
//计算商品总数
- (NSInteger) calculateNum{
    NSArray *arr = [NSArray arrayWithArray:_infoListModel.orderProductList];
    NSInteger count = 0;
    for (int i = 0; i < arr.count; i++) {
        MyOrderProductListModel *model = (MyOrderProductListModel *)arr[i];
        count = count + [model.productCount integerValue];
    }
    return count;
}
#pragma mark - model
- (void)setInfoListModel:(OrderInfoListModel *)infoListModel{
    _infoListModel = infoListModel;
    if ([JudgeOrderType judgeStoreOrderType:infoListModel.orderBizCategory]) {
        //商城订单
        [self noGlobalHomeOrder];
    } else if ([JudgeOrderType judgeOTOOrderType:infoListModel.orderBizCategory]){
        //新零售 云店
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judgeCloudOrderType:infoListModel.orderBizCategory]){
        // 云店
        [self noGlobalHomeOrder];
        
    }else if ([JudgeOrderType judgeGlobalHomeOrderType:infoListModel.orderBizCategory]){
        //全球家
        [self globalHomeOrder];
        
    } else if ([JudgeOrderType judgeDelegateOrderType:infoListModel.orderBizCategory]){
        //代理
        [self noGlobalHomeOrder];
        
    } else if ([JudgeOrderType judgeWelfareOrderType:infoListModel.orderBizCategory]){
        //福利
        [self WelfareGoodOrder];
        
        
    } else if ([JudgeOrderType judge_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        [self noGlobalHomeOrder];
        
    }else if ([JudgeOrderType judge_D_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        [self noGlobalHomeOrder];
        
    }else if ([JudgeOrderType judge_S_ZC_RM_OrderType:infoListModel.orderBizCategory]){
        //rm
        [self noGlobalHomeOrder];
        
    }
}

- (void)WelfareGoodOrder{
    [self noGlobalHomeOrder];
    self.remainingMarginLable.hidden = NO;
    NSString *welfareRemain = [NSString stringWithFormat:@"￥%@", _infoListModel.welfareRemain];
    NSString *allwelfareRemain=[NSString stringWithFormat:@"本月额度剩余：%@", welfareRemain];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allwelfareRemain];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(allwelfareRemain.length - welfareRemain.length,welfareRemain.length)];
    
    self.remainingMarginLable.attributedText = str;
}
//非全球家订单 非oto
//<!-- 1待支付 2待发货 3待收货 4退货中 5已退货 6已取消 7已完成 8已分润 9已终止 10已评价 -->
- (void)noGlobalHomeOrder{
    _numLabel.text = [NSString stringWithFormat:@"共%ld件商品   合计：￥",(long)[self calculateNum]];
    _moneyLabel.text =  [JudgeOrderType positiveFormat:[NSString stringWithFormat:@"%.2f",[_infoListModel.allPrice floatValue]]];
    
    switch ([_infoListModel.orderState integerValue]) {
        case 1://待支付    取消订单   去付款
            [self isShowBtn:@[self.btnCanceloOrder, self.btnGoPay]];
            break;
        case 2://待发货
        {
            if ([JudgeOrderType judgeOTOOrderType:_infoListModel.orderBizCategory]) {
          
                if ([_infoListModel.isDistribution isEqual: @(0)]) {
                    //自提  没这个状态
                    
                } else if ([_infoListModel.isDistribution isEqual: @(1)]){
                    //快递 我要催单
                    [self isShowBtn: @[self.btnuUrgeOrder]];
                    
                } else if ([_infoListModel.isDistribution isEqual: @(2)]){
                    //闪送
                } else if ([_infoListModel.isDistribution isEqual: @(3)]){
                    //配送   没这个状态

                } else {
                    //快递 我要催单(如果等于null)
                    [self isShowBtn: @[self.btnuUrgeOrder]];
                    
                }
            } else {
                //快递
                [self isShowBtn: @[self.btnuUrgeOrder]];
            }
        }
            break;
        case 3://待收货
        {
            if ([JudgeOrderType judgeOTOOrderType:_infoListModel.orderBizCategory]) {
                
                if ([_infoListModel.isDistribution isEqual: @(0)]) {
                    //自提 核销码
                    [self isShowBtn: @[self.btnVerifyCode]];
                    
                } else if ([_infoListModel.isDistribution isEqual: @(1)]){
                    //快递
                    [self isShowBtn: @[self.btnViewLogistics_M, self.btnSure]];
                    
                } else if ([_infoListModel.isDistribution isEqual: @(2)]){
                    //闪送
                } else if ([_infoListModel.isDistribution isEqual: @(3)]){
                    //配送   核销
                    [self isShowBtn: @[self.btnVerifyCode_M, self.btnSurePS]];
                } else {
                    //快递
                    [self isShowBtn: @[self.btnViewLogistics_M, self.btnSure]];

                }
            } else {
                //快递 查看物流 确认收货
                [self isShowBtn: @[self.btnViewLogistics_M, self.btnSure]];
            }
        }
            break;
        case 4://退货中

            break;
        case 5://已退货
            
            break;
        case 6://已取消
            //删除
//            [self isShowBtn: @[self.btnDelete]];
            break;
        case 7://已完成
            if (CHECK_STRING_ISNULL(_infoListModel.commented)) {
                [self isShowBtn: @[self.btnViewLogistics_M, self.btnEvaluate]];
            } else {
                if ([_infoListModel.commented integerValue] == 1) {//已评价
                    [self isShowBtn: @[self.btnViewLogistics_R]];
                } else {
                    [self isShowBtn: @[self.btnViewLogistics_M, self.btnEvaluate]];
                }
            }
            break;
        case 8://已分润
            //删除
//            [self isShowBtn: @[self.btnDelete]];
            break;
            
        default:
            //已完成
            break;
    }
      
}
//全球家订单
- (void)globalHomeOrder{
    _numLabel.text = [NSString stringWithFormat:@"合计：￥"];
    _moneyLabel.text =  [JudgeOrderType positiveFormat:[NSString stringWithFormat:@"%.2f",[_infoListModel.allSalePrice floatValue]]];
    
    switch ([_infoListModel.orderState integerValue]) {
        case 0:
        {
            //待付款   btn:取消订单  去付款
            [self isShowBtn: @[self.btnCanceloOrder,self.btnGoPay]];
            
        }
            break;
        case 1:
        {
            //待入住 btn:再次预定  退订
            [self isShowBtn: @[self.btnBuyAgainL,self.btnBackOut]];
        }
            break;
        
            
        case 2:
        {
            //  <!-- 待评价 -->
             [self isShowBtn: @[self.btnBuyAgainL,self.btnGoEvaluate]];
           
        }
            break;
            //<!-- 全球家已完成3，全球家已取消4，全球家已退订6，全球家已失效7 -->
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        {
            //待确认 btn:再次预定
            [self isShowBtn: @[self.btnBuyAgainrR]];
        }
            break;
        case 9:
        {
            //待确认 btn:再次预定 退订
            [self isShowBtn: @[self.btnBuyAgainL,self.btnBackOut]];
        }
            break;
        default:
            [self isShowBtn: @[self.btnBuyAgainrR]];
            break;
    }
}

/**
 显示btn
 
 @param arr 传入要显示的btn
 */

- (void)isShowBtn:(NSArray *)arr{
       for (UIButton *btn in arr) {
           
           [self.bgView addSubview:btn];

           if (btn == self.btnGoPay || btn == self.btnuUrgeOrder  || btn == self.btnSure || btn == self.btnSurePS || btn == self.btnEvaluate  || btn == self.btnBuyAgainrR  || btn == self.btnGoEvaluate || btn == self.btnCanceloOrderR || btn == self.btnBackOut || btn == self.btnRefun_R || btn == self.btnVerifyCode || btn == self.btnDelete || btn == self.btnViewLogistics_R) {
               [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.bottom.equalTo(self.bgView).offset(-15);
                       make.right.equalTo(self.bgView).offset(-10);
                       make.size.mas_equalTo(CGSizeMake(75, 25));
               }];

           } else if (btn == self.btnCanceloOrder  || btn == self.btnViewLogistics_M || btn == self.btnBuyAgainL || btn == self.btnRefun_M || btn == self.btnVerifyCode_M) {
               [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.bottom.equalTo(self.bgView).offset(-15);
                   make.right.equalTo(self.bgView).offset(-95);
                   make.size.mas_equalTo(CGSizeMake(75, 25));
               }];
           } else {
               [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.bottom.equalTo(self.bgView).offset(-15);
                   make.right.equalTo(self.bgView).offset(-180);
                   make.size.mas_equalTo(CGSizeMake(75, 25));
               }];
           }
           
           if (btn == self.btnGoPay || btn == self.btnSure || btn == self.btnSurePS || btn == self.btnVerifyCode || btn == self.btnVerifyCode_M) {
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
    

    [self.bgView addSubview:self.remainingMarginLable];
    
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
    
    [self.remainingMarginLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(12);
        make.bottom.equalTo(self.bgView).offset(-15);
        make.right.equalTo(self.bgView).offset(-180);
        make.height.mas_equalTo(25);
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


/**
 付款
 */
- (void)btnGoPayAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeGoPay, self.tag - 2000);
    }
}
- (UIButton *)btnGoPay{
    if (!_btnGoPay) {
        _btnGoPay = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnGoPay setTitle:@"付款" forState:(UIControlStateNormal)];
        [_btnGoPay setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnGoPay.backgroundColor = HEXCOLOR(0xFF0000);
        _btnGoPay.layer.cornerRadius = 12.5;
        _btnGoPay.titleLabel.font = PFR13Font;
        _btnGoPay.layer.masksToBounds = YES;
        //        _btnGoPay.hidden = YES;
        [_btnGoPay addTarget:self action:@selector(btnGoPayAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnGoPay;
}
/**
 取消订单
 */
- (void)btnCanceloOrderAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeCanceloOrder, self.tag - 2000);
    }
}
- (UIButton *)btnCanceloOrder{
    if (!_btnCanceloOrder) {
        _btnCanceloOrder = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnCanceloOrder setTitle:@"取消订单" forState:(UIControlStateNormal)];
        [_btnCanceloOrder setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnCanceloOrder.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnCanceloOrder.layer.borderWidth = 1;
        _btnCanceloOrder.layer.cornerRadius = 12.5;
        _btnCanceloOrder.titleLabel.font = PFR13Font;
        //        _btnCanceloOrder.hidden = YES;
        _btnCanceloOrder.layer.masksToBounds = YES;
        [_btnCanceloOrder addTarget:self action:@selector(btnCanceloOrderAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnCanceloOrder;
}

/**
 催单
 */
-(void)btnuUrgeOrderAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeUrgeOrder, self.tag - 2000);
    }
}
- (UIButton *)btnuUrgeOrder{
    if (!_btnuUrgeOrder) {
        _btnuUrgeOrder = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnuUrgeOrder setTitle:@"我要催单" forState:(UIControlStateNormal)];
        [_btnuUrgeOrder setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnuUrgeOrder.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnuUrgeOrder.layer.borderWidth = 1;
        _btnuUrgeOrder.layer.cornerRadius = 12.5;
        _btnuUrgeOrder.layer.masksToBounds = YES;
        //        _btnuUrgeOrder.hidden = YES;
        _btnuUrgeOrder.titleLabel.font = PFR13Font;
        [_btnuUrgeOrder addTarget:self action:@selector(btnuUrgeOrderAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnuUrgeOrder;
}
/**
 确认收货
 */
- (void)btnSureAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeSure, self.tag - 2000);
    }
}
- (UIButton *)btnSure{
    if (!_btnSure) {
        _btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnSure setTitle:@"确认收货" forState:(UIControlStateNormal)];
        [_btnSure setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnSure.backgroundColor = HEXCOLOR(0xFF0000);
        _btnSure.layer.cornerRadius = 12.5;
        _btnSure.layer.masksToBounds = YES;
        //        _btnSure.hidden = YES;
        _btnSure.titleLabel.font = PFR13Font;
        [_btnSure addTarget:self action:@selector(btnSureAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnSure;
}
/**
 确认收货
 */
- (void)btnSurePSAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeSurePS, self.tag - 2000);
    }
}
- (UIButton *)btnSurePS{
    if (!_btnSurePS) {
        _btnSurePS = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnSurePS setTitle:@"确认收货" forState:(UIControlStateNormal)];
        [_btnSurePS setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnSurePS.backgroundColor = HEXCOLOR(0xFF0000);
        _btnSurePS.layer.cornerRadius = 12.5;
        _btnSurePS.layer.masksToBounds = YES;
        //        _btnSure.hidden = YES;
        _btnSurePS.titleLabel.font = PFR13Font;
        [_btnSurePS addTarget:self action:@selector(btnSurePSAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnSurePS;
}
/**
 查看物流
 */
- (void)btnViewLogisticsAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeViewLogistics, self.tag - 2000);
    }
}
- (UIButton *)btnViewLogistics_R{
    if (!_btnViewLogistics_R) {
        _btnViewLogistics_R = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnViewLogistics_R setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [_btnViewLogistics_R setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnViewLogistics_R.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnViewLogistics_R.layer.borderWidth = 1;
        _btnViewLogistics_R.layer.cornerRadius = 12.5;
        _btnViewLogistics_R.layer.masksToBounds = YES;
        //        _btnViewLogistics.hidden = YES;
        _btnViewLogistics_R.titleLabel.font = PFR13Font;
        [_btnViewLogistics_R addTarget:self action:@selector(btnViewLogisticsAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnViewLogistics_R;
}
- (UIButton *)btnViewLogistics_M{
    if (!_btnViewLogistics_M) {
        _btnViewLogistics_M = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnViewLogistics_M setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [_btnViewLogistics_M setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnViewLogistics_M.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnViewLogistics_M.layer.borderWidth = 1;
        _btnViewLogistics_M.layer.cornerRadius = 12.5;
        _btnViewLogistics_M.layer.masksToBounds = YES;
        //        _btnViewLogistics.hidden = YES;
        _btnViewLogistics_M.titleLabel.font = PFR13Font;
        [_btnViewLogistics_M addTarget:self action:@selector(btnViewLogisticsAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnViewLogistics_M;
}
/**
 评价
 */
- (void)btnEvaluateAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeEvaluate, self.tag - 2000);
    }
}
- (UIButton *)btnEvaluate{
    if (!_btnEvaluate) {
        _btnEvaluate = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnEvaluate setTitle:@"评价" forState:(UIControlStateNormal)];
        [_btnEvaluate setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnEvaluate.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnEvaluate.layer.borderWidth = 1;
        _btnEvaluate.layer.cornerRadius = 12.5;
        _btnEvaluate.layer.masksToBounds = YES;
        //        _btnEvaluate.hidden = YES;
        _btnEvaluate.titleLabel.font = PFR13Font;
        [_btnEvaluate addTarget:self action:@selector(btnEvaluateAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnEvaluate;
}
/**
 再次预定左
 */
- (void)btnBuyAgainLAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeGoBugAgain, self.tag - 2000);
    }
}
- (UIButton *)btnBuyAgainL{
    if (!_btnBuyAgainL) {
        _btnBuyAgainL = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnBuyAgainL setTitle:@"再次预定" forState:(UIControlStateNormal)];
        [_btnBuyAgainL setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnBuyAgainL.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnBuyAgainL.layer.borderWidth = 1;
        _btnBuyAgainL.layer.cornerRadius = 12.5;
        _btnBuyAgainL.titleLabel.font = PFR13Font;
        //        _btnBuyAgainL.hidden = YES;
        _btnBuyAgainL.layer.masksToBounds = YES;
        [_btnBuyAgainL addTarget:self action:@selector(btnBuyAgainLAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnBuyAgainL;
}

/**
 再次预定右
 */
- (UIButton *)btnBuyAgainrR{
    if (!_btnBuyAgainrR) {
        _btnBuyAgainrR = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnBuyAgainrR setTitle:@"再次预定" forState:(UIControlStateNormal)];
        [_btnBuyAgainrR setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnBuyAgainrR.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnBuyAgainrR.layer.borderWidth = 1;
        _btnBuyAgainrR.layer.cornerRadius = 12.5;
        _btnBuyAgainrR.titleLabel.font = PFR13Font;
        //        _btnBuyAgainrR.hidden = YES;
        _btnBuyAgainrR.layer.masksToBounds = YES;
        [_btnBuyAgainrR addTarget:self action:@selector(btnBuyAgainLAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnBuyAgainrR;
}
/**
 去点评
 */
- (UIButton *)btnGoEvaluate{
    if (!_btnGoEvaluate) {
        _btnGoEvaluate = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnGoEvaluate setTitle:@"去点评" forState:(UIControlStateNormal)];
        [_btnGoEvaluate setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnGoEvaluate.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnGoEvaluate.layer.borderWidth = 1;
        _btnGoEvaluate.layer.cornerRadius = 12.5;
        _btnGoEvaluate.titleLabel.font = PFR13Font;
        //        _btnGoEvaluate.hidden = YES;
        _btnGoEvaluate.layer.masksToBounds = YES;
        [_btnGoEvaluate addTarget:self action:@selector(btnEvaluateAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnGoEvaluate;
}
/**
 又取消订单
 */

- (UIButton *)btnCanceloOrderR{
    if (!_btnCanceloOrderR) {
        _btnCanceloOrderR = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnCanceloOrderR setTitle:@"取消订单" forState:(UIControlStateNormal)];
        [_btnCanceloOrderR setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnCanceloOrderR.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnCanceloOrderR.layer.borderWidth = 1;
        _btnCanceloOrderR.layer.cornerRadius = 12.5;
        _btnCanceloOrderR.titleLabel.font = PFR13Font;
        //        _btnCanceloOrderR.hidden = YES;
        _btnCanceloOrderR.layer.masksToBounds = YES;
        [_btnCanceloOrderR addTarget:self action:@selector(btnCanceloOrderAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnCanceloOrderR;
}

- (void)btnBackOutAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeBackOut, self.tag - 2000);
    }
}
- (UIButton *)btnBackOut{
    if (!_btnBackOut) {
        _btnBackOut = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnBackOut setTitle:@"退订" forState:(UIControlStateNormal)];
        [_btnBackOut setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnBackOut.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnBackOut.layer.borderWidth = 1;
        _btnBackOut.layer.cornerRadius = 12.5;
        _btnBackOut.titleLabel.font = PFR13Font;
        //        _btnBackOut.hidden = YES;
        _btnBackOut.layer.masksToBounds = YES;
        [_btnBackOut addTarget:self action:@selector(btnBackOutAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnBackOut;
}
//退款 右
- (void)btnRefunAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeRefun, self.tag - 2000);
    }
}
- (UIButton *)btnRefun_R{
    if (!_btnRefun_R) {
        _btnRefun_R = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRefun_R setTitle:@"退款" forState:(UIControlStateNormal)];
        [_btnRefun_R setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnRefun_R.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnRefun_R.layer.borderWidth = 1;
        _btnRefun_R.layer.cornerRadius = 12.5;
        _btnRefun_R.titleLabel.font = PFR13Font;
        _btnRefun_R.layer.masksToBounds = YES;
        [_btnRefun_R addTarget:self action:@selector(btnRefunAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnRefun_R;
}
//退款 中
- (UIButton *)btnRefun_M{
    if (!_btnRefun_M) {
        _btnRefun_M = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRefun_M setTitle:@"退款" forState:(UIControlStateNormal)];
        [_btnRefun_M setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnRefun_M.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnRefun_M.layer.borderWidth = 1;
        _btnRefun_M.layer.cornerRadius = 12.5;
        _btnRefun_M.titleLabel.font = PFR13Font;
        _btnRefun_M.layer.masksToBounds = YES;
        [_btnRefun_M addTarget:self action:@selector(btnRefunAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnRefun_M;
}
//退款 左
- (UIButton *)btnRefun_L{
    if (!_btnRefun_L) {
        _btnRefun_L = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnRefun_L setTitle:@"退款" forState:(UIControlStateNormal)];
        [_btnRefun_L setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnRefun_L.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnRefun_L.layer.borderWidth = 1;
        _btnRefun_L.layer.cornerRadius = 12.5;
        _btnRefun_L.titleLabel.font = PFR13Font;
        _btnRefun_L.layer.masksToBounds = YES;
        [_btnRefun_L addTarget:self action:@selector(btnRefunAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnRefun_L;
}
//核销码
- (void)btnVerifyCodeAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeVerifyCode, self.tag - 2000);
    }
}
- (UIButton *)btnVerifyCode{
    if (!_btnVerifyCode) {
        _btnVerifyCode = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnVerifyCode setTitle:@"核销码" forState:(UIControlStateNormal)];
        [_btnVerifyCode setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnVerifyCode.backgroundColor = HEXCOLOR(0xFF0000);
        _btnVerifyCode.layer.cornerRadius = 12.5;
        _btnVerifyCode.titleLabel.font = PFR13Font;
        _btnVerifyCode.layer.masksToBounds = YES;
        [_btnVerifyCode addTarget:self action:@selector(btnVerifyCodeAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnVerifyCode;
}

- (UIButton *)btnVerifyCode_M{
    if (!_btnVerifyCode_M) {
        _btnVerifyCode_M = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnVerifyCode_M setTitle:@"核销码" forState:(UIControlStateNormal)];
        [_btnVerifyCode_M setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _btnVerifyCode_M.backgroundColor = HEXCOLOR(0xFF0000);
        _btnVerifyCode_M.layer.cornerRadius = 12.5;
        _btnVerifyCode_M.titleLabel.font = PFR13Font;
        _btnVerifyCode_M.layer.masksToBounds = YES;
        [_btnVerifyCode_M addTarget:self action:@selector(btnVerifyCodeAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnVerifyCode_M;
}

/**
 删除
 */
- (void)btnDeleteAction{
    if (self.clickBlock) {
        self.clickBlock(MyOrderFooterViewTypeDelete, self.tag - 2000);
    }
}
- (UIButton *)btnDelete{
    if (!_btnDelete) {
        _btnDelete = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnDelete setTitle:@"删除" forState:(UIControlStateNormal)];
        [_btnDelete setTitleColor:HEXCOLOR(0x666666) forState:(UIControlStateNormal)];
        _btnDelete.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        _btnDelete.layer.borderWidth = 1;
        _btnDelete.layer.cornerRadius = 12.5;
        _btnDelete.titleLabel.font = PFR13Font;
        _btnDelete.layer.masksToBounds = YES;
        [_btnDelete addTarget:self action:@selector(btnDeleteAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _btnDelete;
}


- (UILabel *)remainingMarginLable{
    if (!_remainingMarginLable) {
        _remainingMarginLable = [[UILabel alloc] init];
        _remainingMarginLable.text = @"本月额度剩余：";
        _remainingMarginLable.hidden = YES;
        _remainingMarginLable.textColor = HEXCOLOR(0x333333);
        _remainingMarginLable.font = [UIFont systemFontOfSize:12];
        _remainingMarginLable.textAlignment = NSTextAlignmentLeft;
    }
    return _remainingMarginLable;
}
@end
