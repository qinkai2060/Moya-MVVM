//
//  ManagementTools.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/21.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
// 常用工具类
@interface CommonManagementTools : NSObject

+ (id)CommonManagementTools;

/**
 根据时间获取到X秒前 X分钟前 X小时前 X天前 X周前 X月前 X年前
 @param date  服务器返回的时间
 @param curDate  [NSDate date]当前日期
 */
+ (NSString *)getCompareTimeWithDate:(NSDate *)date curDate:(NSDate *)curDate;

/**
 // 自动获取高度
 @param font 字号
 @param width 宽
 @param text 内容
 */
+ (CGFloat)getHeightWithFontSize:(CGFloat)font  withWidth:(CGFloat)width text:(NSString *)text;
// 自动获取宽度
+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text;

// 实现搜索结果变色
+ (NSMutableAttributedString *)setSearchResultStringColorWithResultStr:(NSString *)resultString searchStr:(NSString *)searchString color:(UIColor *)color;

@end
