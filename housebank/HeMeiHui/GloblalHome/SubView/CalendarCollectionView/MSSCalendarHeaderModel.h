//
//  MSSCalendarHeaderModel.h
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSCalendarHeaderModel : NSObject
@property (nonatomic,copy)NSString *headerText;
@property (nonatomic,strong)NSArray *calendarItemArray;
@end

typedef NS_ENUM(NSInteger, MSSCalendarType)
{
    MSSCalendarTodayType = 0,//今天
    MSSCalendarLastType,//今天之前
    MSSCalendarNextType//今天之后
};

@interface MSSCalendarModel : NSObject

@property (nonatomic,assign)NSInteger year;
@property (nonatomic,assign)NSInteger month;
@property (nonatomic,assign)NSInteger day;
@property (nonatomic,strong)NSString *chineseCalendar;// 农历
@property (nonatomic,strong)NSString *holiday;// 节日
@property (nonatomic,assign)MSSCalendarType type;
@property (nonatomic,assign)NSInteger dateInterval;// 日期的时间戳
@property (nonatomic,assign)NSInteger week;// 星期

@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *userPrice;   //会员价
@property (nonatomic,assign)BOOL userInteractionEnabled;

@property (nonatomic,assign)BOOL middleSelect;

@end
