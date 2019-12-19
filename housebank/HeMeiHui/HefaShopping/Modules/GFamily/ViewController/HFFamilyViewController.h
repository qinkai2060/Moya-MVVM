//
//  HFFamilyViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFFamilyViewController : UIViewController

/**
 

 @param cityName 城市名字
 @param cityId 城市id
 @param pointLng 经度
 @param pointLat 纬度
 @param dateStar 开始日期
 @param dateEnd 结束日期
 @param keyWord 关键字
 @param minPrice 最小价格
 @param maxPrice 最大价格
 @param star 星级
 */
- (void)getCityName:(NSString*)cityName cityID:(NSString*)cityId pointLng:(NSString*)pointLng pointLat:(NSString*)pointLat dateStar:(NSString*)dateStar dateEnd:(NSString*)dateEnd keyWord:(NSString*)keyWord minPrice:(NSString*)minPrice maxPrice:(NSString*)maxPrice star:(NSString*)star beginTime:(NSInteger)begin endTime:(NSInteger)endtime;
@end

NS_ASSUME_NONNULL_END
