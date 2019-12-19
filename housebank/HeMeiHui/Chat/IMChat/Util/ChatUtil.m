//
//  ChatUtil.m
//  OOMall
//
//  Created by QianDeng on 15/11/25.
//  Copyright © 2015年 frank. All rights reserved.
//

#import "ChatUtil.h"
#import <CoreText/CoreText.h>
#import "NSDate+Category.h"

static NSMutableDictionary *emotionsDic = nil;

@implementation ChatUtil

#pragma mark - 获取文字高、宽

+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil].size.width;
    return width;
}

+ (CGFloat)getHeightWithFontSize:(CGFloat)font  width:(CGFloat)width text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}

//获取富文本文字高度
+ (CGFloat)getHeightWithRichStr:(NSString *)str width:(CGFloat)width lineSpace:(CGFloat)lineSpace font:(CGFloat)font{
    if (!str || str.length == 0) {
        return 0;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace+4;
    str = str ? str : @"";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGSize attSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL,CGSizeMake(width, CGFLOAT_MAX), NULL);
    CFRelease(frameSetter);
    return attSize.height+1;
}

+ (NSMutableAttributedString *)getAttributedWithString:(NSString *)string Color:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
     string = string ? string : @"";
    NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:string];
    [strAttributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    [strAttributed addAttribute:NSFontAttributeName value:font range:range];
    return strAttributed;
}

#pragma mark - Emoji表情处理

+ (NSString *)parseEmotion:(NSString *)text
{
    if (emotionsDic==nil) {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        emotionsDic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:dataPath]];
    }
    for(NSString *string in [emotionsDic allKeys]){
        NSString *ValueStr = [emotionsDic objectForKey:string];
        text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", ValueStr] withString:[NSString stringWithFormat:@"<img style='vertical-align:text-bottom;' width='20' height='20' src='%@.png' />",string]];
    }
    return text;
}

+ (NSString *)parseEmotion:(NSString *)text emotionHeight:(CGFloat)h
{
    if (emotionsDic==nil) {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        emotionsDic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:dataPath]];
    }
    for(NSString *string in [emotionsDic allKeys]){
        NSString *ValueStr = [emotionsDic objectForKey:string];
        text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", ValueStr] withString:[NSString stringWithFormat:@"<img style='vertical-align:text-bottom;' width='%.f' height='%.f' src='%@.png' />",h,h,string]];
    }
    return text;
}

+ (BOOL)stringIsFace:(NSString *)string
{
    for (NSString *keyStr in [emotionsDic allKeys]) {
        if ([[emotionsDic objectForKey:keyStr] isEqualToString:string]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSDictionary *)emotionsDict {
    if (emotionsDic == nil) {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
        emotionsDic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:dataPath]];
    }
    return [[NSDictionary alloc] initWithDictionary:emotionsDic];
}

#pragma mark - 时间相关

//将服务器返回字符串转为时间戳
+ (double)getTimeStampFormTimeString:(NSString *)timeStr
{
    NSArray *arr1 = [timeStr componentsSeparatedByString:@"("];
    if (arr1.count>1) {
        NSString *str1 = [arr1 objectAtIndex:1];
        NSArray *arr2 = [str1 componentsSeparatedByString:@"+"];
        if (arr2.count>0) {
            NSString *tStr = [arr2 objectAtIndex:0];
            return [tStr doubleValue]/1000;
        }
        else
        {
            NSArray *arr3 = [str1 componentsSeparatedByString:@"-"];
            if (arr3.count>0) {
                NSString *tStr = [arr3 objectAtIndex:0];
                return [tStr doubleValue]/1000;
            }
        }
    }
    return 0.0;
}

+ (NSString*)getformatDateString:(double)time
{
    
    NSString *ret = @"";
    
    NSDate * messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:time];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |NSWeekdayCalendarUnit;
    
    NSDateComponents *messageComponents = [cal components:unitFlags fromDate:messageDate];
    
    NSInteger messageWeek = [messageComponents weekday];
    NSDateComponents *nowDateComponents = [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger nowWeek = [nowDateComponents weekday];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeInterval second = [[NSDate date] timeIntervalSinceDate:messageDate];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    NSString * nowDayString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString * messageDayString = [dateFormatter stringFromDate:messageDate];
    
    NSString * yesterdayString = [dateFormatter stringFromDate:yesterday];
    
    
    //相差的小时数
    int hours = second / 3600;
    
    if ([messageComponents year] == [nowDateComponents year]) {
        
        if ([nowDayString isEqualToString:messageDayString]) {
            
            [dateFormatter setDateFormat:@"HH:mm"];
            ret = [dateFormatter stringFromDate:messageDate];
        }
        else if( [yesterdayString isEqualToString:messageDayString]){
            
            ret = @"昨天";
            
        }
        else  if(hours <= 24 * 7) {
            
            if (messageWeek == 1) { //周日
                
                ret = @"上周日";
            }
            
            if (nowWeek > messageWeek) {
                
                ret = [ChatUtil getWeek:messageWeek];
            }
            else {
                
                ret = [NSString stringWithFormat:@"上%@",[ChatUtil getWeek:messageWeek]];
            }
            
        }
        else {
            
            [dateFormatter setDateFormat:@"MM-dd"];
            
            ret = [dateFormatter stringFromDate:messageDate];
        }
    }
    else {
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        ret = [dateFormatter stringFromDate:messageDate];
        
    }
    
    return ret;
}


+ (NSString*)getWeek:(NSInteger)week
{
    
    NSString *ret = @"";
    
    switch (week) {
        case 1:
            ret = @"周日";
            break;
        case 2:
            ret = @"周一";
            break;
        case 3:
            ret = @"周二";
            break;
        case 4:
            ret = @"周三";
            break;
        case 5:
            ret = @"周四";
            break;
        case 6:
            ret = @"周五";
            break;
        case 7:
            ret = @"周六";
            break;
        default:
            break;
    }
    return ret;
}

+ (NSString*)getformatDateStringWithChat:(double)time
{
    
    NSString *ret = @"";
    
    NSDate * messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:time];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |NSWeekdayCalendarUnit;
    
    NSDateComponents *messageComponents = [cal components:unitFlags fromDate:messageDate];
    
    NSInteger messageWeek = [messageComponents weekday];
    NSDateComponents *nowDateComponents = [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger nowWeek = [nowDateComponents weekday];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeInterval second = [[NSDate date] timeIntervalSinceDate:messageDate];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    NSString * nowDayString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString * messageDayString = [dateFormatter stringFromDate:messageDate];
    
    NSString * yesterdayString = [dateFormatter stringFromDate:yesterday];
    
    
    //相差的小时数
    int hours = second / 3600;
    
    [dateFormatter setDateFormat:@"ahh:mm"];
    NSString *timeStr = [dateFormatter stringFromDate:messageDate];
    
    if ([messageComponents year] == [nowDateComponents year]) {
        
        if ([nowDayString isEqualToString:messageDayString]) {
            ret = timeStr;
        }
        else if( [yesterdayString isEqualToString:messageDayString]){
            
            ret = [NSString stringWithFormat:@"昨天 %@",timeStr];
            
        }
        else  if(hours <= 24 * 7) {
            
            if (messageWeek == 1) { //周日
                
                //ret = @"上周日";
                [dateFormatter setDateFormat:@"yyyy-MM-dd ahh:mm"];
                ret = [dateFormatter stringFromDate:messageDate];
            }
            
            if (nowWeek > messageWeek) {
                
                NSString *weekStr = [ChatUtil getWeekWithChat:messageWeek];
                ret = [NSString stringWithFormat:@"%@ %@",weekStr,timeStr];
            }
            else {
                
                //ret = [NSString stringWithFormat:@"上%@",[ChatUtil getWeek:messageWeek]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd ahh:mm"];
                ret = [dateFormatter stringFromDate:messageDate];
            }
            
        }
        else {
            
//            [dateFormatter setDateFormat:@"MM-dd"];
//            
//            ret = [dateFormatter stringFromDate:messageDate];
            [dateFormatter setDateFormat:@"yyyy-MM-dd ahh:mm"];
            ret = [dateFormatter stringFromDate:messageDate];
        }
    }
    else {
        
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        ret = [dateFormatter stringFromDate:messageDate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd ahh:mm"];
        ret = [dateFormatter stringFromDate:messageDate];
        
    }
    
    return ret;
}


+ (NSString*)getWeekWithChat:(NSInteger)week
{
    
    NSString *ret = @"";
    
    switch (week) {
        case 1:
            ret = @"星期日";
            break;
        case 2:
            ret = @"星期一";
            break;
        case 3:
            ret = @"星期二";
            break;
        case 4:
            ret = @"星期三";
            break;
        case 5:
            ret = @"星期四";
            break;
        case 6:
            ret = @"星期五";
            break;
        case 7:
            ret = @"星期六";
            break;
        default:
            break;
    }
    return ret;
}

@end
