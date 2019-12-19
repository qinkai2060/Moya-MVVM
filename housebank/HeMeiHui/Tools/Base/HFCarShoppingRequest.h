//
//  HFCarShoppingRequest.h
//  HeMeiHui
//
//  Created by usermac on 2018/11/9.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "YTKRequest.h"
#import "SpMainHomeViewController.h"
#import "SpAssembleViewController.h"
#import "AssembleGoodDetailViewController.h"
#import "SpSpikeViewController.h"
#import "SpGoodsDetailViewController.h"
#import "ShopListViewController.h"
#import "SpCartViewController.h"
#import "HFPayMentViewController.h"
#import "SpTypesSearchListViewController.h"
#import "SpTypesViewController.h"
#import "HFEveryDayViewController.h"
#import "ZJCityViewControllerOne.h"
#import "HMHVideosListViewController.h"
#import "AssembleSearchListViewController.h"
#import "HFHightEndGoodsViewController.h"
#import "HFCrazyGoodsViewController.h"
#import "HFFamousGoodsViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFCarShoppingRequest : YTKRequest
@property(nonatomic,strong)NSString * referer;
@property(nonatomic,strong)NSString * urlTitle;
//+ (instancetype)requestURL:(NSString*)requestURL requstType:(YTKRequestMethod)requestType params:(NSDictionary*)params success:(YTKRequestCompletionBlock)success error:(YTKRequestCompletionBlock)failure;
+ (instancetype)requestURL:(NSString*)requestURL baseHeaderParams:(NSDictionary*)headerParams requstType:(YTKRequestMethod)requestType params:(NSDictionary*)params success:(YTKRequestCompletionBlock)success error:(YTKRequestCompletionBlock)failure;
+ (NSString*)sid;
+ (NSString*)uid;

@end

NS_ASSUME_NONNULL_END
