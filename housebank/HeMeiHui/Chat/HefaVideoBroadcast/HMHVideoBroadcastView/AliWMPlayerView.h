//
//  AliWMPlayerView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

#import "FastForwardView.h"
@class WMLightView;

@import MediaPlayer;
@import AVFoundation;
@import UIKit;
// 播放器的几种状态
typedef NS_ENUM(NSInteger, CustomWMPlayerState) {
    VodWMPlayerStateFailed,        // 播放失败
    VodWMPlayerStateBuffering,     // 缓冲中
    VodWMPlayerStatePlaying,       // 播放中
    VodWMPlayerStateStopped,        //暂停播放
    VodWMPlayerStateFinished,        //暂停播放
    VodWMPlayerStatePause,       // 暂停播放
};
// 枚举值，包含播放器左上角的关闭按钮的类型
//typedef NS_ENUM(NSInteger, CustomCloseBtnStyle){
//    CloseBtnStylePop, //pop箭头<-
//    CloseBtnStyleClose  //关闭（X）
//};

//手势操作的类型
typedef NS_ENUM(NSUInteger,VodPlayerControlType) {
    VodprogressControl,//视频进度调节操作
    VodvoiceControl,//声音调节操作
    VodlightControl,//屏幕亮度调节操作
    VodnoneControl//无任何操作
} ;


@class AliWMPlayerView;
@protocol AliWMPlayerDelegate <NSObject>
@optional
///播放器事件
//点击播放暂停按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn;
//点击关闭按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedCloseButton:(UIButton *)closeBtn;
//点击全屏按钮代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn;
//单击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap;
//双击WMPlayer的代理方法
-(void)wmplayer:(AliWMPlayerView *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap;
//WMPlayer的的操作栏隐藏和显示
-(void)wmplayer:(AliWMPlayerView *)wmplayer isHiddenTopAndBottomView:(BOOL )isHidden withBottomView:(UIView *)bottomView topView:(UIView *)topView lockBtn:(UIButton *)lockBtn isLock:(BOOL)isLock;
///播放状态
//播放失败的代理方法
-(void)wmplayerFailedPlay:(AliWMPlayerView *)wmplayer WMPlayerStatus:(CustomWMPlayerState)state;
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(AliWMPlayerView *)wmplayer WMPlayerStatus:(CustomWMPlayerState)state;
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(AliWMPlayerView *)wmplayer;

// 分享按钮的点击事件
- (void)videoPlayerDoShare;

@end

@interface AliWMPlayerView: UIView
/**
 *  播放器player
 */
// @property (nonatomic,retain ) AVPlayer       *player;

@property (nonatomic, strong) AliyunVodPlayer *vodPlayer;

@property (nonatomic, strong) UIView *playerView;
/**
 *  wmPlayer内部一个UIView，所有的控件统一管理在此view中
 */
@property (nonatomic, strong) UIView *vodContentView;

/** 播放器的代理 */
@property (nonatomic, weak)id <AliWMPlayerDelegate> delegate;

// 用来作用于进度条的定时器
@property (nonatomic, strong) NSTimer *timer;

/**
 *  是否使用手势控制音量
 */
@property (nonatomic,assign) BOOL  enableVolumeGesture;
/**
 *  /给显示亮度的view添加毛玻璃效果
 */
@property (nonatomic, strong) UIVisualEffectView * effectView;
//这个用来显示滑动屏幕时的时间
@property (nonatomic,strong) FastForwardView * FF_View;
/**
 *  底部操作工具栏
 */
@property (nonatomic,retain ) UIImageView         *bottomView;
/**
 *  顶部操作工具栏
 */
@property (nonatomic,retain ) UIImageView         *topView;

// 用来判断当前视频是否是播放失败
@property (nonatomic, assign) BOOL isVideoPlayFail;
/**
 *  控制全屏的按钮
 */
@property (nonatomic,retain ) UIButton       *fullScreenBtn;
/**
 *  左上角关闭按钮
 */
@property (nonatomic,retain ) UIButton       *closeBtn;
// 分享按钮
@property (nonatomic, strong) UIButton *shareBtn;
/**
 *  显示播放视频的title
 */
@property (nonatomic,strong) UILabel        *titleLabel;
/**
 *  播放暂停按钮
 */
@property (nonatomic,retain ) UIButton       *playOrPauseBtn;
/**
 *  定时器
 */
@property (nonatomic, retain) NSTimer        *autoDismissTimer;
// 全屏时 屏幕锁
@property (nonatomic, strong) UIButton *lockBtn;

/**
 *  BOOL值判断当前的状态
 */
@property (nonatomic,assign ) BOOL            isFullscreen;



// ==============================================

/**
 *playerLayer,可以修改frame
 */
//@property (nonatomic,retain ) AVPlayerLayer  *playerLayer;


/**
 在预告短片中需判断此字段 保证视频在播放完成的情况下 下次进入继续播放
 */
@property (nonatomic, assign) BOOL isPreviewPlayAgain;

/**
 ＊  播放器状态
 */
@property (nonatomic, assign) CustomWMPlayerState   state;
/**
 ＊  播放器左上角按钮的类型
 */
//@property (nonatomic, assign) CustomCloseBtnStyle   closeBtnStyle;


/**
 *  显示加载失败的UILabel
 */

@property (nonatomic,strong) UILabel        *loadFailedLabel;


/**
 *  wmPlayer内部一个UIView，所有的控件统一管理在此view中
 */
//@property (nonatomic,strong) UIView        *contentView;
/**
 *  当前播放的item
 */
//@property (nonatomic, retain) AVPlayerItem   *currentItem;
/**
 *  菊花（加载框）
 */
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;

/**
 *  设置播放视频的USRLString，可以是本地的路径也可以是http的网络路径
 */
@property (nonatomic,copy) NSString       *URLString;

/**
 *  跳到time处播放
 * seekTime 这个时刻，这个时间点
 */
@property (nonatomic, assign) double  seekTime;

/** 播放前占位图片，不设置就显示默认占位图（需要在设置视频URL之前设置） */
@property (nonatomic, copy  ) UIImage              *placeholderImage ;

///---------------------------------------------------
// 跳转到指定的时间(自己开的方法)
- (void)seekToTimeToPlay:(double)time;

/**
 *  播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 *  获取正在播放的时间点
 *
 *  @return double的一个时间点
 */
- (double)currentTime;

-(void)destroyPlayer;

/**
 * 重置播放器
 */
//- (void )resetWMPlayer;
//获取当前的旋转状态
+(CGAffineTransform)getCurrentDeviceOrientation;

@end
