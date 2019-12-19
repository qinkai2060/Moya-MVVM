//
//  AliYunVodPlayerViewController.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/3.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HMHBasePrimaryViewController.h"
#import "AliWMPlayerView.h"
// 使用阿里播放器   回放
@interface HMHAliYunVodPlayerViewController : HMHBasePrimaryViewController
// 播放器View
@property (nonatomic, strong) AliWMPlayerView *player;
//播放器sdk
//@property (nonatomic, strong) AliyunVodPlayer *vodPlayer;

@property(nonatomic,strong)NSNumber *indexSelected;/*顺序*/

@property (nonatomic, strong) NSString *videoNum;

// 来自观看历史 跳转到指定的时间
@property (nonatomic, assign) double seekTime;

@end
