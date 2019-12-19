//
//  ManageOrderModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
#import "ManageOrderListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageOrderModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * id ;                  // 主键
@property (nonatomic, copy) NSString * orderNo ;             // 订单号
@property (nonatomic, copy) NSString * productType;          // 产品类型
@property (nonatomic, copy) NSString * payNo;                // 申请
@property (nonatomic, copy) NSString * payId;                // 支付流水
@property (nonatomic, copy) NSString * payType;              // 支付方式
@property (nonatomic, copy) NSString * transportType;        // 运输方式
@property (nonatomic, copy) NSString * orderPrice;           // 订单金额
@property (nonatomic, copy) NSString * transportPrice;       // 运费
@property (nonatomic, copy) NSString * sysPrice;             // 抵扣券
@property (nonatomic, copy) NSString * price;                // 现金
@property (nonatomic, copy) NSString * counterFee ;          // 手续费
@property (nonatomic, copy) NSString * remarks;              // 备注
@property (nonatomic, copy) NSString * state;                // 状态
@property (nonatomic, copy) NSString * salerId ;             // 卖家id
@property (nonatomic, copy) NSString * userId;               // 会员
@property (nonatomic, copy) NSString * agentId;              // 代理
@property (nonatomic, copy) NSString * shareUserId;          // 分享关联会员
@property (nonatomic, assign) NSInteger orderState;           // 订单状态
@property (nonatomic, copy) NSString * createDate ;          // 创建时间
@property (nonatomic, copy) NSString * payDate;              // 支付时间
@property (nonatomic, copy) NSString * createUser;           // 创建人
@property (nonatomic, copy) NSString * updateDate;           // 修改时间
@property (nonatomic, copy) NSString * updateUser;           // 修改人
@property (nonatomic, copy) NSString * confirmReceiptDate;   // 确认收货时间
@property (nonatomic, copy) NSString * returnDate;           // 退货时间
@property (nonatomic, copy) NSString * rebateId;
@property (nonatomic, copy) NSString * fenrunYn;
@property (nonatomic, copy) NSString * refBusinessId;        // 关联业务id
@property (nonatomic, copy) NSString * orderBizCategory;     // 订单业务类型
@property (nonatomic, copy) NSString * payApplyNo;           // 支付申请号
@property (nonatomic, copy) NSString * payMode;              // 支付方式
@property (nonatomic, copy) NSString * paymentTime;          // 支付时间
@property (nonatomic, copy) NSString * agtYetDeposit;        // 已付押金
@property (nonatomic, copy) NSString * shareprofitDate;      // 分润时间
@property (nonatomic, copy) NSString * identity;             // 待支付剩余时间
@property (nonatomic, copy) NSString * productActiveId;
@property (nonatomic, copy) NSString * productActiveType;      // 活动类型
@property (nonatomic, copy) NSString * couponAmount;           // 优惠券
@property (nonatomic, copy) NSString * mallGainConsumeAsset;   // 商城收益的20%现金资产使用额
@property (nonatomic, copy) NSString * mallGainAsset;          // 商城收益的80%现金资产使用额
@property (nonatomic, copy) NSString * cashAvailableAsset;     // 无手续费现金资产使用额
@property (nonatomic, copy) NSString * spareMoney;             // 结算余款
@property (nonatomic, copy) NSString * checkRemark;            // 审核备注
@property (nonatomic, copy) NSString * shopsId;                // 店铺ID
@property (nonatomic, copy) NSString * maxIntegralRatio;       // O2O订单抵扣券使用比例
@property (nonatomic, copy) NSString * productName;            // 产品名称
@property (nonatomic, copy) NSString * code ;                  // 产品规格
@property (nonatomic, copy) NSString * productCount;           // 数量
@property (nonatomic, copy) NSString * costPrice;              // 合发价
@property (nonatomic, copy) NSString * shopsImgUrl;             // 店铺图片
@property (nonatomic, copy) NSString * shopsJointPictrue;       // 店铺拼接图片
@property (nonatomic, strong) NSArray <ManageOrderListModel *> *orderProductList;

@end

NS_ASSUME_NONNULL_END
