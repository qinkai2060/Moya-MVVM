//
//  WARFeedVideoView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedVideoView.h"
#import "WARMacros.h"

#import "UIImage+WARBundleImage.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "UIView+Frame.h"

@interface WARFeedVideoView()
/** bigImageView */
@property (nonatomic, strong) UIImageView *bigImageView;
/** play */
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation WARFeedVideoView


#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bigImageView];
    [self addSubview:self.playButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = 58;
    CGFloat h = 58;
    CGFloat x = (self.width - w) * 0.5;
    CGFloat y = (self.height - h) * 0.5;
    self.playButton.frame = CGRectMake(x, y, w, h);
    self.bigImageView.frame = self.bounds;
}

#pragma mark - Event Response

- (void)playAction:(UIButton *)button {
    if (self.didPlayBlock) {
        self.didPlayBlock(self.media.videoId);
    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMedia:(WARFeedMedia *)media {
    _media = media;
    
//    [self.bigImageView sd_setImageWithURL:media.imgId placeholderImage:[WARUIHelper war_defaultUserIcon]];
    [self.bigImageView sd_setImageWithURL:kOriginMediaUrl(media.imgId) placeholderImage:DefaultPlaceholderImageWtihSize(self.bounds.size)];
    [self setNeedsDisplay];
}

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc]init];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bigImageView.layer.masksToBounds = YES;
    }
    return _bigImageView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        UIImage *image = [UIImage war_imageName:@"release_home_vide_play" curClass:[self class] curBundle:@"WARNewsFeed.bundle"];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.adjustsImageWhenHighlighted = NO;
        _playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_playButton setImage:image forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
