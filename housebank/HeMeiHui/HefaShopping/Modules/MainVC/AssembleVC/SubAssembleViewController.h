//
//  SubAssembleViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "AdvertisementMode.h"
#import "HFShouYinViewController.h"
#import "SpGoodsDetailViewController.h"
#import "SpTypeSearchListNoContentView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , AssembleChangeType) {
    
    //正在进行
    AssembleUnderwayType= 1,
    //即将开始
    AssembleWillBeginType,
    //已结束
    AssembleEndType,
    
    
};
@interface SubAssembleViewController : SpBaseViewController
//新增类型
@property (nonatomic ,assign) AssembleChangeType assembleChangeType;
@property (nonatomic, assign) NSInteger activityId;//活动ID
@property (nonatomic, strong) AdvertisementMode *advertisementMode;
@property (nonatomic, strong)SpTypeSearchListNoContentView *contentViewSubView;
@end

NS_ASSUME_NONNULL_END
