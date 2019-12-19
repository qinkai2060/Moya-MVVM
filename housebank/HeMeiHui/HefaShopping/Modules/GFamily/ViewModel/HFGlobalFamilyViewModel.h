//
//  HFGlobalFamilyViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFGlobalFamilyViewModel : HFViewModel
@property(nonatomic,strong)RACCommand *getHotelDataCommand;
@property(nonatomic,strong)RACSubject *hotelDataSubjc;
@property(nonatomic,strong)NSDictionary *prames;

@property(nonatomic,strong)RACCommand *getRegionDatCommand;
@property(nonatomic,strong)RACSubject *regionDataSubjc;
/**
 获取城市
 */
@property(nonatomic,strong)RACSubject *getCitySubjc;
/**
 获取日期
 */
@property(nonatomic,strong)RACSubject *getDateSubjc;
/**
 进入搜索页
 */
@property(nonatomic,strong)RACSubject *getSearchSubjc;
/**
 点击屏幕
 */
@property(nonatomic,strong)RACSubject *didScreenSubjc;

/**
 进入详情页
 */
@property(nonatomic,strong)RACSubject *didDetailSubjc;

@property(nonatomic,strong)RACSubject *getKeyWordSubjc;
@property(nonatomic,strong)RACSubject *setKeyWordSubjc;

@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,copy)NSString *keyword;
/**
 开始日期
 */
@property(nonatomic,assign)NSInteger beginTime;
/**
 结束日期
 */
@property(nonatomic,assign)NSInteger endTime;
/**
 开始日期
 */
@property(nonatomic,copy)NSString *bookStar;
/**
 结束日期
 */
@property(nonatomic,copy)NSString *bookEnd;
/**
 经度
 */
@property(nonatomic,copy)NSString *localPointLng;
/**
 纬度
 */
@property(nonatomic,copy)NSString *localPointLat;
/**
 最小值
 */
@property(nonatomic,copy)NSString *minPrice;
/**
 最大值
 */
@property(nonatomic,copy)NSString *maxPrice;
/**
 星级
 */
@property(nonatomic,copy)NSString *star;
/**
 距离
 */
@property(nonatomic,copy)NSString *distance;
/**
 parentID
 */
@property(nonatomic,copy)NSString *cityId;
/**
 区县
 */
@property(nonatomic,copy)NSString *regionId;
/**
 床型
 */
@property(nonatomic,copy)NSString *bedType;
/**
 早餐
 */
@property(nonatomic,copy)NSString *breakfastType;
/**
 排序
 */
@property(nonatomic,assign)NSString *orderByType;

@end

NS_ASSUME_NONNULL_END
