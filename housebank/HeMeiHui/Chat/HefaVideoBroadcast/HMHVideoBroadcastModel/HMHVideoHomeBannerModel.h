//
//  VideoHomeBannerModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/4/26.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
// 视频首页轮播图
@interface HMHVideoHomeBannerModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSNumber *tag;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) NSDictionary *params;

@end
