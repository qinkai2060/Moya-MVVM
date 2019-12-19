//
//  ChatUtil.h
//  OOMall
//
//  Created by QianDeng on 15/11/25.
//  Copyright © 2015年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUtil : NSObject

#pragma mark - 获取文字高、宽
/**
 *  自动获取宽度
 */
+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text;
/**
 *  自动获取高度
 */
+ (CGFloat)getHeightWithFontSize:(CGFloat)font  width:(CGFloat)width text:(NSString *)text;



/**
 * 获取富文本文字高度
 */
+ (CGFloat)getHeightWithRichStr:(NSString *)str width:(CGFloat)width lineSpace:(CGFloat)lineSpace font:(CGFloat)font;

/**
 *  修改文字的属性 颜色 字体 范围
 */
+ (NSMutableAttributedString *)getAttributedWithString:(NSString *)string Color:(UIColor *)color font:(UIFont *)font range:(NSRange)range;


#pragma mark - 时间相关

//将服务器返回字符串转为时间戳
+ (double)getTimeStampFormTimeString:(NSString *)timeStr;

+ (NSString*)getformatDateString:(double)time;
+ (NSString*)getWeek:(NSInteger)week;

+ (NSString*)getformatDateStringWithChat:(double)time;

#pragma mark - Emoji表情处理

+ (NSString *)parseEmotion:(NSString *)text;

//设置表情的宽高
+ (NSString *)parseEmotion:(NSString *)text emotionHeight:(CGFloat)h;

+ (BOOL)stringIsFace:(NSString *)string;

+ (NSDictionary *)emotionsDict;

@end
