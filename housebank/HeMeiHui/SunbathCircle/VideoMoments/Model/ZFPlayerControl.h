//
//  ZFPlayerControl.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPlayerControl : UIView<ZFPlayerMediaControl>
@property(nonatomic,assign)BOOL isShowControl;
@property(nonatomic,strong)ZFPlayerController *player;
- (void)resetControlView;
- (void)showCoverViewWithUrl:(NSString *)coverUrl withImageMode:(UIViewContentMode)contentMode;
- (void)truncent;
- (void)hideControlViewWithAnimated:(BOOL)animated;
- (void)showControlViewWithAnimated:(BOOL)animated;
//- (void)videoPlayer:(HFPlayVideoManger *)videoPlayer bufferTime:(NSTimeInterval)bufferTime ;
//- (void)videoPlayer:(HFPlayVideoManger *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
//- (void)videoPlayer:(HFPlayVideoManger *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state;
//- (void)videoPlayer:(HFPlayVideoManger *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state;
@end

NS_ASSUME_NONNULL_END
