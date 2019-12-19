//
//  SelVideoPlayer.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/26.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracyPlaybackControls.h"
@class TracyPlayerConfiguration;
@interface TracyVideoPlayer : UIView
/** 视频播放控制面板 */
@property (nonatomic, strong) TracyPlaybackControls *playbackControls;
/** 播放器 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/**
 初始化播放器
 @param configuration 播放器配置信息
 */
- (instancetype)initWithFrame:(CGRect)frame configuration:(TracyPlayerConfiguration *)configuration withControls:(TracyPlaybackControls *)controls;

/** 播放视频 */
- (void)_playVideo;
/** 暂停播放 */
- (void)_pauseVideo;
/** 释放播放器 */
- (void)_deallocPlayer;

@end
