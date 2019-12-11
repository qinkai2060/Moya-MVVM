//
//  WARPlayerFlashView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/7.
//

#import "WARPlayerFlashView.h"
#import "WARPlayerLayerView.h"
#import "WARMacros.h"
#import "WARProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
@interface WARPlayerFlashView()
@property (nonatomic, strong) NSURL *videoURL;
// 当前播放的影像
@property (nonatomic, strong) WARPlayerLayerView *playerLayerView;
// 当前player
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
// 加载指示器
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation WARPlayerFlashView


+ (instancetype)playerWithVideoURL:(NSURL *)videoURL {
    
    return [[WARPlayerFlashView alloc] initWithVideoURL:videoURL];
}
- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _videoURL = videoURL;
    
        [self setupSubViews];
        [self setupPlayer];

    }
    return self;
}
- (void)setupSubViews {
    [self addSubview:self.playerLayerView];
    [self addSubview:self.activityIndicatorView];
}
- (void)setupPlayer {
    
   self.playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];

    [(AVPlayerLayer *)self.playerLayerView.layer setPlayer:self.player];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    
    [self.activityIndicatorView startAnimating];
}
- (void)playerItemDidPlayToEnd{
  
    [self stop];
}

- (void)applicationWillResignActive {
    [self stop];
}
- (void)stop{
//    if (!_player) {
//        return;
//    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player pause];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    self.player = nil;

    self.playerItem = nil;
    [self removeFromSuperview];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
         switch (playerItem.status) {
             case AVPlayerStatusReadyToPlay:   {
           
                 [self.activityIndicatorView stopAnimating];
                 [self.player play];
             }
                 break;
             case AVPlayerStatusFailed:  {
            
                 [self.activityIndicatorView stopAnimating];
                 [WARProgressHUD showErrorMessage:[NSString stringWithFormat:@"%@",_player.error.description]];
             }
                 break;
             case AVPlayerStatusUnknown:  {
                 
                 [self.activityIndicatorView stopAnimating];
                 [WARProgressHUD showErrorMessage:[NSString stringWithFormat:@"%@",_player.error.description]];
             }
                 break;
         }
    }
}
- (WARPlayerLayerView *)playerLayerView {
    
    if (!_playerLayerView) {
        _playerLayerView = [[WARPlayerLayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    }
    return _playerLayerView;
}
- (UIActivityIndicatorView *)activityIndicatorView {
    
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _activityIndicatorView.center = self.center;
    }
    return _activityIndicatorView;
}
@end
