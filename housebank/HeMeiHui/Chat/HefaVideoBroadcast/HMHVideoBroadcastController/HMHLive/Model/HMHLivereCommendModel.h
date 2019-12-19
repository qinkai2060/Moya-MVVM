//
//  HMHLivereCommendModel.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HMHliveParamsModel;

@interface HMHLivereCommendModel : NSObject

@property (nonatomic, copy) NSString *wd_id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, copy) NSString *target;
@property (nonatomic,strong)NSNumber *hits;
@property (nonatomic,strong)NSNumber *sceneType;
@property (nonatomic,strong)NSNumber *videoStatus;
@property (nonatomic,strong)NSString *videoTagName;
@property (nonatomic,strong)HMHliveParamsModel *params;

//@property (nonatomic, strong) NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
