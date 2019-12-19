//
//  HFPlayVideoManger.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFPlayerView.h";
@class ZFPlayerPresentView;
typedef NS_ENUM(NSUInteger, ZFPlayerPlaybackState) {
    ZFPlayerPlayStateUnknown,
    ZFPlayerPlayStatePlaying,
    ZFPlayerPlayStatePaused,
    ZFPlayerPlayStatePlayFailed,
    ZFPlayerPlayStatePlayStopped
};

typedef NS_OPTIONS(NSUInteger, ZFPlayerLoadState) {
    ZFPlayerLoadStateUnknown        = 0,
    ZFPlayerLoadStatePrepare        = 1 << 0,
    ZFPlayerLoadStatePlayable       = 1 << 1,
    ZFPlayerLoadStatePlaythroughOK  = 1 << 2, // Playback will be automatically started.
    ZFPlayerLoadStateStalled        = 1 << 3, // Playback will be automatically paused in this state, if started.
};

typedef NS_ENUM(NSInteger, ZFPlayerScalingMode) {
    ZFPlayerScalingModeNone,       // No scaling.
    ZFPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits.
    ZFPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents.
    ZFPlayerScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds.
};

@protocol ZFPlayerMediaPlayback <NSObject>

@required
// 播放的view


@optional
// 音量
/// Only affects audio volume for the player instance and not for the device.
/// You can change device volume or player volume as needed,change the player volume you can folllow the `ZFPlayerMediaPlayback` protocol.
@property (nonatomic) float volume;

//静音
/// indicates whether or not audio output of the player is muted. Only affects audio muting for the player instance and not for the device.
/// You can change device volume or player muted as needed,change the player muted you can folllow the `ZFPlayerMediaPlayback` protocol.
@property (nonatomic, getter=isMuted) BOOL muted;

/// Playback speed,0.5...2 快进多少
@property (nonatomic) float rate;

/// The player current play time. 当前时间
@property (nonatomic, readonly) NSTimeInterval currentTime;

/// The player total time. 总时间
@property (nonatomic, readonly) NSTimeInterval totalTime;

/// The player buffer time. 缓冲时间
@property (nonatomic, readonly) NSTimeInterval bufferTime;

/// The player seek time. 拖拽到哪里的时间
@property (nonatomic) NSTimeInterval seekTime;

/// The player play state,playing or not playing. s是否正在播放
@property (nonatomic, readonly) BOOL isPlaying;

/// Determines how the content scales to fit the view. Defaults to ZFPlayerScalingModeNone.
@property (nonatomic) ZFPlayerScalingMode scalingMode;

/**
 @abstract Check whether video preparation is complete.
 @discussion isPreparedToPlay processing logic
 
 * If isPreparedToPlay is TRUE, you can call [ZFPlayerMediaPlayback play] API start playing;
 * If isPreparedToPlay to FALSE, direct call [ZFPlayerMediaPlayback play], in the play the internal automatic call [ZFPlayerMediaPlayback prepareToPlay] API.
 * Returns YES if prepared for playback.
 */
@property (nonatomic, readonly) BOOL isPreparedToPlay; // 有无准备好播放

/// The player should auto player, default is YES.
@property (nonatomic) BOOL shouldAutoPlay; // 是否自动播放

/// The play asset URL.
@property (nonatomic) NSURL *assetURL; // 播放的url

/// The video size.
@property (nonatomic, readonly) CGSize presentationSize; // 尺寸

/// The playback state.
@property (nonatomic, readonly) ZFPlayerPlaybackState playState;// 播放的状态

/// The player load state.
@property (nonatomic, readonly) ZFPlayerLoadState loadState; // 加载的状态

///------------------------------------
/// If you don't appoint the controlView, you can called the following blocks.
/// If you appoint the controlView, The following block cannot be called outside, only for `ZFPlayerController` calls.
///------------------------------------

/// The block invoked when the player is Prepare to play. // 当播放器准备播放时的回调
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<ZFPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player is Ready to play. //当播放器准备好播放时调用的回调
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<ZFPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player play progress changed.当播放器播放进度改变时调用的块。
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<ZFPlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration);

/// The block invoked when the player play buffer changed.播放器播放缓冲区更改时调用的块。
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<ZFPlayerMediaPlayback> asset, NSTimeInterval bufferTime);

/// The block invoked when the player playback state changed.放器播放状态更改时调用的块。
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<ZFPlayerMediaPlayback> asset, ZFPlayerPlaybackState playState);

/// The block invoked when the player load state changed.当播放机加载状态更改时调用的块。
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<ZFPlayerMediaPlayback> asset, ZFPlayerLoadState loadState);

/// The block invoked when the player play failed.当播放器播放失败时调用的块。
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<ZFPlayerMediaPlayback> asset, id error);

/// The block invoked when the player play end.播放结束时调用的块。
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<ZFPlayerMediaPlayback> asset);

// The block invoked when video size changed.视频大小更改时调用的块。
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<ZFPlayerMediaPlayback> asset, CGSize size);

///------------------------------------
/// end
///------------------------------------

/// Prepares the current queue for playback, interrupting any active (non-mixible) audio sessions.
//准备当前的回放队列，中断任何活跃的（非MixBILE）音频会话
- (void)prepareToPlay;

/// Reload player. 重放
- (void)reloadPlayer;

/// Play playback.播放
- (void)play;

/// Pauses playback.
- (void)pause;

/// Replay playback.
- (void)replay;

/// Stop playback.
- (void)stop;

/// Video UIImage at the current time. 获取当前播放的图片
- (UIImage *)thumbnailImageAtCurrentTime;

/// Use this method to seek to a specified time for the current player and to be notified when the seek operation is complete.
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

@end
@interface ZFPlayerPresentView : ZFPlayerView

@property (nonatomic, strong) AVPlayer *player;
/// default is AVLayerVideoGravityResizeAspect.
@property (nonatomic, strong) AVLayerVideoGravity videoGravity; // 视频画面拉伸方式

@end
NS_ASSUME_NONNULL_BEGIN

@interface HFPlayVideoManger : NSObject<ZFPlayerMediaPlayback>
@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;
/// 视频请求头
@property (nonatomic, strong) NSDictionary *requestHeader;
@property (nonatomic, strong) ZFPlayerPresentView * view;
@end

NS_ASSUME_NONNULL_END
