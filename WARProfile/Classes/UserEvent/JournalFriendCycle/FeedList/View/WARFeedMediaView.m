//
//  WARFeedMediaView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedMediaView.h"

#import "WARMacros.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARFeedVideoView.h"
#import "WARFeedThreeimageContainer.h"

static CGFloat contentPadding = 13;

@interface WARFeedMediaView()

/** videoView */
@property (nonatomic, strong) WARFeedVideoView *videoView;
/** bigImageView */
@property (nonatomic, strong) UIImageView *bigImageView;
/** scrollView */
@property (nonatomic, strong) WARFeedThreeimageContainer *imageContainer;

@end

@implementation WARFeedMediaView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.videoView];
    [self addSubview:self.bigImageView];
    [self addSubview:self.imageContainer];
    
//    CGFloat imageX = contentPadding;
//    CGFloat imageY = 0;
//    CGFloat imageW = 115;
//    CGFloat imageH = 76;
//    for (int i = 0; i < 3; i++) {
//        imageX += (imageW + 2) * i;
//
//        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//        [self.imageContainer addSubview:imageView];
//    }
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Public

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    _layout = layout;
    
    WARFeedLinkComponent *link = layout.component.content.link;
    WARFeedLinkLayout *linkLayout = layout.linkLayout;
    
    switch (link.summaryType) {
        case WARFeedLinkSummaryTypeText:{
            self.videoView.hidden = YES;
            self.bigImageView.hidden = YES;
            self.imageContainer.hidden = YES;
        }
            break;
        case WARFeedLinkSummaryTypeVideo:{
            self.videoView.hidden = NO;
            self.bigImageView.hidden = YES;
            self.imageContainer.hidden = YES;
            if (link.medias.count > 0) {
                WARFeedMedia *media = link.medias.firstObject;
                self.videoView.media = media;
            }
        }
            break;
        case WARFeedLinkSummaryTypeSingleImg:{
            self.videoView.hidden = YES;
            self.bigImageView.hidden = NO;
            self.imageContainer.hidden = YES;
            if (link.medias.count > 0) {
                WARFeedMedia *media = link.medias.firstObject;
//                [self.bigImageView sd_setImageWithURL:media.imgId placeholderImage:[WARUIHelper war_defaultUserIcon]];
                [self.bigImageView sd_setImageWithURL:kOriginMediaUrl(media.imgId) placeholderImage:DefaultPlaceholderImageWtihSize(linkLayout.bigImageViewFrame.size)];
            }
        }
            break;
        case WARFeedLinkSummaryTyperipleImg:{
            self.videoView.hidden = YES;
            self.bigImageView.hidden = YES;
            self.imageContainer.hidden = NO;
            self.imageContainer.medias = link.medias;
        }
            break;
            
        default:
            break;
    }
    
    self.videoView.frame = linkLayout.videoViewFrame;
    self.bigImageView.frame = linkLayout.bigImageViewFrame;
    self.imageContainer.frame = linkLayout.imageContainerFrame;
}

- (WARFeedVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[WARFeedVideoView alloc]init];
    }
    return _videoView;
}

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc]init];
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bigImageView.layer.masksToBounds = YES;
    }
    return _bigImageView;
}

- (WARFeedThreeimageContainer *)imageContainer{
    if (!_imageContainer) {
        _imageContainer = [[WARFeedThreeimageContainer alloc] init];
        //        _imageContainer.scrollEnabled = YES;
        _imageContainer.backgroundColor = HEXCOLOR(0xF3F3F5);;
        //        _imageContainer.showsHorizontalScrollIndicator = NO;
        //        _imageContainer.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //        _imageContainer.exclusiveTouch = YES;
    }
    return _imageContainer;
}

@end
