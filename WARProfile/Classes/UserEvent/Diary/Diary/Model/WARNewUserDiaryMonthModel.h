//
//  WARNewUserDiaryMonthModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/15.
//


#import <Foundation/Foundation.h>
@class WARNewUserDiaryMomentOutline;

/** 上一个月份的年份 */
static NSString *kPreMonthYearKey = @"kPreMonthYearKey";


@interface WARNewUserDiaryMonthModel : NSObject

/** 日期，需要转换 */
@property (nonatomic, copy) NSString *date;
/** momentOutlines */
@property (nonatomic, strong) NSMutableArray <WARNewUserDiaryMomentOutline *> *momentOutlines;

/** 辅助字段 */
@property (nonatomic, copy) NSString *bgImageUrl;
/** 日期字符串 */
@property (nonatomic, copy) NSString *dateString;
/** 年 */
@property (nonatomic, copy) NSString *year;
/** 月 */
@property (nonatomic, copy) NSString *month;
/** 日志悬浮月份title */
@property (nonatomic, copy) NSString *diaryToolBarTitle;
/** 日志月份图片上的title */
@property (nonatomic, copy) NSString *diaryMonthViewTitle;
/** 日志月份是否显示年份 */
@property (nonatomic,assign)BOOL showYear;
/** momentOutlines 数量 */
@property (nonatomic,assign)NSInteger count;

/** current month total height */
@property (nonatomic,assign) CGFloat currentMonthDisplayHeight;
/** current month 当前偏移量 */
@property (nonatomic,assign) CGFloat currentMonthDisplayOffsetY;
/** current month 当前底部y */
@property (nonatomic,assign) CGFloat currentMonthDisplayBottomY;

@end

@interface WARNewUserDiaryMomentOutline : NSObject
 
@property (nonatomic,assign) CGFloat displayHeight;
@property (nonatomic, copy) NSString *momentId;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic,assign) NSInteger pageCount;

/** 辅助字段，整条moment所需高度 */
@property (nonatomic,assign) CGFloat displayMomentHeight;
@property (nonatomic,assign) BOOL isSinglePage;
@end
