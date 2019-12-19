//
//  ManagementTools.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/21.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "CommonManagementTools.h"

@implementation CommonManagementTools
+ (id)CommonManagementTools{
    static CommonManagementTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (NSString *)getCompareTimeWithDate:(NSDate *)date curDate:(NSDate *)curDate{
    NSTimeInterval timeInterval = [curDate timeIntervalSinceDate:date];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
//        result = [NSString stringWithFormat:@"刚刚"];
        NSString *str = [NSString stringWithFormat:@"%f",timeInterval];
        long resultL = [str longLongValue];
        result = [NSString stringWithFormat:@"%ld秒前",resultL];
    } else if ((temp = timeInterval / 60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if ((temp = temp / 60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if ((temp = temp / 24) < 30){
        if (temp / 7 <= 4 && temp / 7 > 0) { // 周
            long weekL = 0;
            weekL = temp / 7;
            result = [NSString stringWithFormat:@"%ld周前",weekL];
        } else { // 天
            result = [NSString stringWithFormat:@"%ld天前",temp];
        }
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else  {
        NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yy-MM-dd"];
        result = [dateFormat stringFromDate:date];
    }
    return result;
}

// 自动获取高度
+ (CGFloat)getHeightWithFontSize:(CGFloat)font  withWidth:(CGFloat)width text:(NSString *)text{
    if (!text || text.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}

// 自动获取宽度
+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil].size.width;
    return width;
}



// 实现搜索结果变色
+ (NSMutableAttributedString *)setSearchResultStringColorWithResultStr:(NSString *)resultString searchStr:(NSString *)searchString color:(UIColor *)color{
    
    NSError *error = NULL;
    
    NSString *initStr = resultString;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:initStr];
    
    NSString *searchStr = searchString;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *rangeArray = [expression matchesInString:initStr options:0 range:NSMakeRange(0, initStr.length)];
    
    for (NSTextCheckingResult *result in rangeArray) {
        
        NSRange range = [result range];
        
        if (range.location != NSNotFound) {
            
            [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location,range.length)];
        }
    }
    return str;
}


@end
