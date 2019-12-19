//
//  HMHliveParamsModel.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHliveParamsModel : NSObject

@property (nonatomic,strong)NSNumber *videoStatus;//1预告2直播中34回放

@property (nonatomic,strong)NSNumber *sceneType;
@property (nonatomic,strong)NSNumber *liveStartTime;

@end

NS_ASSUME_NONNULL_END
