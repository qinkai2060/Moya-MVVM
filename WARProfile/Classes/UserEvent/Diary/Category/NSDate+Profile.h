//
//  NSData+BCHHelperKit.m
//  BCHHelperKit
//
//  Created by bch on 16/7/25.
//  Copyright © 2016年 bch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Profile)

//--------------------------------------------//
// Get day, month, year, hour, minute, second
//--------------------------------------------//
- (NSUInteger)bch_day;
- (NSUInteger)bch_month;
- (NSUInteger)bch_year;
- (NSUInteger)bch_hour;
- (NSUInteger)bch_minute;
- (NSUInteger)bch_second;
+ (NSUInteger)bch_day:(NSDate *)bch_date;
+ (NSUInteger)bch_month:(NSDate *)bch_date;
+ (NSUInteger)bch_year:(NSDate *)bch_date;
+ (NSUInteger)bch_hour:(NSDate *)bch_date;
+ (NSUInteger)bch_minute:(NSDate *)bch_date;
+ (NSUInteger)bch_second:(NSDate *)bch_date;

/**
 *	   n'n
 *
 *	Get how many days in the year.
 *
 *	@return The days of the year.
 */
- (NSUInteger)bch_daysInYear;

/**
 *	   
 *
 *	Get how many days in the specified year.
 *
 *	@param bch_date	The specified date
 *
 *	@return The days of the year.
 */
+ (NSUInteger)bch_daysInYear:(NSDate *)bch_date;

/**
 *	   
 *
 *	Judge whether this year is leap year or not.
 *
 *	@return YES means leap year, otherwise NO.
 */
- (BOOL)bch_isLeapYear;

/**
 *	   
 *
 *	Judge whether the specified date of year is leap year or not.
 *
 *	@param bch_date	The specified date.
 *
 *	@return YES means leap year, otherwise NO.
 */
+ (BOOL)bch_isLeapYear:(NSDate *)bch_date;

/**
 *	   
 *
 *	Judge whether this year is leap year or not.
 *
 *	@param year	The specified year
 *
 *	@return YES means leap year, otherwise NO.
 */
+ (BOOL)bch_isLeapYearWithYear:(int)year;

/**
 *	   
 *
 *	Get which week in the year.
 *
 *	@return Current week of year.
 */
- (NSUInteger)bch_weekOfYear;

/**
 *	   
 *
 *	Get which week in the specified date.
 *
 *	@param bch_date	The specified date to get which week.
 *
 *	@return Current week of the specified year.
 */
+ (NSUInteger)bch_weekOfYear:(NSDate *)bch_date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
/**
 *	   
 *
 *	Convert the date to a time string with yyyy-MM-dd format.
 *
 *	@return The time string with yyyy-MM-dd
 */
- (NSString *)bch_toStringWithFormatYMD;

- (NSString *)bch_toStringWithFormatYMDHM;
/**
 *	   
 *
 *  Convert the date to a time string with yyyy-MM-dd format.
 *
 *	@param bch_date	The specified date to be converted to time string.
 *
 *	@return The time string with yyyy-MM-dd
 */
+ (NSString *)bch_toStringWithFormatYMD:(NSDate *)bch_date;

/**
 *	   
 *
 *	Get how many weeks in the month. It might have 4, 5, or 6 weeks.
 *
 *	@return The weeks in the month.
 */
- (NSUInteger)bch_howManyWeeksOfMonth;
+ (NSUInteger)bch_howManyWeeksOfMonth:(NSDate *)bch_date;
- (NSDate *)bch_beginDayOfMonth;
+ (NSDate *)bch_beginDayOfMonth:(NSDate *)bch_date;

- (NSDate *)bch_lastDayOfMonth;


+ (NSDate *)bch_lastDayOfMonth:(NSDate *)bch_date;


- (NSDate *)bch_dateAfterDay:(NSUInteger)days;


+ (NSDate *)bch_dateAfterDate:(NSDate *)bch_date day:(NSInteger)days;


- (NSDate *)bch_dateAfterMonth:(NSUInteger)months;



+ (NSDate *)bch_dateAfterDate:(NSDate *)bch_date month:(NSInteger)months;

/**
 * 返回numYears年后的日期
 */
/**
 *	   
 *
 *	Get new date offset numYears.
 *
 *	@param numYears	The
 *
 */
- (NSDate *)bch_offsetYears:(int)numYears;
+ (NSDate *)bch_offsetYears:(int)bch_numYears fromDate:(NSDate *)bch_fromDate;
- (NSDate *)bch_offsetMonths:(int)bch_numMonths;
+ (NSDate *)bch_offsetMonths:(int)bch_numMonths fromDate:(NSDate *)bch_fromDate;
- (NSDate *)bch_offsetDays:(int)bch_numDays;
+ (NSDate *)bch_offsetDays:(int)bch_numDays fromDate:(NSDate *)bch_fromDate;
- (NSDate *)bch_offsetHours:(int)bch_hours;
+ (NSDate *)bch_offsetHours:(int)bch_numHours fromDate:(NSDate *)bch_fromDate;
- (NSUInteger)bch_daysAgo;
+ (NSUInteger)bch_daysAgo:(NSDate *)bch_date;

/**
 *  获取星期几
 *
 *  @return Return weekday number
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)bch_weekday;
+ (NSInteger)bch_weekday:(NSDate *)bch_date;

/**
 *  获取星期几(名称)bch_
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)bch_dayFromWeekday;
+ (NSString *)bch_dayFromWeekday:(NSDate *)bch_date;

- (BOOL)bch_isSameDate:(NSDate *)bch_anotherDate;

- (BOOL)bch_isToday;


- (NSDate *)bch_dateByAddingDays:(NSUInteger)bch_days;

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param bch_month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)bch_monthWithMonthNumber:(NSInteger)bch_month;

/**
 *  Convert date to string with format.
 */
+ (NSString *)bch_stringWithDate:(NSDate *)bch_date format:(NSString *)bch_format;
- (NSString *)bch_stringWithFormat:(NSString *)bch_format;

/**
 * Convert date string to NSDate instance.
 */
+ (NSDate *)bch_dateWithString:(NSString *)bch_string format:(NSString *)bch_format;

/**
 * Get how many days in the month.
 */
- (NSUInteger)bch_daysInMonth:(NSUInteger)bch_month;
+ (NSUInteger)bch_daysInMonth:(NSDate *)bch_date month:(NSUInteger)bch_month;
+ (NSUInteger)bch_dayInYear:(NSUInteger)year month:(NSUInteger)month;

/**
 * Get how many days in the month.
 */
- (NSUInteger)bch_daysInMonth;
+ (NSUInteger)bch_daysInMonth:(NSDate *)bch_date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)bch_timeInfo;
+ (NSString *)bch_timeInfoWithDate:(NSDate *)bch_date;
+ (NSString *)bch_timeInfoWithTimeInterval:(NSString *)timeInterval;
+ (NSString *)bch_timeInfoWithDateString:(NSString *)bch_dateString;

/**
 * 根据timeInterval获取对应的日期字符串
 */
+ (NSString *)bch_dateStringWithTimeInterval:(NSString *)timeInterval;

/**
 * 根据timeInterval获取对应的日期字符串,时分的建议格式:13:50
 */
+(NSString *)bch_dateHMStringWithTimeInterval:(NSString *)timeInterval;

/**
 * 根据timeInterval获取对应的日期字符串,时分的建议格式: 2007-09-01 13:50
 */
+(NSString *)bch_dateYMDHDSStringWithTimeInterval:(NSString *)timeInterval;

/**
 * 根据timeInterval获取对应的日期字符串,时分的建议格式: 2007-09-01 / 13:50
 */
+(NSString *)bch_dateYMD_HMStringWithTimeInterval:(NSString *)timeInterval;

/**
 * yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss
 */
- (NSString *)bch_ymdFormat;
- (NSString *)bch_hmsFormat;
- (NSString *)bch_ymdHmsFormat;
+ (NSString *)bch_ymdFormat;
+ (NSString *)bch_hmsFormat;
+ (NSString *)bch_hmFormat;
+ (NSString *)bch_ymdHmsFormat;

+ (NSDateComponents *)bch_dateComponentsWithDate:(NSDate *)date;

/**
 * Convert date to time stamp.
 */
- (NSString *)bch_toTimeStamp;

/**
 * Convert time stamp to date.
 */
+ (NSDate *)bch_toDateWithTimeStamp:(NSString *)timeStamp;

/**
 *  秒转时长
 *
 *  @param second 秒数
 *
 *  @return 时长字符串
 */
+ (NSString *)bch_convertTime:(CGFloat)second;
+ (NSString *)bch_convertWithTime:(CGFloat)second;
/**
 *  日期时间的比较
 *
 *  @param oneDay     <#oneDay description#>
 *  @param anotherDay <#anotherDay description#>
 *
 *  @return <#return value description#>
 */
+(int)bch_compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

+ (NSString *)bch_private_timeInfoWithDate:(NSDate *)date;

@end
