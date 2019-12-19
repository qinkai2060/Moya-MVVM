//
//  YunDianorderDetailProductListModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunDianorderDetailProductListModel : NSObject
@property (nonatomic, strong) NSNumber *activeId;
@property (nonatomic, strong) NSNumber *productState;//商品状态
@property (nonatomic, copy) NSString *orderType;//订单类型
@property (nonatomic, copy) NSString *orderId;//订单
@property (nonatomic, copy) NSString *productId;//产品id
@property (nonatomic, copy) NSString *salePrice;//销售价
@property (nonatomic, copy) NSString *shops;//商铺
@property (nonatomic, copy) NSString *addShoppingCartType;//商品加购物车方式
@property (nonatomic, copy) NSString *regCoupon;//注册券
@property (nonatomic, copy) NSString *productLevel;//商品等级
@property (nonatomic, copy) NSString *orderState;//订单状态
@property (nonatomic, copy) NSString *confirmReceiptDate;//确认收货时间
@property (nonatomic, copy) NSString *productSpecificationsId;//产品规格id
@property (nonatomic, copy) NSString *productCount;//产品数量
@property (nonatomic, copy) NSString *productSubtitle;//子标题
@property (nonatomic, strong) NSNumber *state;//退款状态
@property (nonatomic, strong) NSNumber *returnState;//默认先判断退款状态（正常状态该字段为空），退款状态，1=退款中，2=取消退款，3=拒绝退款，4=已退款
@property (nonatomic, copy) NSString *productName;//商品名
@property (nonatomic, copy) NSString *specifications;//规格名
@property (nonatomic, copy) NSString *imagePath;//图片路径
@property (nonatomic, copy) NSString *jointPictrue ;//裁剪图片信息
@end

NS_ASSUME_NONNULL_END
