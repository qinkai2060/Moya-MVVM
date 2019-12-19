//
//  SpNotificationCenterName.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpNotificationCenterName : NSObject
#pragma mark - 项目中所有通知
//联系商家，进店逛逛通知
UIKIT_EXTERN NSString *const ShopAroundAndContact;
//查看评价
UIKIT_EXTERN NSString *const SeaTheReviewList ;
//   查看咨询
UIKIT_EXTERN  NSString *const SeaConsultationDetail;
//选择规格
UIKIT_EXTERN NSString *const SelectionSpecification;
//查看参数
UIKIT_EXTERN  NSString *const SeaParameters;
//查看大图
UIKIT_EXTERN  NSString *const SeaTheBigPicList;
//进入店铺
UIKIT_EXTERN NSString *const GoToStoreList;
//进入详情
UIKIT_EXTERN NSString *const ShopeProductDetailView;
/** 登录成功选择控制器通知 */
UIKIT_EXTERN NSString *const LOGINSELECTCENTERINDEX;
/** 退出登录成功选择控制器通知 */
UIKIT_EXTERN NSString *const LOGINOFFSELECTCENTERINDEX;

/** 添加购物车或者立即购买通知 */
UIKIT_EXTERN NSString *const SELECTCARTORBUY;


/** 滚动到商品详情界面通知 */
UIKIT_EXTERN NSString *const SCROLLTODETAILSPAGE;
/** 滚动到商品评论界面通知 */
UIKIT_EXTERN NSString *const SCROLLTOCOMMENTSPAGE;

/** 展现顶部自定义工具条View通知 */
UIKIT_EXTERN NSString *const SHOWTOPTOOLVIEW;
/** 隐藏顶部自定义工具条View通知 */
UIKIT_EXTERN NSString *const HIDETOPTOOLVIEW;


/** 商品属性选择返回通知 */
UIKIT_EXTERN NSString *const SHOPITEMSELECTBACK;

/** 分享弹出通知 */
UIKIT_EXTERN NSString *const SHAREALTERVIEW;

/** 美信消息Item改变通知 */
UIKIT_EXTERN NSString *const DCMESSAGECOUNTCHANGE;
UIKIT_EXTERN NSString *const GoToPinTuanlViewView;
@end

NS_ASSUME_NONNULL_END
