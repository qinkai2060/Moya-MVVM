//
//  NSData+BCHHelperKit.m
//  BCHHelperKit
//
//  Created by bch on 16/7/25.
//  Copyright © 2016年 bch. All rights reserved.
//

#import "NSDate+Profile.h"

@implementation NSDate (Profile)

- (NSUInteger)bch_day {
    return [NSDate bch_day:self];
}

- (NSUInteger)bch_month {
    return [NSDate bch_month:self];
}

- (NSUInteger)bch_year {
    return [NSDate bch_year:self];
}

- (NSUInteger)bch_hour {
    return [NSDate bch_hour:self];
}

- (NSUInteger)bch_minute {
    return [NSDate bch_minute:self];
}

- (NSUInteger)bch_second {
    return [NSDate bch_second:self];
}

+ (NSUInteger)bch_day:(NSDate *)bch_date {
    return [[self bch_dateComponentsWithDate:bch_date] day];
}

+ (NSUInteger)bch_month:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth)fromDate:bch_date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit)fromDate:bch_date];
#endif
    
    return [dayComponents month];
}

+ (NSUInteger)bch_year:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear)fromDate:bch_date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit)fromDate:bch_date];
#endif
    
    return [dayComponents year];
}

+ (NSUInteger)bch_hour:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour)fromDate:bch_date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit)fromDate:bch_date];
#endif
    
    return [dayComponents hour];
}

+ (NSUInteger)bch_minute:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute)fromDate:bch_date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit)fromDate:bch_date];
#endif
    
    return [dayComponents minute];
}

+ (NSUInteger)bch_second:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond)fromDate:bch_date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit)fromDate:bch_date];
#endif
    
    return [dayComponents second];
}

- (NSUInteger)bch_daysInYear {
    return [NSDate bch_daysInYear:self];
}

+ (NSUInteger)bch_daysInYear:(NSDate *)bch_date {
    return [self bch_isLeapYear:bch_date] ? 366 : 365;
}

- (BOOL)bch_isLeapYear {
    return [NSDate bch_isLeapYear:self];
}

+ (BOOL)bch_isLeapYear:(NSDate *)bch_date {
    int year = (int)[bch_date bch_year];
    return [self bch_isLeapYearWithYear:year];
}

+ (BOOL)bch_isLeapYearWithYear:(int)year {
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)bch_toStringWithFormatYMD {
    return [NSDate bch_toStringWithFormatYMD:self];
}

- (NSString *)bch_toStringWithFormatYMDHM {
    return [NSDate bch_toStringWithFormatYMDHM:self];
}

+ (NSString *)bch_toStringWithFormatYMDHM:(NSDate *)bch_date {
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",
            (long)[bch_date bch_year],
            (long)[bch_date bch_month],
            (long)[bch_date bch_day],
            (long)[bch_date bch_hour],
            (long)[bch_date bch_minute]
            ];
}

+ (NSString *)bch_toStringWithFormatYMD:(NSDate *)bch_date {
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld",
            (long)[bch_date bch_year],
            (long)[bch_date bch_month],
            (long)[bch_date bch_day]];
}

- (NSUInteger)bch_howManyWeeksOfMonth {
    return [NSDate bch_howManyWeeksOfMonth:self];
}

+ (NSUInteger)bch_howManyWeeksOfMonth:(NSDate *)bch_date {
    return [[bch_date bch_lastDayOfMonth] bch_weekOfYear] - [[bch_date bch_beginDayOfMonth] bch_weekOfYear] + 1;
}

- (NSUInteger)bch_weekOfYear {
    return [NSDate bch_weekOfYear:self];
}

+ (NSUInteger)bch_weekOfYear:(NSDate *)bch_date {
    NSUInteger i;
    NSUInteger year = [bch_date bch_year];
    
    NSDate *lastdate = [bch_date bch_lastDayOfMonth];
    
    for (i = 1;[[lastdate bch_dateAfterDay:-7 * i] bch_year] == year; i++) {
        
    }
    
    return i;
}

- (NSDate *)bch_dateAfterDay:(NSUInteger)bch_day {
    return [NSDate bch_dateAfterDate:self day:bch_day];
}

+ (NSDate *)bch_dateAfterDate:(NSDate *)bch_date day:(NSInteger)bch_day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:bch_day];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:bch_date options:0];
    
    return dateAfterDay;
}

- (NSDate *)bch_dateAfterMonth:(NSUInteger)bch_month {
    return [NSDate bch_dateAfterDate:self month:bch_month];
}

+ (NSDate *)bch_dateAfterDate:(NSDate *)bch_date month:(NSInteger)bch_month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:bch_month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:bch_date options:0];
    
    return dateAfterMonth;
}

- (NSDate *)bch_beginDayOfMonth {
    return [NSDate bch_beginDayOfMonth:self];
}

+ (NSDate *)bch_beginDayOfMonth:(NSDate *)bch_date {
    return [self bch_dateAfterDate:bch_date day:-[bch_date bch_day] + 1];
}

- (NSDate *)bch_lastDayOfMonth {
    return [NSDate bch_lastDayOfMonth:self];
}

+ (NSDate *)bch_lastDayOfMonth:(NSDate *)bch_date {
    NSDate *lastDate = [self bch_beginDayOfMonth:bch_date];
    return [[lastDate bch_dateAfterMonth:1] bch_dateAfterDay:-1];
}

- (NSUInteger)bch_daysAgo {
    return [NSDate bch_daysAgo:self];
}

+ (NSUInteger)bch_daysAgo:(NSDate *)bch_date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:bch_date
                                                 toDate:[NSDate date]
                                                options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:bch_date
                                                 toDate:[NSDate date]
                                                options:0];
#endif
    
    return [components day];
}

- (NSInteger)bch_weekday {
    return [NSDate bch_weekday:self];
}

+ (NSInteger)bch_weekday:(NSDate *)bch_date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:bch_date];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}

- (NSString *)bch_dayFromWeekday {
    return [NSDate bch_dayFromWeekday:self];
}

+ (NSString *)bch_dayFromWeekday:(NSDate *)bch_date {
    switch([bch_date bch_weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)bch_isSameDate:(NSDate *)bch_anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:bch_anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

- (BOOL)bch_isToday {
    return [self bch_isSameDate:[NSDate date]];
}

- (NSDate *)bch_dateByAddingDays:(NSUInteger)bch_days {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = bch_days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
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
+ (NSString *)bch_monthWithMonthNumber:(NSInteger)bch_month {
    switch(bch_month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)bch_stringWithDate:(NSDate *)bch_date format:(NSString *)bch_format {
    return [bch_date bch_stringWithFormat:bch_format];
}

- (NSString *)bch_stringWithFormat:(NSString *)bch_format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:bch_format];
    [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *retStr = [outputFormatter stringFromDate:self];
    
    return retStr;
}

+ (NSDate *)bch_dateWithString:(NSString *)bch_string format:(NSString *)bch_format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:bch_format];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [inputFormatter dateFromString:bch_string];
    
    return date;
}

- (NSUInteger)bch_daysInMonth:(NSUInteger)bch_month {
    return [NSDate bch_daysInMonth:self month:bch_month];
}

+ (NSUInteger)bch_dayInYear:(NSUInteger)year month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [self bch_isLeapYearWithYear:(int)year] ? 29 : 28;
    }
    
    return 30;
}

+ (NSUInteger)bch_daysInMonth:(NSDate *)bch_date month:(NSUInteger)bch_month {
    switch (bch_month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [bch_date bch_isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)bch_daysInMonth {
    return [NSDate bch_daysInMonth:self];
}

+ (NSUInteger)bch_daysInMonth:(NSDate *)bch_date {
    return [self bch_daysInMonth:bch_date month:[bch_date bch_month]];
}

+(NSString *)bch_dateStringWithTimeInterval:(NSString *)timeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self bch_ymdFormat]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000]];
}

+(NSString *)bch_dateHMStringWithTimeInterval:(NSString *)timeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self bch_hmFormat]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000]];
}

+(NSString *)bch_dateYMDHDSStringWithTimeInterval:(NSString *)timeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self bch_ymdHmsFormat]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000]];
}

+(NSString *)bch_dateYMD_HMStringWithTimeInterval:(NSString *)timeInterval{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self bch_ymd_HmFormat]];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000]];
}

- (NSString *)bch_timeInfo {
    return [NSDate bch_timeInfoWithDate:self];
}

+ (NSString *)bch_timeInfoWithDate:(NSDate *)bch_date {
    return [self bch_timeInfoWithDateString:[self bch_stringWithDate:bch_date format:[self bch_ymdHmsFormat]]];
}

+(NSString *)bch_timeInfoWithTimeInterval:(NSString *)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000];
    return [self bch_private_timeInfoWithDate:date];
}

+ (NSString *)bch_timeInfoWithDateString:(NSString *)bch_dateString {
    NSDate *date = [self bch_dateWithString:bch_dateString format:[self bch_ymdHmsFormat]];
    return [self bch_private_timeInfoWithDate:date];
}

+ (NSString *)bch_private_timeInfoWithDate:(NSDate *)date{
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    int month = (int)([curDate bch_month] - [date bch_month]);
    int year = (int)([curDate bch_year] - [date bch_year]);
    int day = (int)([curDate bch_day] - [date bch_day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate bch_month] == 1 && [date bch_month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self bch_daysInMonth:date month:[date bch_month]];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate bch_day] + (totalDays - (int)[date bch_day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate bch_month];
            int preMonth = (int)[date bch_month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    
    return @"1小时前";

}

- (NSString *)bch_ymdFormat {
    return [NSDate bch_ymdFormat];
}

- (NSString *)bch_hmsFormat {
    return [NSDate bch_hmsFormat];
}

- (NSString *)bch_ymdHmsFormat {
    return [NSDate bch_ymdHmsFormat];
}

+ (NSString *)bch_ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)bch_hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)bch_hmFormat{
    return @"HH:mm";
}

+ (NSString *)bch_ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self bch_ymdFormat], [self bch_hmsFormat]];
}

+ (NSString *)bch_ymd_HmFormat {
    return [NSString stringWithFormat:@"%@ / %@", [self bch_ymdFormat], [self bch_hmFormat]];
}

- (NSDate *)bch_offsetYears:(int)bch_numYears {
    return [NSDate bch_offsetYears:bch_numYears fromDate:self];
}

+ (NSDate *)bch_offsetYears:(int)bch_numYears fromDate:(NSDate *)bch_fromDate {
    if (bch_fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:bch_numYears];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:bch_fromDate
                                     options:0];
}

- (NSDate *)bch_offsetMonths:(int)bch_numMonths {
    return [NSDate bch_offsetMonths:bch_numMonths fromDate:self];
}

+ (NSDate *)bch_offsetMonths:(int)bch_numMonths fromDate:(NSDate *)bch_fromDate {
    if (bch_fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:bch_numMonths];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:bch_fromDate
                                     options:0];
}

- (NSDate *)bch_offsetDays:(int)bch_numDays {
    return [NSDate bch_offsetDays:bch_numDays fromDate:self];
}

+ (NSDate *)bch_offsetDays:(int)bch_numDays fromDate:(NSDate *)bch_fromDate {
    if (bch_fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:bch_numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:bch_fromDate
                                     options:0];
}

- (NSDate *)bch_offsetHours:(int)bch_hours {
    return [NSDate bch_offsetHours:bch_hours fromDate:self];
}

+ (NSDate *)bch_offsetHours:(int)bch_numHours fromDate:(NSDate *)bch_fromDate {
    if (bch_fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:bch_numHours];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:bch_fromDate
                                     options:0];
}

+ (NSDateComponents *)bch_dateComponentsWithDate:(NSDate *)date {
    NSCalendar *calendar = nil;
    NSUInteger flags = 0;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour
    | NSCalendarUnitMinute | NSCalendarUnitSecond;
#else
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
    | NSMinuteCalendarUnit | NSSecondCalendarUnit;
#endif
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [calendar components:flags fromDate:date];
}

- (NSString *)bch_toTimeStamp {
    return [NSString stringWithFormat:@"%lf", [self timeIntervalSince1970]];
}

+ (NSDate *)bch_toDateWithTimeStamp:(NSString *)timeStamp {
    NSString *arg = timeStamp;
    
    if (![timeStamp isKindOfClass:[NSString class]]) {
        arg = [NSString stringWithFormat:@"%@", timeStamp];
    }
    
    if (arg.length > 10) {
        arg = [arg substringToIndex:10];
    }
    
    NSTimeInterval time = [arg doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

+ (NSString *)bch_convertTime:(CGFloat)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (second/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH时mm分ss秒"];
    } else {
        [dateFormatter setDateFormat:@"mm分ss秒"];
    }
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];;
}


+ (NSString *)bch_convertWithTime:(CGFloat)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (second/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:second]];;
}


+(int)bch_compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

@end
