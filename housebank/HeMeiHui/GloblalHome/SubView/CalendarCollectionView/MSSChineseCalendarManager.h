//
//  MSSChineseCalendarManager.h
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSCalendarHeaderModel.h"

@interface MSSChineseCalendarManager : NSObject

- (void)getChineseCalendarWithDate:(NSDate *)date calendarItem:(MSSCalendarModel *)calendarItem;

- (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
