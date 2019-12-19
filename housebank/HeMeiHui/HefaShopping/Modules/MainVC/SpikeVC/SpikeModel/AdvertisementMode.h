//
//  AdvertisementMode.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/4.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol AdvertisementListItem//不带*号

@end
NS_ASSUME_NONNULL_BEGIN
@interface AdvertisementListItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              ID;//广告详情id
@property (nonatomic , copy) NSString              * advertisingTitle;//广告标题
@property (nonatomic , assign) NSInteger              startTime;//广告开始时间
@property (nonatomic , assign) NSInteger              endTime;//广告结束时间
@property (nonatomic , assign) NSInteger              type;//1．APP上显示2.h5上显示
@property (nonatomic , assign) NSInteger              status;//1上线2待上线3下线
@property (nonatomic , assign) NSInteger              appSort;//app广告排序

@property (nonatomic , assign) NSInteger              h5Sort;//h5广告排序
@property (nonatomic , assign) NSInteger              clickNumber;//鼠标点击次数
@property (nonatomic , assign) NSInteger              orderCount;//订单转换率（不需要）
@property (nonatomic , copy) NSString              * imageth;//图片路径
@property (nonatomic , assign) NSInteger              linkType;//1．商品类型2.url类型

@property (nonatomic , copy) NSString              * linkContent;//链接内容
@property (nonatomic , assign) NSInteger              createDate;//创造时间
@property (nonatomic , assign) NSInteger              createUser;//创造人

@end


@interface AdvertisementData :NSObject<NSCoding>
@property (nonatomic , strong) NSArray <AdvertisementListItem >              * list;

@end


@interface AdvertisementMode :SetBaseModel

@property (nonatomic , strong) AdvertisementData              * data;

@end


NS_ASSUME_NONNULL_END
