//
//  HMHLiveModel.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHLiveModules_newsModel.h"
#import "HMHLiveModules_4Model.h"
NS_ASSUME_NONNULL_BEGIN
@class HMHLiveBannerModel,HMHLivereCommendModel,HMHLiveShortVideoModel,HMHLiveWellChosenModel,HMHLiveLiveStreamModel;
@interface HMHLiveModel : NSObject

@property(nonatomic,strong)NSArray<HMHLivereCommendModel *> *banner;//轮播

@property(nonatomic,strong)NSArray<HMHLiveModules_newsModel *> *modules_news;//快讯

@property(nonatomic,strong)NSArray<HMHLivereCommendModel *> *recommend;

//@property(nonatomic,strong)NSArray<HMHLiveModules_4Model *> *modules_4;//首页直播推荐

@property(nonatomic,strong)NSArray<HMHLivereCommendModel *> *short_video;//短视频

@property(nonatomic,strong)NSArray<HMHLivereCommendModel *> *well_chosen;

@property(nonatomic,strong)NSArray<HMHLivereCommendModel *> *live_stream;//直播破门大炮

@end

NS_ASSUME_NONNULL_END
