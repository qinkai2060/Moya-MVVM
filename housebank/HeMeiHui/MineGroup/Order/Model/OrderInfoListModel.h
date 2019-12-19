//
//  OrderInfoListModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrderProductListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderInfoListModel : NSObject
@property (nonatomic, copy) NSString *order_id;//id
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, strong) NSNumber *shopsId;//店铺id
@property (nonatomic, strong) NSNumber *createDate;//下单时间
@property (nonatomic, strong) NSNumber *allPrice;//总金额
@property (nonatomic, strong) NSNumber *orderState;//订单状态
@property (nonatomic, strong) NSNumber *isDistribution;//OTO订单配送方式 1:全国配送；0:自提；2:闪送
@property (nonatomic, copy) NSString *commented;//订单是否评价，0未评价，1已评价;/
@property (nonatomic, strong) NSNumber *hotelId;//房间id
@property (nonatomic, strong) NSString *orderBizCategory;//订单业务类型
@property (nonatomic, strong) NSString *shopsName;//店铺名称
@property (nonatomic, strong) NSString *hotelTitle;//酒店名称
@property (nonatomic, strong) NSString *houseTitle;//房间标题
@property (nonatomic, strong) NSString *imgUrl;//房间图片图片
@property (nonatomic, strong) NSNumber *breakfast;//1含早 2单早 其他:无早
@property (nonatomic, strong) NSNumber *allSalePrice;//全球家总售价
@property (nonatomic, strong) NSNumber *accommodationDays;//全球家共几天
@property (nonatomic, copy) NSString *bookCheckinTime;//全球家入住时间
@property (nonatomic, copy) NSString *checkoutTime;//全球家退房时间
@property (nonatomic, strong) NSNumber *welfareRemain;//福利订单剩余额度

@property (nonatomic,strong) NSArray<MyOrderProductListModel *> *orderProductList;
@end

NS_ASSUME_NONNULL_END
