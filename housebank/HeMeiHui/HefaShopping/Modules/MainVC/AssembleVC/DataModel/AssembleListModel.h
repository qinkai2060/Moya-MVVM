//
//  AssembleListModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
@protocol DataItem//不带*号

@end
NS_ASSUME_NONNULL_BEGIN

@interface DataItem :NSObject
@property (nonatomic , assign) NSInteger              ID;// * 拼团活动Id
@property (nonatomic , assign) NSInteger              productId;//商品Id
@property (nonatomic , assign) NSInteger              activeType;// * 拼团类型，1：按拉新成团，2：按购买成团
@property (nonatomic , assign) NSInteger              activeNum;//团购人数
@property (nonatomic , copy) NSString              * activeTitle;//活动标题
@property (nonatomic , copy) NSString              * activeSubtitle1;// 副标题1
@property (nonatomic , copy) NSString              * activeSubtitle2;// * 副标题2
@property (nonatomic , assign) NSInteger              startDate;//* 活动开始时间
@property (nonatomic , assign) NSInteger              endDate;//活动结束时间
@property (nonatomic , copy) NSString              * imageUrl;// 商品图片地址
@property (nonatomic , copy) NSString              * jointPicture;//图片尾部拼接
@property (nonatomic , assign) float              price;//商品活动价格
@property (nonatomic , assign) float              naturalPrice;//商品普通价格
@property (nonatomic , assign) NSInteger              salesCount;// 销量
@property (nonatomic , assign) NSInteger              commodityType;//【静态属性】商品类型 0:普通商品, 1:虚拟商品, 2:优惠券商品, 3:OTO商品, 4:礼包商品
@property (nonatomic , assign) NSInteger              promotionType;//商品优惠价格，可能有多个时间段，搜索时候判断当前系统时间落在哪个时间段就用哪个优惠价格 
@property (nonatomic , assign) NSInteger              submitTime;//最后审核通过时间
@property (nonatomic , assign) NSInteger              createTime;// 创建时间
@property (nonatomic , assign) NSInteger              updateTime;//* 更新时间

@end


@interface AssembleListModel :SetBaseModel
@property (nonatomic , strong) NSArray <DataItem>              * data;

@end


NS_ASSUME_NONNULL_END
