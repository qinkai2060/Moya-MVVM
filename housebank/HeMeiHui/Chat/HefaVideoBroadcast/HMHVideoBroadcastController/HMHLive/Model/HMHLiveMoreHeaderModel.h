//
//  HMHLiveMoreHeaderModel.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHLiveMoreModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveMoreHeaderModel : NSObject

@property (nonatomic,strong)NSArray<HMHLiveMoreModel *> *live_stream_header;
@property (nonatomic,strong)NSArray<HMHLiveMoreModel *> *well_chosen_header;
@property (nonatomic,strong)NSArray<HMHLiveMoreModel *> *short_video_header;
@property (nonatomic,strong)NSArray<HMHLiveMoreModel *> *recommend_header;

@end

NS_ASSUME_NONNULL_END
