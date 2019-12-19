//
//  NavigationContrl.h
//  HeMeiHui
//
//  Created by 任为 on 2017/12/8.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopAppointViewControllerModel.h"
#import "PageUrlConfigModel.h"

@interface NavigationContrl : NSObject

/**
 处理新开窗口后的一些处理，包括关闭某些页面、刷新某些页面

 @param model 当前新开页面的信息
 @param navigation 当前的导航
 */

/**
 <#Description#>

 @param model <#model description#>
 @param url <#url description#>
 @param navigation <#navigation description#>
 @param lastPageUrl <#lastPageUrl description#>
 */
+(void)dealCloseOrRefreshPagesAfterOpenNewPage:(PopAppointViewControllerModel*)model url:(NSString*)url Navigation:(UINavigationController*)navigation lastPageUrl:(NSString*)lastPageUrl;

/**
 根据url获取对应的Model

 @param url 页面的url
 @return 对应的model
 */
+ (PopAppointViewControllerModel*)getModelFrom:(NSString*)url;
+ (PageUrlConfigModel*)getPageurlModelFrom:(NSString*)url;
+ (PageUrlConfigModel *)getPageurlModelByPageTag:(NSString*)pageTag;


/**
 切换tab的方法

 @param tabType 要切换的tabindex
 @param navigation 当前导航
 */
+ (void)changeTabIndexWith:(mianTab_type)tabType and:(UINavigationController*)navigation and:(NSString*)urlStr and:(PageUrlConfigModel*)pageUrlModel;

/**
 登陆后移除最后一个页面

 @param navigation 当前导航
 */
+(void)closeLastPage:(UINavigationController*)navigation;
@end
