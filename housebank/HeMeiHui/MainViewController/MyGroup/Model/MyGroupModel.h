//
//  MyGroupModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface MyGroupItemModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * parentId;   /** 团主ID*/
@property (nonatomic, copy) NSString * productActiveId; /** 商品活动ID */
@property (nonatomic, copy) NSString * orderNo;         /** 订单号*/
@property (nonatomic, copy) NSString * createDate;      /** 创建日期*/
@property (nonatomic, strong) NSNumber * isUser;         /** 是否新人*/
@property (nonatomic, strong) NSNumber * payState;        /** 支付状态*/
@property (nonatomic, strong) NSNumber * groupNum;        /** 本团参团人数*/
@property (nonatomic, strong) NSNumber * activeNum;       /** 团活动人数*/
@property (nonatomic, copy) NSString * name;              /** 姓名*/
@property (nonatomic, copy) NSString * nickname;          /** 外号*/
@property (nonatomic, copy) NSString * imagePath;         /** 图片路径*/
@property (nonatomic, copy) NSString * activeTitle;       /** 活动标题*/
@property (nonatomic, copy) NSString * activeSubtitle1;   /** 副标题*/
@property (nonatomic, copy) NSString * activeSubtitle2;   /** 副标题2*/
@property (nonatomic, strong) NSNumber * peaceTimeCashPric; /** 平时销售价*/
@property (nonatomic, strong) NSNumber * cashPrice;       /** 团购销售价*/
@property (nonatomic, strong) NSString * initialNumber;   /** 月销量*/
@property (nonatomic, copy) NSString * imageUrl;          /** 图片*/
@property (nonatomic, copy) NSString * jointPictrue;      /** 图片裁剪*/
@property (nonatomic, strong) NSNumber * groupEndDate;    /** 结束时间*/
@property (nonatomic, strong) NSNumber * activeType;      /** 是否是新人团*/
@property (nonatomic, copy) NSString * orderPrice;        /** 订单价格*/
@property (nonatomic, copy) NSString * status;            /** 状态*/

@end

@interface MyGroupModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, strong) NSArray <MyGroupItemModel *> * dataSource;
@end

NS_ASSUME_NONNULL_END
