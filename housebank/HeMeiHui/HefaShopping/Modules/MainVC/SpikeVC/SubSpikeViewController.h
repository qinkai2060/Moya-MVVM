//
//  SubSpikeViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/19.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "AdvertisementMode.h"
#import "HFShouYinViewController.h"
#import "SpTypeSearchListNoContentView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SubSpikeViewController : SpBaseViewController
@property (nonatomic, assign) NSInteger activityId;//活动ID
@property (nonatomic, copy) NSString *stateStr;//活动ID
@property (nonatomic, strong) AdvertisementMode *advertisementMode;
@property (nonatomic, strong)SpTypeSearchListNoContentView *contentViewSubView;
@end

NS_ASSUME_NONNULL_END
