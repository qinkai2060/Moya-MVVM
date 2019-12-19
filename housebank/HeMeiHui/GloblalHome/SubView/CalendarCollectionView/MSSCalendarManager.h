//
//  MSSCalendarManager.h
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSSCalendarDefine.h"
//#import "MSSCalendarViewController.h"
//#import "JYCAplaceCalendarController.h"

@interface MSSCalendarManager : NSObject

@property (nonatomic,strong)NSIndexPath *startIndexPath;

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar startDate:(NSInteger)startDate;
// 获取数据源
- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type;
- (NSArray *)getCalendarDataSoruceWithMinNum:(NSInteger )minNum MaxNum:(NSInteger )maxNum startDate:(NSInteger )startDate endDate:(NSInteger )endDate andDataArray:(NSArray *)dataArray;
- (NSArray *)getJYCCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type calendarType:(MSSCalendarWithUserType)calendarType priceArray:(NSArray *_Nonnull)priceArray;



@end
