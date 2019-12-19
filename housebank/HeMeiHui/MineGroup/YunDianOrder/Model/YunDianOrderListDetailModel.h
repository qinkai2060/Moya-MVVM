//
//  YunDianOrderListDetailModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YunDianorderDetailProductListModel.h"
#import "YunDianOrderAddress.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderListDetailModel : NSObject
@property (nonatomic, copy) NSString *wl_id;//查看物流的id;
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *commodityType;//商品类型
@property (nonatomic, copy) NSString *shareprofitMoney;//金额
@property (nonatomic, copy) NSString *productType;//产品类型
@property (nonatomic, copy) NSString *orderPrice;//订单金额
@property (nonatomic, copy) NSString *transportPrice;//运费
@property (nonatomic, copy) NSString *sysPrice;//抵扣券
@property (nonatomic, copy) NSString *payPrice;//支付现金
@property (nonatomic, copy) NSString *price;//现金
@property (nonatomic, copy) NSString *productCount;//购买的产品数量
@property (nonatomic, copy) NSString *salePrice;//下单时的产品销售价
@property (nonatomic, copy) NSString *createUser;//创建人
@property (nonatomic, copy) NSString *updateDate;//修改时间
@property (nonatomic, copy) NSString *updateUser;//修改人
@property (nonatomic, copy) NSString *orderState;//订单状态
@property (nonatomic, copy) NSString *code;//规格
@property (nonatomic, copy) NSString *name;//收货人
@property (nonatomic, copy) NSString *phone;//收货人号码
@property (nonatomic, copy) NSString *loginName;//发货人
@property (nonatomic, copy) NSString *productPrice;//产品价格
@property (nonatomic, copy) NSString *productName;//产品名称
@property (nonatomic, copy) NSString *classifyName;//分类类别
@property (nonatomic, copy) NSString *completeAddress;//收货地址
@property (nonatomic, copy) NSString *pid ;//商品id
@property (nonatomic, copy) NSString *orderCreatTime;//订单创建时间
@property (nonatomic, copy) NSString *orderPayTime;//订单支付时间
@property (nonatomic, copy) NSString *orderCancelTime ;//订单取消时间
@property (nonatomic, copy) NSString *deliverTime;//发货时间
@property (nonatomic, copy) NSString *sureReserviceTime;//确认到货时间
@property (nonatomic, copy) NSString *returnRequestTime;//退货申请时间
@property (nonatomic, copy) NSString *returnDate;//退货时间
@property (nonatomic, copy) NSString *regCoupon;//使用注册券
@property (nonatomic, copy) NSString *useCashAsset;//余额
@property (nonatomic, copy) NSString *payDate;//支付时间
@property (nonatomic, copy) NSString *specifications;//规格名
@property (nonatomic, copy) NSString *orderBizCategory;//订单业务类型
@property (nonatomic, copy) NSString *shopsName;//店铺名称
@property (nonatomic, copy) NSString *remarks;//买家留言
/**
 福利订单 P_BIZ_WELFARE_ORDER、
 直供订单 P_BIZ_DIRECT_SUPPLY_ORDER、
 RM礼包订单 P_BIZ_REGISTRATION_ORDER、
 P_BIZ_PROXY_REG_ORDER、
 P_BIZ_UPREGISTRATION_ORDER
 、P_BIZ_RM_GIFT_PACKS_ORDER
 代理订单 P_BIZ_AGENT_ORDER
 */
@property (nonatomic, copy) NSString *state;//退款状态
@property (nonatomic, copy) NSString *spareMoney;//结算余款
@property (nonatomic, copy) NSString *memberLevel;//会员等级id
@property (nonatomic, strong) NSNumber *productActiveId;
@property (nonatomic, strong) NSNumber *shopsType;
@property (nonatomic, strong) NSNumber *isDistribution;//配送方式
@property (nonatomic, copy) NSString * platformCommission;// 平台佣金
@property (nonatomic, copy) NSString * businessCashReceivable; // 商家应收现金
@property (nonatomic, copy) NSString * costPrice; // 商品成本
@property (nonatomic,strong) NSArray <YunDianorderDetailProductListModel *> *orderProductList;
@property (nonatomic,strong) YunDianOrderAddress *orderReceiptAddress;
@end

NS_ASSUME_NONNULL_END
