//
//  WARFeedMagicImageView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/16.
//

#import "WARFeedMagicImageView.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"

@interface WARFeedMagicImageView()
/** playImageLayers */
@property (nonatomic, strong) NSMutableArray <CALayer *>*playImageLayers;
@end

@implementation WARFeedMagicImageView
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    for (int i = 0; i < 9; i++) {
        CALayer *playImageLayer = [[CALayer alloc]init];
        playImageLayer.contents = (__bridge id)([UIImage war_imageName:@"release_home_vide_play" curClass:[self class] curBundle:@"WARProfile.bundle"].CGImage);
        playImageLayer.contentsGravity = kCAGravityResize;
        playImageLayer.hidden = YES;
        [self.layer addSublayer:playImageLayer];
        [self.playImageLayers addObject:playImageLayer];
    }
} 

- (void)setImages:(NSArray<WARFeedImageComponent *> *)images {
    _images = images;

    [self.playImageLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    [images enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer *playLayer = self.playImageLayers[idx];
        
        CGRect playLayerFrame = CGRectMake(obj.frameRect.origin.x * self.contentScale + (obj.frameRect.size.width * self.contentScale - 35) * 0.5, obj.frameRect.origin.y * self.contentScale + (obj.frameRect.size.height * self.contentScale - 35) * 0.5, 35, 35);
        playLayer.frame = playLayerFrame;
        playLayer.hidden = !(obj.videoUrl);
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL didInImageView = NO;
     
    CGPoint convertPoint = CGPointMake(point.x / self.contentScale, point.y / self.contentScale);
    for (WARFeedImageComponent *imageComponent in self.images) {
        if (CGRectContainsPoint(imageComponent.frameRect, convertPoint)) {
            
            self.didImageComponent = imageComponent;
            didInImageView = YES;
            break;
        } 
    }
    
    return didInImageView;
}

- (NSMutableArray <CALayer *>*)playImageLayers {
    if (!_playImageLayers) {
        _playImageLayers = [NSMutableArray<CALayer *> array];
    }
    return _playImageLayers;
}

@end
