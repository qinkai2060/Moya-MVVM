//
//  HFPaymentBaseModel.h
//  housebank
//
//  Created by usermac on 2018/11/13.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HFUserCouponModel;
typedef  NS_ENUM(NSInteger,HFOrderShopModelType) {
    HFOrderShopModelTypeNone = 1,
    HFOrderShopModelTypeSelected = 2,
    HFOrderShopModelTypeRegSelected = 3,
    HFOrderShopModelTypeMore = 4,
    HFOrderShopModelTypeOne
};


NS_ASSUME_NONNULL_BEGIN
@interface HFPaymentBaseModel : NSObject
@property (nonatomic, assign)  NSInteger    msgType;
@property (nonatomic, assign)  BOOL    isVIPPackage;// YES--VIP礼包 NO---忽略
@property (nonatomic, assign)  float        renderHeight;
/**
 是否有券
 */
@property(nonatomic,assign)  HFOrderShopModelType contentMode;
/**
 商铺名称
 */
@property(nonatomic,copy)  NSString *shopsName;
// discount 折扣  redpacket 红包 dispatching 配送 leaveword 留言 totalprices 总价
/**
 注册劵
 */
@property(nonatomic,assign)  CGFloat regCoupon;
/**
 抵扣劵
 */
@property(nonatomic,assign)  NSInteger availableAntegral;
/**
 商品
 */
@property(nonatomic,strong)  NSArray *shops;
/**
 优惠券集合 和用户绑定
 */
@property(nonatomic,strong) NSArray *userCouponList;
/**
 注册劵抵扣券集合 和用户绑定
 */
@property(nonatomic,strong) NSArray *couponList;

+ (HFUserCouponModel*)userCouponData:(NSInteger)shopId  userCouponList:(NSArray*)couponList;
/**
  购物车id 集合
 */
@property(nonatomic,copy)  NSString *shopids;
/**
 待定总价
 */
@property(nonatomic,assign)  CGFloat allIntegralPrice;
/**
 待定总价
 */
@property(nonatomic,assign)  CGFloat allPrice;
/**
 留言
 */
@property(nonatomic,copy)  NSString *leaveWord;
/**
 是否跨境
 */
@property(nonatomic,assign)  BOOL isAbroad;
/**
 身份证
 */
@property(nonatomic,copy)  NSString *identity;
/**
 商品id列表
 */
@property(nonatomic,copy)  NSString  *productIds;

- (void)getData:(NSDictionary *)data;
- (void)getDataVipPg:(NSDictionary*)data;
@end
@interface HFOrderShopModel:NSObject
@property (nonatomic, assign)  BOOL    isVIPPackage;
@property(nonatomic,strong) HFUserCouponModel *conpoumodel;
@property(nonatomic,assign)  NSInteger count;
/**
 购物车id
 */
@property(nonatomic,copy)  NSString *shopsId;
/**
 店铺名
 */
@property(nonatomic,copy)  NSString *shopsName;
/**
 是否有券
 */
@property(nonatomic,assign)  HFOrderShopModelType contentMode;
/**
 拥有优惠券
 */
@property(nonatomic,strong)  NSArray *selectCoupouList;
@property(nonatomic,assign)  CGFloat couponPrice;
/**
 店铺名
 */
@property(nonatomic,strong)  NSArray *commodityList;
/**
 单个店铺id
 */
@property(nonatomic,copy)  NSString *shopId;
/**
 获取运费店铺名
 */
@property(nonatomic,copy)  NSString *shopName;

/**
 单个店铺运费
 */
@property(nonatomic,assign)  CGFloat shopAllPostages;
/**
 单个店铺运费
 */
@property(nonatomic,assign)  CGFloat shopsProductPrice;
/**
 商品id列表
 */
@property(nonatomic,copy)  NSString  *productIds;

/**
 商品id列表
 */
@property(nonatomic,copy)  NSString  *textContent;


- (void)getData:(NSDictionary *)data;
+ (HFOrderShopModel*)userCouponData:(NSInteger)shopId  userCouponList:(NSArray*)shopList;

@end
@interface HFProuductModel:NSObject
/**
 imgPath 图片
 specificationsId 规格id
 name 商品titile
 count 商品数量
 price 价格
 productid 商品id
 specifications 规格参数
 */
@property(nonatomic,copy)  NSString *imgPath;
@property(nonatomic,copy)  NSString *specificationsId;
@property(nonatomic,copy)  NSString *name;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,copy)  NSString *productid;
@property(nonatomic,copy)  NSString *specifications;
@property(nonatomic,assign)  CGFloat postage;
@property(nonatomic,copy)  NSString *code1;
@property(nonatomic,copy)  NSString *code2;
@property(nonatomic,copy)  NSString *code3;
@property(nonatomic,copy)  NSString *code4;
@property(nonatomic,copy)  NSString *code5;
@property(nonatomic,copy)  NSString *typeTitle;
@property (nonatomic, assign)  BOOL    isVIPPackage;
/**
 是否有券
 */
@property(nonatomic,assign)  HFOrderShopModelType contentMode;
- (void)getData:(NSDictionary *)data;
@end
@interface HFCompouModel : NSObject
@property(nonatomic,assign)BOOL select;
@property(nonatomic,copy)  NSString *name;
@property(nonatomic,assign)  NSInteger value;
@end
@interface HFShopSumPriceModel : NSObject

- (void)getData:(NSDictionary *)data;
@end
@interface HFUserCouponModel : NSObject
@property(nonatomic,assign)NSInteger shopId;
@property(nonatomic,assign)NSInteger currenConpouId;
@property(nonatomic,assign)float postage;
@property(nonatomic,assign)float integralPrice;
@property(nonatomic,assign)float singleShopSumPrice;
@property(nonatomic,assign)float couponPrice;
@property(nonatomic,strong) NSArray *userCouponList;
@property(nonatomic,copy)NSArray *notAvailable;
@property(nonatomic,copy)NSArray *available;

@property(nonatomic,copy)NSArray *selectCouponList;
@property(nonatomic,assign)BOOL recommend;
- (void)getData:(NSDictionary *)data;
@end
@interface HFAvailableModel : NSObject
@property(nonatomic,assign)NSInteger availableId;
@property(nonatomic,copy)NSString *describe;
@property(nonatomic,assign)NSInteger couponReceiptId;
@property(nonatomic,copy)  NSString *title;
@property(nonatomic,assign)NSInteger method;
@property(nonatomic,copy)  NSString *startTime;
@property(nonatomic,copy)  NSString *endTime;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger withAmount;
@property(nonatomic,assign)NSInteger discountMoney;
@property(nonatomic,assign)NSInteger useLimit;
@property(nonatomic,assign)BOOL recommend;
@property(nonatomic,assign)NSInteger applyProduct;
@property(nonatomic,assign)BOOL pastDue;
@property(nonatomic,assign)BOOL selected;
- (void)getData:(NSDictionary *)data;
@end
NS_ASSUME_NONNULL_END
