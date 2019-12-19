//
//  HFVideoView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFVideoView.h"
#import "HFVideoDYCell.h"
#import "HFPlayVideoManger.h"
#import "HFNotiFication.h"
#import "ZFPlayerControl.h"
#import "ZFTableData.h"
@interface HFVideoView()<UITableViewDelegate,UITableViewDataSource,ZFPlayerMediaPlayback>
// 创建一个 进度条view 包含商品
// 创建一个 播放器View状态View
/// The video contrainerView in normal model.
@property (nonatomic, strong) UIView *containerView;

/// The currentPlayerManager must conform `ZFPlayerMediaPlayback` protocol.
@property (nonatomic, strong) HFPlayVideoManger *currentPlayerManager;

/// The custom controlView must conform `ZFPlayerMediaControl` protocol.
//@property (nonatomic, strong) UIView<ZFPlayerMediaControl> *controlView;

@property (nonatomic, nullable) NSIndexPath *playingIndexPath;

@property (nonatomic, nullable) NSIndexPath *zf_playingIndexPath;

@property (nonatomic, assign) NSInteger zf_containerViewTag;

@property (nonatomic, assign) NSInteger zf_playerApperaPercent;

@property (nonatomic,assign) NSInteger currentPlayIndex;

@property (nonatomic, strong) HFNotiFication *notification;



@property (nonatomic, strong)UIView *effectView;

@property (nonatomic, assign) BOOL zf_stopPlay;

@property (nonatomic, assign) CGFloat zf_lastOffsetY;

@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) NSMutableArray <ZFTableData *>*dataSourceD;

/// WWANA networks play automatically,default NO.
@property (nonatomic, getter=zf_isWWANAutoPlay) BOOL zf_WWANAutoPlay;

@end
@implementation HFVideoView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.pagingEnabled = YES;
        [self requestData];
        HFPlayVideoManger *playerManger = [[HFPlayVideoManger alloc] init];
        self.currentPlayerManager = playerManger;
        self.pauseWhenAppResignActive = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.zf_containerViewTag = 100;

    }
    return self;
}
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheIndexPath:indexPath];
    [self.playeControl resetControlView];
    // 数据
    ZFTableData *data = self.dataSourceD[indexPath.row];
    UIViewContentMode imageMode;
    if (data.thumbnail_width >= data.thumbnail_height) {
         imageMode = UIViewContentModeScaleAspectFit;
     } else {
         imageMode = UIViewContentModeScaleAspectFill;
     }
     self.playingIndexPath = indexPath;
    [self.playeControl showCoverViewWithUrl:@"" withImageMode:imageMode];
    
}
- (void)layoutPlayerSubViews {
//    if (self.containerView && self.currentPlayerManager.view) {
        UIView *superview = self.containerView;
        [superview addSubview:self.currentPlayerManager.view];
        [self.currentPlayerManager.view addSubview:self.playeControl];

        self.currentPlayerManager.view.frame = superview.bounds;
        self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.playeControl.frame = self.currentPlayerManager.view.bounds;
        self.playeControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    }
}

- (void)setPlayingIndexPath:(NSIndexPath *)playingIndexPath {
    _playingIndexPath = playingIndexPath;
     if (playingIndexPath) {
         [self stop];
         UITableView *tableView = (UITableView *)self;
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:playingIndexPath];
         self.containerView = [cell viewWithTag:self.zf_containerViewTag];
         [self layoutPlayerSubViews];
     }else {
         self.zf_playingIndexPath = playingIndexPath;
     }
}
- (void)setCurrentPlayerManager:(HFPlayVideoManger*)currentPlayerManager {
     if (!currentPlayerManager) return;
      _currentPlayerManager  = currentPlayerManager;
   if (_currentPlayerManager .isPreparedToPlay) {
       [_currentPlayerManager stop];
       [_currentPlayerManager.view removeFromSuperview];
    }
     _currentPlayerManager.view.hidden  = YES;
     [self playerManagerCallbcak];
     self.playeControl.videManager = _currentPlayerManager;
     [self.playeControl truncent];
     [self layoutPlayerSubViews];
    
}
- (void)requestData {
    self.urls = @[].mutableCopy;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Videodata" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSourceD = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        ZFTableData *data = [[ZFTableData alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        [self.dataSourceD addObject:data];
        NSURL *url = [NSURL URLWithString:data.video_url];
        [self.urls addObject:url];
    }
}
- (void)stop {
    [self.notification removeNotification];
    [self.currentPlayerManager stop];
    [self.currentPlayerManager.view removeFromSuperview];
    if (self) {
        self.zf_stopPlay = YES;
    }
}
- (void)playerManagerCallbcak {
    @weakify(self)
    self.currentPlayerManager.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
        self.currentPlayerManager.view.hidden = NO;
        [self.notification addNotification];
        if (self) {
            self.zf_stopPlay = NO;
        }
        [self layoutPlayerSubViews];
        [self.playeControl hideControlViewWithAnimated:NO];
    };
    
    self.currentPlayerManager.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
//        if (self.playerReadyToPlay) self.playerReadyToPlay(asset,assetURL);
        if (!self.customAudioSession) {
            // Apps using this category don't mute when the phone's mute button is turned on, but play sound when the phone is silent
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
    };
//
    self.currentPlayerManager.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
    

        [self.playeControl videoPlayer:self.currentPlayerManager currentTime:currentTime totalTime:duration];

    };
//
    self.currentPlayerManager.playerBufferTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
        @strongify(self)
        [self.playeControl videoPlayer:self.currentPlayerManager bufferTime:bufferTime];
    };
//
    self.currentPlayerManager.playerPlayStateChanged = ^(id  _Nonnull asset, ZFPlayerPlaybackState playState) {
        @strongify(self)
        [self.playeControl videoPlayer:self.currentPlayerManager playStateChanged:playState];
    };
//
    self.currentPlayerManager.playerLoadStateChanged = ^(id  _Nonnull asset, ZFPlayerLoadState loadState) {
        @strongify(self)
        [self.playeControl videoPlayer:self.currentPlayerManager loadStateChanged:loadState];
    };
//
    self.currentPlayerManager.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.currentPlayerManager replay];
       
    };
//
    self.currentPlayerManager.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self)
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 @weakify(self)
  [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
          @strongify(self)
  //        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
          [self playTheVideoAtIndexPath:indexPath];
  }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFVideoDYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"video"];
    if (!cell) {
        cell = [[HFVideoDYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"video"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight;
}
- (void)playTheIndexPath:(NSIndexPath *)indexPath {
    // 播放
     NSURL *assetURL;
    /*
     加入数据
     */
    if (self.urls.count) {
        assetURL = self.urls[indexPath.row];
        self.currentPlayIndex = indexPath.row;
    }
    self.currentPlayIndex = indexPath.row;
    self.currentPlayerManager.assetURL = assetURL;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self _scrollViewScrollingDirectionVertical];
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.zf_scrollViewDidStopScrollCallback) {
           self.zf_scrollViewDidStopScrollCallback(indexPath);
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !self.tracking && !self.dragging && !self.decelerating;
    if (scrollToScrollStop) {
        @weakify(self)
        [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (self.zf_scrollViewDidStopScrollCallback) {
               self.zf_scrollViewDidStopScrollCallback(indexPath);
            }
        }];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate  {
    if (!decelerate) {
        BOOL dragToDragStop = self.tracking && !self.dragging && !self.decelerating;
        if (dragToDragStop) {
            @weakify(self)
            [self zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
                @strongify(self)
                if (self.zf_scrollViewDidStopScrollCallback) {
                   self.zf_scrollViewDidStopScrollCallback(indexPath);
                }
            }];
        }
    }
}
- (void)_scrollViewScrollingDirectionVertical {
    CGFloat offsetY = self.contentOffset.y;
    self.zf_scrollDirection = (offsetY - self.zf_lastOffsetY > 0) ? ZFPlayerScrollDirectionUp : ZFPlayerScrollDirectionDown;
    self.zf_lastOffsetY = offsetY;
    if (self.zf_stopPlay) return;
     UIView *playerView;
    if (self.contentOffset.y < 0) return;
    if (!self.zf_playingIndexPath) return;
    UIView *cell = [self zf_getCellForIndexPath:self.zf_playingIndexPath];
    if (!cell) {
        if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        return;
    }
     playerView = [cell viewWithTag:self.zf_containerViewTag];
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView top to scrollView top space.
    CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
    /// playerView bottom to scrollView bottom space.
    CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame);
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    if (self.zf_scrollDirection == ZFPlayerScrollDirectionUp) {
        if (topSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -topSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (topSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (topSpacing > 0 && topSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(topSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (topSpacing <= contentInsetHeight && topSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
    }else if (self.zf_scrollDirection == ZFPlayerScrollDirectionDown) {
        if (bottomSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -bottomSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.zf_playerDisappearingInScrollView) self.zf_playerDisappearingInScrollView(self.zf_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.zf_playerWillDisappearInScrollView) self.zf_playerWillDisappearInScrollView(self.zf_playingIndexPath);
        } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.zf_playerDidDisappearInScrollView) self.zf_playerDidDisappearInScrollView(self.zf_playingIndexPath);
        } else if (bottomSpacing > 0 && bottomSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(bottomSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.zf_playerAppearingInScrollView) self.zf_playerAppearingInScrollView(self.zf_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (bottomSpacing <= contentInsetHeight && bottomSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.zf_playerWillAppearInScrollView) self.zf_playerWillAppearInScrollView(self.zf_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.zf_playerDidAppearInScrollView) self.zf_playerDidAppearInScrollView(self.zf_playingIndexPath);
            }
        }
    }
    
    
}
- (UIView *)zf_getCellForIndexPath:(NSIndexPath *)indexPath{
    UITableView *tableView = (UITableView *)self;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
     CGFloat offsetY = self.contentOffset.y;
    self.zf_lastOffsetY = offsetY;
}
- (void)zf_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler  {
    [self _findCorrectCellWhenScrollViewDirectionVertical:handler];
}
- (void)zf_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    @weakify(self)
    [self zf_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        @strongify(self)
        if (handler) handler(indexPath);

    }];
}
- (void)_findCorrectCellWhenScrollViewDirectionVertical:(void (^ __nullable)(NSIndexPath *indexPath))handler  {
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    
    UITableView *tableView = self;
    visiableCells = [tableView visibleCells];
    indexPath = tableView.indexPathsForVisibleRows.firstObject;
    if (self.contentOffset.y <= 0 &&(!self.playingIndexPath ||  [indexPath compare:self.playingIndexPath] == NSOrderedSame)) {
        HFVideoDYCell *cell = [self cellForRowAtIndexPath:indexPath];
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        for (UIView *sub in cell.contentView.subviews) {
            NSLog(@"%ld",sub.tag);
        }
        if (playerView) {
            if (handler) handler(indexPath);
            return;
        }
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.playingIndexPath || [indexPath compare:self.playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                return;
            }
        }
    }
    NSArray *cells = visiableCells;
    
    CGFloat scrollViewMidY = CGRectGetHeight(self.frame)/2;
    
    __block NSIndexPath *finalIndexPath = nil;
    
    __block CGFloat finalSpace = 0;
     @weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIView *playerView = [cell viewWithTag:self.zf_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        /// playerView top to scrollView top space.
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
        /// playerView bottom to scrollView bottom space.
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];

        
        /// Play when the video playback section is visible.
        if ((topSpacing >= -(1 - self.zf_playerApperaPercent) * CGRectGetHeight(rect)) && (bottomSpacing >= -(1 - self.zf_playerApperaPercent) * CGRectGetHeight(rect))) {
            /// If you have a cell that is playing, stop the traversal.
            if (self.playingIndexPath) {
                indexPath = self.playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
        
    }];
    
}

- (HFNotiFication *)notification {
    if (!_notification) {
        _notification = [[HFNotiFication alloc] init];
        @weakify(self)
        _notification.willResignActive = ^(HFNotiFication * _Nonnull registrar) {
            @strongify(self)
            if (self.isViewControllerDisappear) return;
            if (self.pauseWhenAppResignActive && self.currentPlayerManager.isPlaying) {
                self.pauseByEvent = YES;
            }
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            if (!self.pauseWhenAppResignActive) {
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                [[AVAudioSession sharedInstance] setActive:YES error:nil];
            }
        };
        _notification.didBecomeActive = ^(HFNotiFication * _Nonnull registrar) {
            @strongify(self)
            if (self.isViewControllerDisappear) return;
            if (self.isPauseByEvent) self.pauseByEvent = NO;
        };
        _notification.oldDeviceUnavailable = ^(HFNotiFication * _Nonnull registrar) {
            @strongify(self)
            if (self.currentPlayerManager.isPlaying) {
                [self.currentPlayerManager play];
            }
        };
    }
    return _notification;
}


@end
