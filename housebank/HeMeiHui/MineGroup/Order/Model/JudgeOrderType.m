//
//  JudgeOrderType.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "JudgeOrderType.h"

@implementation JudgeOrderType

//P_BIZ_SEC_KILL_ORDER 秒杀订单
+ (BOOL)judgeStoreOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_CATEGORY_MDD"] || [orderType isEqualToString:@"P_BIZ_OTO_MALL"] || [orderType isEqualToString:@"P_BIZ_DIRECT_SUPPLY_ORDER"] || [orderType isEqualToString:@"P_BIZ_SEC_KILL_ORDER"]) {
        return YES;
    }
    return NO;
}
+ (BOOL)judgeOTOOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_OTO_ORDER"] || [orderType isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        return YES;
    }
    return NO;
}
+ (BOOL)judgeCloudOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
        return YES;
    }
    return NO;
}
+ (BOOL)judgeGlobalHomeOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_CATEGORY_DD"] || [orderType isEqualToString:@"P_BIZ_OTO_GLOBAL_HOME"]) {
        return YES;
    }
    return NO;
}
+ (BOOL)judgeDelegateOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_AGENT_ORDER"]){
        return YES;
    }
    return NO;
}
+ (BOOL)judgeWelfareOrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_WELFARE_ORDER"]){
        return YES;
    }
    return NO;
}
+ (BOOL)judge_ZC_RM_OrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_REGISTRATION_ORDER"]){
        return YES;
    }
    return NO;
}
+ (BOOL)judge_D_ZC_RM_OrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_PROXY_REG_ORDER"]){
        return YES;
    }
    return NO;
}
+ (BOOL)judge_S_ZC_RM_OrderType:(NSString *)orderType{
    if ([orderType isEqualToString:@"P_BIZ_UPREGISTRATION_ORDER"]){
        return YES;
    }
    return NO;
}
+ (NSString *)getTimeStringWithYearMonthDay:(NSString *)yearMonthDay formatterType:(NSString *)type
{
    //任何时间string转date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:type];
    NSDate *date=[dateFormatter dateFromString:yearMonthDay];
    //时间date转时间戳
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}
+ (NSString *)timeStr:(NSString *)timeStr formatterType:(NSString *)type
{
    NSTimeInterval timer=[timeStr doubleValue];
    NSDate*date=[NSDate dateWithTimeIntervalSince1970:timer];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle=NSDateFormatterShortStyle;
    [formatter setDateFormat:type];
    NSString *str22=[formatter stringFromDate:date];
    
    
    return str22;
}
+ (NSString *)timeStr:(NSString *)timeStr{
    NSString *str = [JudgeOrderType getTimeStringWithYearMonthDay:timeStr formatterType:@"yyyy-MM-dd HH:mm:ss"];
    return [JudgeOrderType timeStr:str formatterType:@"MM月dd日"];
}
+ (NSString *)timeStrNYR:(NSString *)timeStr{
    NSString *str = [JudgeOrderType getTimeStringWithYearMonthDay:timeStr formatterType:@"yyyy-MM-dd HH:mm:ss"];
    return [JudgeOrderType timeStr:str formatterType:@"yyyyMMdd"];
}
+ (NSString *)positiveFormat:(NSString *)text{
    
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"#,###.##"];
        numberFormatter.maximumFractionDigits = 2;    //设置最大小数点后的位数
        numberFormatter.minimumFractionDigits = 2;
        return [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]]];
    }
    return @"";
}
+ (float)returnTableViewFooter:(OrderInfoListModel *)infoListModel{
    
    float height = 0;
    
    switch ([infoListModel.orderState integerValue]) {
        case 1://待支付    取消订单   去付款
            height = 70;
            break;
        case 2://待发货
        {
            if ([JudgeOrderType judgeOTOOrderType:infoListModel.orderBizCategory]) {
                
                if ([infoListModel.isDistribution isEqual: @(0)]) {
                    //自提  没这个状态
                    height = 30;
                } else if ([infoListModel.isDistribution isEqual: @(1)]){
                    //快递 我要催单
                    height = 70;
                    
                } else if ([infoListModel.isDistribution isEqual: @(2)]){
                    //闪送
                    height = 30;
                } else if ([infoListModel.isDistribution isEqual: @(3)]){
                    //配送   没这个状态
                    height = 30;
                } else {
                    //快递 我要催单(如果等于null)
                    height = 70;
                    
                }
            } else {
                //快递
                height = 70;
            }
        }
            break;
        case 3://待收货
        {
            if ([JudgeOrderType judgeOTOOrderType:infoListModel.orderBizCategory]) {
                
                if ([infoListModel.isDistribution isEqual: @(0)]) {
                    //自提 核销码
                    height = 70;
                    
                } else if ([infoListModel.isDistribution isEqual: @(1)]){
                    //快递
                    height = 70;
                    
                } else if ([infoListModel.isDistribution isEqual: @(2)]){
                    //闪送
                    height = 30;
                } else if ([infoListModel.isDistribution isEqual: @(3)]){
                    //配送   核销
                    height = 70;
                } else {
                    //快递
                    height = 70;
                    
                }
            } else {
                //快递 查看物流 确认收货
                height = 70;
            }
        }
            break;
        case 4://退货中
            height = 30;
            break;
        case 5://已退货
            height = 30;
            
            break;
        case 6://已取消
            //删除
            height = 70;
            
            break;
        case 7://已完成
            if (CHECK_STRING_ISNULL(infoListModel.commented)) {
                height = 70;
            } else {
                if ([infoListModel.commented integerValue] == 1) {//已评价
                    height = 70;
                } else {
                    height = 70;
                }
            }
            break;
        case 8://已分润
            //删除
            height = 70;
            break;
            
        default:
            //已完成
            height = 30;
            break;
    }
    
    
    return height;
    
}
+ (float)returnYunDianTableViewFooter:(YunDianOrderListModel *)orderListModel{
    float height = 30;
    
    
    
    if (CHECK_STRING_ISNULL(orderListModel.returnState)) {
        switch ([orderListModel.orderState integerValue]) {
            case 1:
            {
                //待付款
                
            }
                break;
            case 2:
            {
                //商城: 待发货 (退款, 发货)云店 _商家配送: 待配送(退款 配送) 云店 _自取: 待取货(退款 核销)   0：自提，1：快递，2：闪送，3：配送
                
                
                
                if (![orderListModel.shopsType isEqual:@(3)]) {// 微店没有发货
                    if ([orderListModel.distribution isEqual:@(0)]) {
                        
                    } else if ([orderListModel.distribution isEqual:@(1)]) {
                        //发货
                        height = 70;
                    } else if ([orderListModel.distribution isEqual:@(2)]) {
                        //闪送
                    } else if ([orderListModel.distribution isEqual:@(3)]) {
                        
                    } else {
                        //发货
                        if (![orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                        height = 70;
                        }
                    }
                    
                }
                
            }
                break;
            case 3:
            {
                
                //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
                // 0：自提，1：快递，2：闪送，3：配送
                if ([orderListModel.distribution isEqual:@(0)]) {
                    height = 70;
                    
                } else if ([orderListModel.distribution isEqual:@(1)]) {
                    height = 70;
                } else if ([orderListModel.distribution isEqual:@(2)]) {
                    //闪送
                } else if ([orderListModel.distribution isEqual:@(3)]) {
                    height = 70;
                } else {
                    if (![orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                        height = 70;
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
                if ([orderListModel.distribution isEqual:@(0)]) {
                    //没这个状态
                } else if ([orderListModel.distribution isEqual:@(1)]) {
                    height = 70;
                    
                } else if ([orderListModel.distribution isEqual:@(2)]) {
                    //没这个状态
                } else if ([orderListModel.distribution isEqual:@(3)]) {
                    //没这个状态
                    
                } else {
                    if (![orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                        height = 70;
                    }
                    
                }
            }
                break;
            case 8:
                //已完成
            {
                if ([orderListModel.distribution isEqual:@(0)]) {
                    //没这个状态
                } else if ([orderListModel.distribution isEqual:@(1)]) {
                    height = 70;
                    
                } else if ([orderListModel.distribution isEqual:@(2)]) {
                    //没这个状态
                } else if ([orderListModel.distribution isEqual:@(3)]) {
                    //没这个状态
                    
                } else {
                    if (![orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {//oto到店扫码没有查看物流
                        height = 70;
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
           height = 70;

        
//        if ( [orderListModel.returnState isEqual:@(2)]) {
//            //取消退款
//        }else if ( [orderListModel.returnState isEqual:@(3)]) {
//            //拒绝退款
//            height = 70;
//
//        }else if ( [orderListModel.returnState isEqual:@(1)]) {
//            //退款中
//            if ([orderListModel.shopsType isEqual:@(1)]) {
//                height = 70;
//
//            } else if ([orderListModel.shopsType isEqual:@(2)]){
//                if ([orderListModel.distribution isEqual:@(0)]) {
//
//                } else if ([orderListModel.distribution isEqual:@(1)]) {
//                    //查看物流
//                    height = 70;
//                } else if ([orderListModel.distribution isEqual:@(2)]) {
//                    //闪送
//                } else if ([orderListModel.distribution isEqual:@(3)]) {
//
//                } else {
//                    height = 70;
//                }
//            }
//        }else if ( [orderListModel.returnState isEqual:@(4)]) {
//            //已退款"
//
//        } else {
//
//        }
        
    }
    
    
    return height;
}


+ (float)returnYunDianDetailTableViewHeaderHeight:(YunDianOrderListDetailModel *)detailModel{
    float height = 220;
    
    
    if ([detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        //oto扫码订单
        height = 70;
    } else {
        
        if ([detailModel.isDistribution isEqual:@(0)]) {
            //自提
            height = 70;
        } else if ([detailModel.isDistribution isEqual:@(3)]) {//3：配送
            height = 145;//没物流
            
        } else if ([detailModel.isDistribution  isEqual:@(2)]) {
            //闪送
            height = 145;//先写死没物流
        } else {
            //快递
            
            switch ([detailModel.orderState integerValue]) {
                case 1:
                {
                    //待付款
                    height = 145;//没物流
                    
                    
                }
                    break;
                case 2:
                {
                    //待发货
                    height = 145;//没物流
                    
                }
                    break;
                case 3:
                {
                    //待收货
                    height = 220;
                    
                }
                    break;
                case 4:
                {
                    //退货中
                    height = 220;
                    
                }
                    break;
                case 5:
                {
                    //已退货
                    height = 220;
                    
                    
                }
                    break;
                case 6:
                {
                    //已取消
                    height = 145;
                    
                    
                }
                    break;
                case 7:
                {
                    //已完成
                    height = 220;
                    
                }
                    break;
                case 8:
                    //已完成待评价
                {
                    height = 220;
                    
                }
                    
                    
                    break;
                case 9:
                    //已终止
                {
                    height = 220;
                    
                }
                    break;
                case 10:
                    //已完成
                    height = 220;
                    
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    return height;
    
}
+ (BOOL)returnYunDianDetailTableViewFooter:(YunDianOrderListDetailModel *)orderListModel;
{    BOOL isShow = NO;
    //不是oto扫码订单
    if (![orderListModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        
        switch ([orderListModel.orderState integerValue]) {
            case 1:
            {
                //待付款
                
            }
                break;
            case 2:
            {
                //商城: 待发货 (发货)云店 _商家配送: 待配送(核销) 云店 _自取: 待取货(核销)   0：自提，1：快递，2：闪送，3：配送
                if (![orderListModel.shopsType isEqual:@(3)]) {// 微店没有发货
                    if ([orderListModel.isDistribution isEqual:@(0)]) {
                        
                    } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                        //发货
                        isShow = YES;
                    } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                        //闪送
                    } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                        
                    } else {
                        //发货
                        isShow = YES;
                    }
                    
                }
                
            }
                break;
            case 3:
            {
                //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
                // 0：自提，1：快递，2：闪送，3：配送
                if ([orderListModel.isDistribution isEqual:@(0)]) {
                    isShow = YES;
                    
                } else if ([orderListModel.isDistribution  isEqual:@(1)]) {
                    isShow = YES;
                } else if ([orderListModel.isDistribution  isEqual:@(2)]) {
                    //闪送
                } else if ([orderListModel.isDistribution  isEqual:@(3)]) {
                    isShow = YES;
                    
                } else {
                    isShow = YES;
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
                if ([orderListModel.isDistribution isEqual:@(0)]) {
                    
                } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                    //查看物流
                    isShow = YES;
                } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                    //闪送
                } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                    
                } else {
                    isShow = YES;
                }
                
            }
                break;
            case 8:
                //已完成
            {
                if ([orderListModel.isDistribution isEqual:@(0)]) {
                    
                } else if ([orderListModel.isDistribution isEqual:@(1)]) {
                    //查看物流
                    isShow = YES;
                } else if ([orderListModel.isDistribution isEqual:@(2)]) {
                    //闪送
                } else if ([orderListModel.isDistribution isEqual:@(3)]) {
                    
                } else {
                    isShow = YES;
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
    return isShow;
}
+ (BOOL)yunDianTableViewIsShowJS:(YunDianOrderListModel *)orderListModel{
    BOOL isShow = NO;
    
    switch ([orderListModel.orderState integerValue]) {
        case 1:
        {
            //待付款
            
            
        }
            break;
        case 2:
        {
            //商城: 待发货 (退款, 发货)云店 _商家配送: 待配送(退款 配送) 云店 _自取: 待取货(退款 核销)   0：自提，1：快递，2：闪送，3：配送
            
            
            
            
        }
            break;
        case 3:
        {
            //商城: 待收货 (查看物流 )云店 _商家配送: 配送中(核销) 云店 _自取
            
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
            if ([orderListModel.isSettlement integerValue] == 1) {
                isShow = YES;
            }
            
        }
            break;
        case 8:
            //已完成待评价
        {
            
        }
            
            
            break;
        case 9:
            //已终止
        {
            //            if ([orderListModel.isSettlement integerValue] == 1) {
            //                isShow = YES;
            //            }
        }
            break;
        case 10:
            //已完成
            //            if ([orderListModel.isSettlement integerValue] == 1) {
            //                isShow = YES;
            //            }
            break;
            
        default:
            break;
    }
    return isShow;
}



+ (NSString *)getSystemTimeString13
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    
    return timeString;
}


+ (NSString *)timeStr1000:(NSString *)timeStr1000 formatterType:(NSString *)type
{
    NSTimeInterval timer=[timeStr1000 doubleValue];
    NSDate*date=[NSDate dateWithTimeIntervalSince1970:timer / 1000.0];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle=NSDateFormatterShortStyle;
    [formatter setDateFormat:type];
    NSString *str22=[formatter stringFromDate:date];
    
    
    return str22;
}

@end
