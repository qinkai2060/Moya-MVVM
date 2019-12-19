//
//  YunDianNewRefundDetailModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YunDianNewRefundBuyerOrSellerRefundImagesMode.h"
#import "YunDianNewRefundOrderProductModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundDetailModel : NSObject
@property (nonatomic, strong) NSNumber * refundNo;//退单编号

@property (nonatomic, copy) NSString *orderBizCategory;//订单类型

@property (nonatomic, copy) NSString *remark;//买家申请理由

@property (nonatomic, copy) NSString *reason;//卖家拒绝理由

@property (nonatomic, copy) NSString *arbitrateRemark;//仲裁理由

@property (nonatomic, strong) NSNumber *returnState ;//退款状态：1（买家=退款中，卖家=退款待处理），2（撤销退款），3（商家拒绝退款），4（商家同意退款），5（退款待仲裁），6（仲裁拒绝退款），7（仲裁同意退款），4跟7都表示已退款
@property (nonatomic, strong) NSNumber *returnMoney;//退款金额

@property (nonatomic, strong) NSNumber *sysPrice;//抵扣券

@property (nonatomic, strong) NSNumber *couponAmount;//优惠券

@property (nonatomic, strong) NSNumber *regCoupon;//注册券

@property (nonatomic, copy) NSString *createDate;//退款申请时间

@property (nonatomic, copy) NSString *operatorDate;//所有操作时间（包含卖家处理时间，买家仲裁时间）

@property (nonatomic, copy) NSString *updateDate;//卖家操作时间

@property (nonatomic, copy) NSString *arbitrateDate;//仲裁时间，平台操作时间

@property (nonatomic, strong) NSNumber *applyRemindInvalidTimestamp;//退款单申请剩余失效时间  小于0，表示申请超时未处理

@property (nonatomic, copy) NSString *sellerPhone;//卖家电话

@property (nonatomic, strong) NSNumber *autoRefund;//是否自动退款，1=系统自动退款，0=用户申请退款

@property (nonatomic,strong) YunDianNewRefundOrderProductModel  *orderProduct;//子单信息

@property (nonatomic,strong) NSArray <YunDianNewRefundBuyerOrSellerRefundImagesMode *> *buyerRefundImages;//买家申请退款图片

@property (nonatomic,strong) NSArray <YunDianNewRefundBuyerOrSellerRefundImagesMode *> *sellerRefundImages;//卖家拒绝图片

@end

NS_ASSUME_NONNULL_END
