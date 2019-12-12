//
//  WARWeatherModel.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/23.
//

#import <Foundation/Foundation.h>

@interface WARUserDiaryWeatherModel : NSObject

/**
 日期
 */
@property (nonatomic, assign)NSInteger time;
@property (nonatomic, readonly,copy)NSString *dateStr;

/**
 天气类型
 */
@property (nonatomic, assign)NSInteger weatherType;
@property (nonatomic, readonly,strong) UIImage *weatherImg;


/**
 温度
 */
@property (nonatomic, assign)NSInteger lowestTemp;
@property (nonatomic, assign)NSInteger highestTemp;
@property (nonatomic, readonly,copy)NSString *temperatureStr;


/**
 广告语
 */
@property (nonatomic, copy)NSString *adStr;
@end


@interface WARWeatherManager : NSObject
- (NSArray *)setUpWeatherData;

@end
