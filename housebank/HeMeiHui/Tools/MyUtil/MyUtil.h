//
//  MyUtil.h
//  Dcc.mc.cc
//
//  Created by Qianhong Li on 2018/6/1.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UIView+Position.h"
@interface MyUtil : NSObject

//---------------------------------------------------------------------------------
//                            通用类方法
//---------------------------------------------------------------------------------



//------------------------------UIView----------------------------
/**
 *  UIView frame 颜色
 */
+ (UIView *)createViewWithFrame:(CGRect)frame color:(UIColor *)color;

//------------------------------UIImageView-----------------------
/**
 *  UIImageView frame 图片的名字
 */
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

 //------------------------------UILabel---------------------------
/**
 *  UILabel frame 显示的文字 字体大小 对齐方式
 */
+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

/**
 *  UILabel frame 显示的文字 字体颜色 字体大小
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

/**
 *  UILabel frame 显示的文字 字体颜色 字体大小 行数  对齐方式
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)color font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment;

 //------------------------------UIButton--------------------------
/**
 *  UIButton frame 图片名字 选中的图片名字 点击事件
 */
+ (UIButton *)createBtnFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action;


/**
 *  UIButton frame 图片名字 选中的图片名字  标题  标题颜色  选中的标题颜色 字体  背景颜色 点击事件
 */
+ (UIButton *)createBtnFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;

/**
 *  UIButton frame   标题  标题颜色  字体  背景颜色 点击事件
 */
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)titleName titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;


 //------------------------------动画-------------------------------

/**
 *  视图控件下拉动画
 */
+ (void) animateView:(UIView *)view down:(BOOL)down distance:(CGFloat)distance;
/**
 *  视图控件上拉动画
 */
+ (void) animateView:(UIView *)view up:(BOOL)up distance:(CGFloat)distance;
/**
 *  弹出提示消息 消息内容
 */
+ (void)showAlertView:(NSString *)message;



//-----------------------------------------------------------------

/**
 *  自动获取宽度
 */
+ (CGFloat)getWidthWithFontSize:(CGFloat)font  height:(CGFloat)height text:(NSString *)text;
+ (CGFloat)getWidthWithFont:(UIFont *)font  height:(CGFloat)height text:(NSString *)text;

/**
 *  自动获取高度
 */
+ (CGFloat)getHeightWithFontSize:(CGFloat)font  with:(CGFloat)with text:(NSString *)text;

+ (CGFloat)getHeightWithFont:(UIFont*)font  with:(CGFloat)with text:(NSString *)text;
/**
 *  自动带行距文本文字高度
 */
+ (CGFloat)getHeightWithStr:(NSString *)str width:(CGFloat)width lineSpace:(CGFloat)lineSpace font:(CGFloat)font;


/**
 *  自动获取SIZE
 */
+ (CGSize)getSizeWithFontSize:(CGFloat)font  with:(CGFloat)with text:(NSString *)text;
/**
 *  获取label上的每行文字
 */
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

/**
 *  分割线
 */
+ (void)createLineWithFrame:(CGRect)frame WithBgView:(UIView *)bgView;

/** 分割线 */
+ (UIView *)createLineWithFrame:(CGRect)frame color:(UIColor *)color WithBgView:(UIView *)bgView;

/**
 *  修改文字的属性 颜色 字体 范围
 */
+ (NSMutableAttributedString *)getAttributedWithString:(NSString *)string Color:(UIColor *)color font:(UIFont *)font range:(NSRange)range;
/**
 *  隐藏手机号码中间四位
 *
 *  @param phone 手机号码
 *
 *  @return 隐藏后的手机号码
 */
+ (NSString *)hidePhoneNumberWithNumber:(NSString *)phone;
//-----------------------------------------------------------------
//                      针对本App封装的类方法
//-----------------------------------------------------------------

/**
 *  隐藏固话号码中间五位
 *
 *  @param number 固话号码
 *
 *  @return 隐藏后的固话号码
 */
+ (NSString *)hideTelephoneNumberWithNumber:(NSString *)number;

/**
 *  隐藏名字**
 *
 *  @param nameString 传进来全名
 *
 *  @return 返回加密的名字
 */
+ (NSString *)hideFirstNameWithNameString:(NSString *)nameString;
//根据服务器返回的字符串转换成到秒的时间戳
+ (double)getTimeStampFormTimeString:(NSString *)timeStr;
///yyyy-MM-dd HH:mm:ss
+(NSString *)getFormatTimeStringWithTimeString:(NSString *)timeStr;
/**
 *  时间转字符串
 *
 *  @param dateFormat 时间格式
 *  @param timeStr    服务器返回时间
 *
 *  @return 字符串
 */
+(NSString *)getFormatTimeStringWithDateFormat:(NSString *)dateFormat timeString:(NSString *)timeStr;
///yy-MM-dd HH:mm:ss
+ (NSString *)dateTimeWithAllString:(NSString *)string;

+ (double)getFavoriteTimeStampFormTimeString:(NSString *)timeStr;
///yyyy年MM月dd日 HH:mm:ss
+ (NSString *)getDateTimeWithAllString:(NSString *)string;

///yy-MM-dd
+ (NSString *)mallGetDateTimeWithAllString:(NSString *)string;

///时间格式yy/mm/dd
+(NSString *)mallGetDateTimeWithString:(NSString *)string;
///时间格式yyyy/mm/dd
+(NSString *)getDateTimeWithString:(NSString *)string;


///对比curDate和date的时间差，
/*
 小于60s返回“刚刚”
 小于1h返回“xx分钟前”
 小于60s返回“刚刚”
 小于1h返回“xx分钟前”
 小于1d返回“xx小时前”
 小于3d返回“xx天前”
 其余返回日期年月日
 */
+(NSString *)getCompareTimeWithDate:(NSDate *)date curDate:(NSDate *)curDate;

//将秒转位天、小时、分、秒
+ (NSString *)getSecondsTimeWithSeconds:(NSInteger)seconds;
//显示是分秒 00：00:00
+ (NSString *)getSecondsTimeWithLeftTime:(NSInteger)seconds;
 // 求两个时间的时，  分 ，秒
+(NSArray *)getTwoDataMin:(NSString *)stamp1 andWith:(NSString *)stamp2;


+ (BOOL)validatePhone:(NSString *)phone;

+ (BOOL) validateEmail:(NSString *)email;

//手机验证码 验证 0-9 6位数字
+ (BOOL)validateCode:(NSString *)code;
/**
 *  条形码验证
 *
 *  @return 返回是否符合
 */
+(BOOL)validateBarCode:(NSString *)barCode;
//生成随机8位用户名
+ (NSString *)randomUserName;

//随机密码
+ (NSString *)randomPassword;

+ (CGFloat)getHeightWithScreenHeight;

/**
 *  修改视图某一个角为圆角
 *
 *  @param view        视图
 *  @param corners     指定哪一个角
 *  @param cornerRadii 角的尺寸
 */
+ (UIView *)changeView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

#ifdef MCF_TYPE_APPStore
#else
//检查是否安装过某个应用
//+(BOOL)IsInstalledApp:(NSString*)identifier;
#endif

/**
 *  打电话
 *
 *  @param number 手机号
 *  @param view   父视图 一般为 self.View
 */
+ (void)MakeAPhoneCallWithTelephoneNumber:(NSString *)number withBgView:(UIView *)view;


+ (NSString *)numberDecimalFormString:(NSString *)str;

//数字中间加逗号分隔 并保留两位小数
+ (NSString *)floatDecimalFormString:(NSString *)str;

/**
 // 创建警告框 并且3秒后自动消失  样式
 居中图片
 下载成功（失败）
 成功或失败描述
 */
+(void)createDownLoadStateAlertViewWithImageName:(NSString *)imageName title:(NSString *)titleStr describeStr:(NSString *)describeStr;

// 字符串判空
+ (NSString *)isNullToString:(id)string;

// 根据图片的地址来获取图片的size
+(CGSize)getImageSizeWithURL:(id)imageURL;

// 根据获取缓存中的图片 若没有缓存 则存入
+ (UIImage *)getCacheImageWithImageUrl:(NSString *)imgUrl;
+(NSString *)getNowTimeTimestamp3;
+(NSString*)compareTwoTime:(NSString*)time1 time2:(NSString*)time2;

//传入今天的时间，返回明天的时间

+ (NSString *)GetTomorrowDay:(NSDate *)aDate;
//将字符串转成NSDate类型

+ (NSDate *)dateFromString:(NSString *)dateString;
//获取当地时间
+ (NSString *)getCurrentTime;
+ (NSString*)getDays:(NSDate *)startTime endDay:(NSDate *)endTime;
//将时间戳转换为时间
+(NSDate *)timestampToDate:(CGFloat)timestamp;
//将时间转换为时间戳
+(NSString *)dateToTimestamp:(NSDate*)date;
@end
