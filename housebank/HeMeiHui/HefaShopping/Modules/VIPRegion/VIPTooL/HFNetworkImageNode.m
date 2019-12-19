//
//  HFNetworkImageNode.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFNetworkImageNode.h"
#import "HFWebImageManager.h"
#import <PINRemoteImage/PINRemoteImage.h>

@interface HFNetworkImageNode ()<ASNetworkImageNodeDelegate>

/**
 网络图片
 */
@property (nonatomic, strong) ASNetworkImageNode *netImgNode;
/**
 本地图片
 */
@property (nonatomic, strong) ASImageNode *imageNode;

@end

@implementation HFNetworkImageNode

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubnode:self.netImgNode];
        [self addSubnode:self.imageNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    return   [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1 child:!self.netImgNode.URL ? self.imageNode : self.netImgNode];
    return    [ASWrapperLayoutSpec wrapperWithLayoutElement:!self.netImgNode.URL ? self.imageNode : self.netImgNode];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:(UIEdgeInsetsZero) child:!self.netImgNode.URL ? self.imageNode : self.netImgNode];
}

- (ASNetworkImageNode *)netImgNode{
    if (!_netImgNode) {
        _netImgNode = [[ASNetworkImageNode alloc] init];
        _netImgNode.delegate = self;
//        _netImgNode.shouldCacheImage = NO;/
        _netImgNode.backgroundColor = [UIColor orangeColor];
        _netImgNode.placeholderColor = [UIColor whiteColor];
        _netImgNode.defaultImage = [UIImage imageNamed:@"SpTypes_default_image"];
        
    }
    return _netImgNode;
}

- (ASImageNode *)imageNode{
    if (!_imageNode) {
        _imageNode = [[ASImageNode alloc] init];
        _imageNode.placeholderColor = [UIColor whiteColor];

    }
    return _imageNode;
}

- (void)setURL:(NSURL *)URL{
    _URL = URL;
    
    if ([[[ASPINRemoteImageDownloader sharedDownloader] sharedPINRemoteImageManager].pinCache containsObjectForKey:[[[ASPINRemoteImageDownloader sharedDownloader] sharedPINRemoteImageManager] cacheKeyForURL:URL processorKey:nil]]) {
        [[[ASPINRemoteImageDownloader sharedDownloader] sharedPINRemoteImageManager] imageFromCacheWithURL:URL processorKey:nil options:PINRemoteImageManagerDownloadOptionsNone completion:^(PINRemoteImageManagerResult * _Nonnull result) {
            self.imageNode.image = result.image;
        }];

    } else {
        self.netImgNode.URL = _URL;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.netImgNode.placeholderColor = placeholderColor;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.netImgNode.image = image;
    self.imageNode.image = image;
    
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.netImgNode.cornerRadius = 10;
    self.imageNode.cornerRadius = 10;

}
- (void)setDefaultImage:(UIImage *)defaultImage{
    _defaultImage = defaultImage;
    self.netImgNode.defaultImage = defaultImage;
    self.imageNode.image = defaultImage;
}

- (void)setJs_placeholderFadeDuration:(NSTimeInterval)js_placeholderFadeDuration{
    _js_placeholderFadeDuration = js_placeholderFadeDuration;
    self.netImgNode.placeholderFadeDuration = js_placeholderFadeDuration;
}

@end

