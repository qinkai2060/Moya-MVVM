//
//  GoodsDetailModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol ProductPicsItem

@end

@protocol ProductAttributesListItem

@end
@protocol TopProductsItem

@end
@protocol PriceInfos

@end
@protocol RebateInfo

@end
NS_ASSUME_NONNULL_BEGIN
@interface SeckillInfo:NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              purchasedQuantity;//已购买数量（只针对秒杀）
@property (nonatomic , assign) NSInteger              stock;//秒杀库存
@property (nonatomic , assign) NSInteger              purchaseLimitation;//限购（0：不限，大于0 是实际限购数）
@property (nonatomic , assign) NSInteger              isSeckill;//是否是秒杀（0：否，1：是），针对当前商品的规格
@property (nonatomic , assign) CGFloat              noticeActivityStart;//下场活动开始时间，null 表示无活动。
@property (nonatomic , assign) NSInteger              isSeckillSeleted;//无用
@end

@interface ProductPicsItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , copy) NSString              * productType;
@property (nonatomic , assign) NSInteger              productHisId;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , assign) NSInteger              oreder;
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              createDate;
@property (nonatomic , assign) NSInteger              createUser;
@property (nonatomic , assign) NSInteger              updateDate;
@property (nonatomic , assign) NSInteger              updateUser;
@property (nonatomic , copy) NSString              * jointPictrue;
//@property (nonatomic , assign) NSInteger              productId;
//@property (nonatomic , copy) NSString              * productType;
//@property (nonatomic , assign) NSInteger             productHisId;
//@property (nonatomic , copy) NSString              * address;
//@property (nonatomic , assign) NSInteger              oreder;
//@property (nonatomic , assign) NSInteger              state;
//@property (nonatomic , assign) NSInteger              createDate;
//@property (nonatomic , assign) NSInteger              createUser;
//@property (nonatomic , assign) NSInteger              updateDate;
//@property (nonatomic , assign) NSInteger              updateUser;
//@property (nonatomic , copy) NSString              * jointPictrue;

@end


@interface ProductAttributesListItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              productHisId;
@property (nonatomic , assign) NSInteger              productAttributesId;
@property (nonatomic , copy) NSString              * attributeValue;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , assign) NSInteger              inserttime;
@property (nonatomic , copy) NSString              * insertuser;
@property (nonatomic , copy) NSString              * attributeName;

@end



@interface VipProduct :NSObject<NSCoding>
@property (nonatomic , assign) CGFloat productPrice;//vip最低价
@property (nonatomic , strong)NSArray <PriceInfos> * priceInfos;

@end
@interface PriceInfos :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger countBuy;//购买数量
@property (nonatomic , assign) CGFloat cashPrice;//商品单价
@end


@interface RebateInfo :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger vipLevel;//会员等级1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员
@property (nonatomic , assign) CGFloat rebatePrice;//返利金额
@end
@interface VipRebateInfo :NSObject<NSCoding>
@property (nonatomic , assign) CGFloat rebate;//返利金额
@property (nonatomic , assign) NSInteger vipLevel;//1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员
@property (nonatomic , strong) NSArray <RebateInfo>              * rebateInfos;

@end



@interface Product :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger isWholesaleProduct;//是否批发商品1是0否
@property (nonatomic , strong) VipProduct *vipProduct;//vip批发商品价格信息（批发商品才返回）
@property (nonatomic , strong) VipRebateInfo *vipRebateInfo;//vip返利信息 （批发商品才返回）
@property (nonatomic , assign) NSInteger            productId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * productSubtitle;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * productDescription;
@property (nonatomic , strong) NSArray <ProductPicsItem>              * productPics;
@property (nonatomic , assign) NSInteger              isAllowAgent;
@property (nonatomic , assign) NSInteger              productState;
@property (nonatomic , assign) NSInteger              rebateId;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) CGFloat              intrinsicPrice;
@property (nonatomic , assign) NSInteger              postage;
@property (nonatomic , assign) NSInteger              sellerId;//商家ID
@property (nonatomic , copy) NSString              * sellerName;
@property (nonatomic , copy) NSString              * sellerAvatar;//商家头像
@property (nonatomic , copy) NSString              * telPhone;
@property (nonatomic , assign) NSInteger              shopId;//店铺
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * shopsType;
@property (nonatomic , copy) NSString              * stealAge;
@property (nonatomic , copy) NSString              * classifyName;
@property (nonatomic , assign) NSInteger              isBetterBusiness;
@property (nonatomic , assign) NSInteger              isWelfare;
@property (nonatomic , assign) NSInteger              countShoppingCart;
@property (nonatomic , copy) NSString              * imagePath;
@property (nonatomic , strong) NSArray <ProductAttributesListItem>              * productAttributesList;
@property (nonatomic , assign) NSInteger              initialNumber;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * regionName;
@property (nonatomic , assign) NSInteger              isAttention;//已收藏0，1未收藏
@property (nonatomic , assign) NSInteger              isShowAgent;
@property (nonatomic , assign) NSInteger              hasAgented;
@property (nonatomic , assign) NSInteger              memberLevel;
@property (nonatomic , assign) NSInteger              commodityType;//6 ： 批发  7 礼包
@property (nonatomic , assign) NSInteger              isDistribution;
@property (nonatomic , assign) NSInteger              maxBuyNum;
@property (nonatomic , assign) BOOL              isRedPacket;
@property (nonatomic , copy) NSString          *    startDate;
@property (nonatomic , copy) NSString            *  endDate;
@property (nonatomic , assign) NSInteger   productLevel;//1类2类3类

@end
@interface ProductActiveChk :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              ID;//活动ID
@property (nonatomic , assign) NSInteger              productId;//商品id
@property (nonatomic , assign) NSInteger              ownerId;//商家会员ID
@property (nonatomic , assign) NSInteger              activeType;//1：按拉新成团，2：按购买成团',
@property (nonatomic , assign) NSInteger              activeNum;//参加活动人数
@property (nonatomic , copy) NSString              * activeTitle;//副标题
@property (nonatomic , copy) NSString              * activeSubtitle1;//副标题1
@property (nonatomic , copy) NSString              * activeSubtitle2;//副标题2
@property (nonatomic , copy) NSString              * activeRule;//活动规格
@property (nonatomic , assign) NSInteger              startDate;
@property (nonatomic , assign) NSInteger              endDate;
@property (nonatomic , assign) NSInteger              status;//1拼团待审核2审核未通过3审核通过5拼团中6拼团结束
@property (nonatomic , assign) NSInteger              operId;//审核人Id
@property (nonatomic , assign) NSInteger              operTime;//审核时间
@property (nonatomic , assign) NSInteger              state;//状态
@property (nonatomic , assign) NSInteger              isActive;//是否进入团购时间 0：未进入 1：已进入
@property (nonatomic , assign) CGFloat              activePrice;//团购成本价
@property (nonatomic , assign) CGFloat              activeCashPrice;//活动销售价
@property (nonatomic , assign) NSInteger              activeStartDate;//团购开始日期
@property (nonatomic , assign) NSInteger              activeEndDate;//团购结束日期

@end

@interface TopProductsItem :NSObject<NSCoding>//店铺中商品
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , copy) NSString              * productName;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , assign) NSInteger              salesCount;
@property (nonatomic , assign) NSInteger              stockCount;
@property (nonatomic , assign) NSInteger              productState;
@property (nonatomic , copy) NSString              * jointPictrue;
@property (nonatomic , assign) NSInteger              thirdId;
@property (nonatomic , assign) NSInteger              secondId;
@property (nonatomic , assign) NSInteger              firstId;
@property (nonatomic , assign) NSInteger              agtProductGroupId;
@property (nonatomic , assign) NSInteger              singleProductState;
@property (nonatomic , assign) NSInteger              brandId;
@property (nonatomic , assign) NSInteger              initialNumber;
@property (nonatomic , assign) NSInteger              classId;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , assign) NSInteger              purchaseNum;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              state;
@property (nonatomic , assign) NSInteger              commodityType;
@property (nonatomic , assign) NSInteger              offlineShopId;
@property (nonatomic , assign) NSInteger              provinceId;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              regionId;
@property (nonatomic , assign) NSInteger              profitType;
@property (nonatomic , assign) NSInteger              allsalesCount;
@property (nonatomic , assign) NSInteger              startDate;
@property (nonatomic , assign) NSInteger              endDate;
@property (nonatomic , assign) CGFloat              intrinsicPrice;

@end


@interface ProductComment :NSObject<NSCoding>
@property (nonatomic , assign) float              integratedServiceScore;
@property (nonatomic , assign) float              serviceAttitudeScore;
@property (nonatomic , assign) float              logisticsServiceScore;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              currentUserId;

@end



@interface ProductDetail :NSObject<NSCoding>

@property (nonatomic , copy) NSString              * productConsult;
@property (nonatomic , strong) Product              * product;
@property (nonatomic , assign) NSInteger              productConsultSign;
@property (nonatomic , copy) NSString              * lcon_text_indent;
@property (nonatomic , strong) ProductActiveChk              * productActiveChk;
@property (nonatomic , strong) NSArray <TopProductsItem>              * topProducts;
@property (nonatomic , copy) NSString              * lcon_imagePath;
@property (nonatomic , assign) NSInteger              purchaseLimitation;//限购字段
@property (nonatomic , copy) NSString              * lcon_line_height;
@property (nonatomic , copy) NSString              * productShart;
@property (nonatomic , assign) NSInteger              isSeckill;
@property (nonatomic , copy) NSString  *promotionTag;//促销字段
@property (nonatomic , strong) ProductComment              * productComment;
@property (nonatomic , strong) SeckillInfo             *seckillInfo;

//@property (nonatomic , assign) NSInteger              productConsult;
//@property (nonatomic , assign) NSInteger           purchaseLimitation;//限购（0：不限，大于0 是实际限购数）
//@property (nonatomic , copy) NSString *productActiveChk;//团购对象
//@property (nonatomic , strong) Product              * product;
//@property (nonatomic , copy) NSString              * lcon_text_indent;
//@property (nonatomic , copy) NSArray<TopProductsItem> * topProducts;
//@property (nonatomic , copy) NSString              * lcon_imagePath;//首页图标
////@property (nonatomic , copy) NSString     lcon_line_height;
////@property (nonatomic , copy) NSString              * lcon_line_height;
//@property (nonatomic , copy) NSString              * productShart;
//@property (nonatomic , assign) NSInteger              isSeckill;//0非秒杀商品
//
//@property (nonatomic , strong) ProductComment              * productComment;
@end

//商品详情
@interface GoodsDetailModel :SetBaseModel
@property (nonatomic , strong) ProductDetail              * data;
@end




NS_ASSUME_NONNULL_END
