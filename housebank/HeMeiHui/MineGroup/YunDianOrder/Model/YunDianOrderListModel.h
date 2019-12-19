//
//  YunDianOrderListModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YunDianOrderProductsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderListModel : NSObject
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *orderId;//订单id
@property (nonatomic, strong) NSNumber *orderState;//订单状态
@property (nonatomic, strong) NSNumber *isSettlement;//是否结算
@property (nonatomic, strong) NSNumber *totalPrice;//总订单价格
@property (nonatomic, strong) NSNumber *transportPrice;//运费
@property (nonatomic, copy) NSString *shopsName;//商铺名称
@property (nonatomic, strong) NSNumber *shopsType;//商铺类型商铺类型 1=合发购，2=OTO，3=微店
@property (nonatomic, strong) NSNumber *shopsId;//商铺ID
@property (nonatomic, strong) NSNumber *distribution;//0：自提，1：快递，2：闪送，3：配送
@property (nonatomic, strong) NSNumber *returnState;//默认先判断退款状态（正常状态该字段为空），退款状态，1=退款中，2=取消退款，3=拒绝退款，4=已退款
@property (nonatomic, strong) NSArray <YunDianOrderProductsModel *> *orderProducts;//商品列表
@property (nonatomic, strong) NSNumber*commented;//评价 1已评价 0未评价
@property (nonatomic, copy) NSString *orderBizCategory;//订单类型
@end

NS_ASSUME_NONNULL_END
