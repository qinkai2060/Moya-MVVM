//
//  HMHLiveAttentionModel.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveAttentionModel : NSObject

@property (nonatomic, copy) NSString *wd_id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *coverImageUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, copy) NSString *target;
@property (nonatomic,strong)NSNumber *hits;
@property (nonatomic,strong)NSNumber *sceneType;
@property (nonatomic,strong)NSNumber *videoStatus;

@property (nonatomic,strong)NSString *videoTagName;

@property (nonatomic,copy)NSString *vno;

@end

NS_ASSUME_NONNULL_END
