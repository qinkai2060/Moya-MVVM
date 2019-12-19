//
//  MSSCalendarDefine.h
//  MSSCalendar
//
//  Created by 于威 on 16/4/4.
//  Copyright © 2016年 于威. All rights reserved.
//


#define MSS_Iphone6Scale(x) ((x) * ScreenW / 375.0f)
#define MSS_ONE_PIXEL (1.0f / [[UIScreen mainScreen] scale])
#define AlphaHeaderViewHeight  100
#define MSS_HeaderViewHeight  44
#define MSS_WeekViewHeight    74
//// 弹出层文字颜色
//#define MSS_CalendarPopViewTextColor [UIColor whiteColor]
//// 弹出层背景颜色
//#define MSS_CalendarPopViewBackgroundColor [UIColor blackColor]



typedef NS_ENUM(NSInteger, MSSCalendarViewControllerType)
{
    MSSCalendarViewControllerLastType = 0,// 只显示当前月之前
    MSSCalendarViewControllerMiddleType,// 前后各显示一半
    MSSCalendarViewControllerNextType// 只显示当前月之后
};

typedef NS_ENUM(NSInteger, MSSCalendarWithUserType)
{
    MSSCalendarHotelType = 0,  // 酒店   入住 --- 离店
    MSSCalendarTrainType,      // 火车票，飞机票，单选无价格
    MSSCalendarAplaceType,     // 基地   价格
    MSSCalendarSecnicType,     // 景点   价格
    MSSCalendarPlaneType,      // 机票
    MSSCalendarActivityType    // 活动，线路

};


