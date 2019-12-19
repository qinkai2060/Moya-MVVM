//
//  YunDianRefundDetailModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunDianRefundDetailModel : NSObject
@property (nonatomic, copy) NSString *orderReturnId ;//退单id
@property (nonatomic, copy) NSString *orderId;//订单id
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *productCount;//商品数量
@property (nonatomic, copy) NSString *salePrice;//商品价格
@property (nonatomic, copy) NSString *productId;//商品id
@property (nonatomic, copy) NSString *orderProductId;
@property (nonatomic, copy) NSString *productName;//商品名称
@property (nonatomic, copy) NSString *specificationsName;//商品规格
@property (nonatomic, copy) NSString *productSubtitle;//商品副标题
@property (nonatomic, copy) NSString *imagePath;//商品图片地址
@property (nonatomic, copy) NSString *jointPicture;//商品剪辑图片
@property (nonatomic, copy) NSString *remark;//退货原因
@property (nonatomic, copy) NSString *returnMoney;//退款金额
@property (nonatomic, copy) NSString *updateDate;//确认退货时间
@property (nonatomic, copy) NSString *createDate;//申请时间
@property (nonatomic, copy) NSString *arbitrateDate;//拒绝退款时间
@property (nonatomic, copy) NSString *returnState;//默认先判断退款状态（正常状态该字段为空），退款状态，1=退款中，2=取消退款，3=拒绝退款，4=已退款
@property (nonatomic, copy) NSString *arbitrateRemark;//拒绝退款原因
@property (nonatomic, copy) NSString *state;//退单状态
@property (nonatomic, copy) NSString *playMoneyDate;//打款时间


@property (nonatomic, copy) NSString *regCoupon;//注册券
@property (nonatomic, copy) NSString *sysPrice;//抵扣券
@property (nonatomic, copy) NSString *transportPrice;//运费

@end

NS_ASSUME_NONNULL_END
