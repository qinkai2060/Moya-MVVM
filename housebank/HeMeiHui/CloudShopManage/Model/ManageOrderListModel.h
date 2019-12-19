//
//  ManageOrderListModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageOrderListModel : NSObject <NSCoding,JXModelProtocol>
@property (nonatomic, copy) NSString * id;         // 主键
@property (nonatomic, copy) NSString * orderType;  // 订单类型
@property (nonatomic, copy) NSString * orderId;    // 订单
@property (nonatomic, copy) NSString * productId;  // 产品id
@property (nonatomic, copy) NSString * salePrice;  // 销售价
@property (nonatomic, copy) NSString * costPrice;  // 成本价
@property (nonatomic, copy) NSString * sysPrice;   // 抵扣券
@property (nonatomic, copy) NSString * price;      // 现金
@property (nonatomic, copy) NSString * transportPrice; // 运费
@property (nonatomic, copy) NSString * shops;        // 商铺
@property (nonatomic, copy) NSString * couponAmount; // 优惠券
@property (nonatomic, copy) NSString * regCoupon;    // 注册券
@property (nonatomic, copy) NSString * orderState;   // 子订单状态
@property (nonatomic, copy) NSString * confirmReceiptDate; // 确认收货时间
@property (nonatomic, copy) NSString * productSpecificationsId; // 产品规格id
@property (nonatomic, copy) NSString * productCount ;    // 产品数量
@property (nonatomic, copy) NSString * returnState;  // 退款状态
@property (nonatomic, copy) NSString * productName;   // 商品名
@property (nonatomic, copy) NSString * imagePath;     // 图片路径
@property (nonatomic, copy) NSString * jointPictrue;   // 裁剪图片信息
@property (nonatomic, copy) NSString * specificationsName;//规格名
@property (nonatomic, copy) NSString * specificationsName0; //买/卖家商品规格
@property (nonatomic, copy) NSString * transportType;
@property (nonatomic, copy) NSString * isDistribution;

@end

NS_ASSUME_NONNULL_END
