//
//  ShareTools.h
//  HeMeiHui
//
//  Created by 任为 on 2016/12/28.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shareModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <WeiboSDK.h>

//#import <JSONKit.h>
#import "GoodsDetailModel.h"

@protocol ShareToolDelegete <NSObject>
@optional

// 此处的state返回的是json字符串
- (void)sendShareState:(NSString*)state;
//此处的state就是单纯的返回分享状态 1 成功  2 失败   -1 失败 未安装客户端
- (void)shareResultState:(NSString *)state;

@end
@interface ShareTools : NSObject


@property (nonatomic, strong)shareModel *shareModel;
@property (nonatomic, weak)UIViewController<ShareToolDelegete>*delegete;
// 通用的分享
- (void)doShare:(id)body;

// ========================= 合友圈share ======================
// 合友圈的分享
//- (void)circleOfFriendsShareWithModel:(shareModel *)shareModel;


+(NSDictionary*)dict:(NSDictionary *)response ;

//自定义分享

+(void)shareWithContent:(id)publishContent;

//商品详情分享
+(void)goodDetailShareWithContent:(id)publishContent detailModel:(GoodsDetailModel *) detailModel;/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/

@end
