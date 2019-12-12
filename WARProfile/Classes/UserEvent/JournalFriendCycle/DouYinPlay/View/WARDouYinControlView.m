//
//  WARDouYinControlView.m
//  WARPlayer_Example
//
//  Created by 任子丰 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "WARDouYinControlView.h"
#import "UIView+WARPlayer.h"
#import "UIImageView+WARCache.h"
#import "WARPlayerTools.h"
#import "WARLoadingView.h"
#import "WARLayoutButton.h"
#import "WARMacros.h"
#import "NSString+Size.h"
#import "WARRecommendVideo.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "UIImage+WARBundleImage.h"

@interface WARDouYinControlView ()

@property (nonatomic, strong) UIImageView *shadowImageView;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) WARLayoutButton *likeBtn;
@property (nonatomic, strong) WARLayoutButton *commentBtn;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;

//@property (nonatomic, strong) UIImage *placeholderImage;
/// 加载loading
@property (nonatomic, strong) WARLoadingView *activity;

@end

@implementation WARDouYinControlView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.coverImageView];
        [self addSubview:self.shadowImageView];
        [self addSubview:self.userImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.likeBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.activity];
        [self addSubview:self.playBtn];
        [self resetControlView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.bounds;
    self.shadowImageView.frame = self.bounds;
    
    self.playBtn.frame = CGRectMake(0, 0, 40, 40);
    self.playBtn.center = self.center;
}

- (void)setVideo:(WARRecommendVideo *)video {
    _video = video;
    
    CGFloat userImageW = 36;
    CGFloat userImageH = 36;
    CGFloat userImageX = 13;
    CGFloat userImageY = kScreenHeight - 13 - userImageH - kSafeAreaBottom;
    self.userImageView.frame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    CGFloat nameLabelW = kScreenWidth * 0.5;
    CGFloat nameLabelH = 16;
    CGFloat nameLabelX = userImageX + userImageW + 12;
    CGFloat nameLabelY = kScreenHeight - 20 - nameLabelH - kSafeAreaBottom;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat commentBtnW = 17;
    NSString *commentString = [[NSString stringWithFormat:@"%ld",video.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.commentCount];
    if (commentString && commentString.length > 0) {
        commentBtnW += [commentString widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] constrainedToHeight:17] + 3;
    }
    CGFloat commentBtnH = 17;
    CGFloat commentBtnX = kScreenWidth - commentBtnW - 13;
    CGFloat commentBtnY = nameLabelY;
    self.commentBtn.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    
    CGFloat likeBtnW = 17;
    NSString *likeString = [[NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount];
    if (likeString && likeString.length > 0) {
        likeBtnW += [likeString widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] constrainedToHeight:17] + 3;
    }
    CGFloat likeBtnH = 17;
    CGFloat likeBtnX = kScreenWidth - commentBtnW - likeBtnW - 25;
    CGFloat likeBtnY = nameLabelY;
    self.likeBtn.frame = CGRectMake(likeBtnX, likeBtnY, likeBtnW, likeBtnH);
    
    CGFloat titleLabelW = kScreenWidth - 26;
    CGFloat tempTitleLabelH = [video.desc heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] constrainedToWidth:titleLabelW];
    CGFloat titleLabelH = tempTitleLabelH  > 48 ? 48 : tempTitleLabelH;
    CGFloat titleLabelX = 13;
    CGFloat titleLabelY = kScreenHeight - 54 - titleLabelH - kSafeAreaBottom;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    NSURL *coverUrl = kVideoCoverUrl(video.url);
    [self.coverImageView sd_setImageWithURL:coverUrl placeholderImage:[WARUIHelper war_defaultUserIcon]]; 
    [self.userImageView sd_setImageWithURL:kOriginMediaUrl(video.account.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    self.nameLabel.text = video.account.friendName;
    self.titleLabel.text = video.desc;
    [self.commentBtn setTitle:commentString forState:UIControlStateNormal];
    [self.likeBtn setTitle:likeString forState:UIControlStateNormal];
}

- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl {
    NSString *imageUrl = kVideoCoverUrl(coverUrl);
    [self.coverImageView setImageWithURLString:imageUrl placeholder:[WARUIHelper war_defaultUserIcon]];
}

- (void)resetControlView {
    self.playBtn.hidden = YES;
    self.titleLabel.text = @"";
    self.nameLabel.text = @"";
    
    [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
    [self.likeBtn setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - Event

- (void)commentAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(controlViewDidComment:video:)]) {
        [self.delegate controlViewDidComment:self video:self.video];
    }
}

- (void)likeAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(controlViewDidPraise:video:)]) {
        [self.delegate controlViewDidPraise:self  video:self.video];
    }
}

#pragma mark - Playback state

- (void)videoPlayer:(WARPlayerController *)videoPlayer loadStateChanged:(WARPlayerLoadState)state {
    if (state == WARPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == WARPlayerLoadStatePlaythroughOK) {
        self.coverImageView.hidden = YES;
    }
    if (state == WARPlayerLoadStateStalled || state == WARPlayerLoadStatePrepare) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
}

- (void)gestureSingleTapped:(WARPlayerGestureControl *)gestureControl {
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
         self.playBtn.hidden = NO;
    } else {
        [self.player.currentPlayerManager play];
        self.playBtn.hidden = YES;
    }
    
//    if (!self.player) return;
//    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
//        [self.player enterFullScreen:YES animated:YES];
//    } else {
//        if (self.controlViewAppeared) {
//            [self.player.currentPlayerManager pause];
//            [self hideControlViewWithAnimated:YES];
//        } else {
//            [self showControlViewWithAnimated:YES];
//            [self.player.currentPlayerManager play];
//        }
//    }
}

- (WARLoadingView *)activity {
    if (!_activity) {
        _activity = [[WARLoadingView alloc] init];
        _activity.lineWidth = 0.8;
        _activity.duration = 1;
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = kCoverImageViewTag;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.userInteractionEnabled = YES;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _nameLabel;
}

- (WARLayoutButton *)likeBtn {
    if (!_likeBtn) {
        UIImage *image = [UIImage war_imageName:@"great_click12" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _likeBtn = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.midSpacing = 3;
        _likeBtn.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _likeBtn.imageSize = CGSizeMake(17, 17);
        [_likeBtn setImage:image forState:UIControlStateNormal];
    }
    return _likeBtn;
}


- (WARLayoutButton *)commentBtn {
    if (!_commentBtn) {
        UIImage *image = [UIImage war_imageName:@"wechat_messag" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _commentBtn = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.midSpacing = 3;
        _commentBtn.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _commentBtn.imageSize = CGSizeMake(17, 17);
        [_commentBtn setImage:image forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        UIImage *image = [UIImage war_imageName:@"release_home_vide_play" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:image forState:UIControlStateNormal];
    }
    return _playBtn;
}


- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        UIImage *image = [UIImage war_imageName:@"yinying" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.image = image;
        _shadowImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _shadowImageView;
}

//- (UIImage *)placeholderImage {
//    if (!_placeholderImage) {
//        _placeholderImage = [WARUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
//    }
//    return _placeholderImage;
//}

@end
