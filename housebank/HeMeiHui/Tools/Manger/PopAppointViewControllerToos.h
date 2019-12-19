//
//  PopAppointViewControllerToos.h
//  HeMeiHui
//
//  Created by 任为 on 2017/10/11.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopAppointViewControllerModel.h"

typedef enum {
    main_home =0,
    main_mall,
    main_globalhome,
    main_moments,
    main_mine,
    external_domain,//外网
    openNewPop,//新开模式
    loadByWebView,//页面内加载
}mianTab_type;
@interface PopAppointViewControllerToos : NSObject

/**
 需要拦截跳转打开新窗口的数组
 */
@property (nonatomic,strong)NSMutableArray * popWindowUrlsArrary;

/**
 主Url和登录等相关的数组
 */
@property (nonatomic,strong)NSMutableArray * pageUrlConfigArrary;
@property (nonatomic,strong)PopAppointViewControllerModel * currentPopModle;
+ (id)sharePopAppointViewControllerToos;

/**
 检测是否要新开窗口，返回加载页面的方式

 @param url 对应的要加载的url
 @return  mianTab_type为加载页面的方式
 */
- (mianTab_type)isPopNewWindowWithcheckUrl:(NSString*)url;

/**
 判断是否切换tab的index

 @param url 要加载的url
 @return  index 的值
 */
- (NSInteger)isShouChangeIndexWithUrl:(NSString*)url;
@end
