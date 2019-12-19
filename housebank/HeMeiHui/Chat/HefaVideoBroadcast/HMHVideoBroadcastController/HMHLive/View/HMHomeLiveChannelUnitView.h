//
//  HMHomeLiveChannelUnitView.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHLivereCommendModel.h"
#import "HMHLiveAttentionModel.h"
#import "HMHVideoListNewModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface HMHomeLiveChannelUnitView : UIControl

@property (nonatomic,strong)HMHLivereCommendModel *model;

@property (nonatomic,strong)HMHLiveAttentionModel *attentionModel;

@property (nonatomic,strong)HMHVideoListNewModel *listNewModel;

@end

NS_ASSUME_NONNULL_END
