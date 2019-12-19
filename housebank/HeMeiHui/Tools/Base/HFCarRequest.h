//
//  HFCarRequest.h
//  HeMeiHui
//
//  Created by usermac on 2019/2/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
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

#define nativeSwitch @"navtiveSwitch"
@interface HFCarRequest:YTKRequest
@property(nonatomic,strong)NSString * referer;
@property(nonatomic,strong)NSString * urlTitle;
//- (id)initWithUsername:(NSString *)sid terminal:(NSString *)terminal;
////- (id)initWithDict:(NSDictionary*)prames;
//- (id)initWithDict:(NSDictionary *)prames withRequstUrl:(NSString*)requestUrl;
+  (instancetype)requsetUrl:(NSString*)requestURL withRequstType:(YTKRequestMethod)requestType requestSerializerType:(YTKRequestSerializerType)requestSerializerType  params:(NSDictionary*)params success:(YTKRequestCompletionBlock)success error:(YTKRequestCompletionBlock)failure;
- (RACSignal *)rac_requestSignal;
+ (NSDictionary*)sid;
+ (NSString *)terminal;
+ (void)updateClickNumber:(NSString*)adID;
+ (void)navtiveSwitch;
@end


