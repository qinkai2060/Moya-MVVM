//
//  WARFeedModel.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedModel.h"
#import "WARFeedHeader.h"
#import "WARFeedMedia.h"
#import "WARFeedGame.h"

#import "WARPublishUploadManager.h"

@implementation WARFeedModel


@end



@implementation WARFeedPageModel

+ (void)load{
    [WARFeedPageModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{ @"components" : [WARFeedComponentModel class]};
    }]; 
}

- (void)mj_keyValuesDidFinishConvertingToObject { 
    [_components enumerateObjectsUsingBlock:^(WARFeedComponentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.isFirstComponent = YES;
        }
        if (idx = _components.count - 1 || _components.count == 1) {
            obj.isLastComponent = YES;
        }
        
        BOOL hasIncompatible = ((obj.componentType < WARFeedComponentTextType) || (obj.componentType > WARFeedComponentGameType));
        obj.hasIncompatible = hasIncompatible;
        if (hasIncompatible) {
            _hasIncompatible = hasIncompatible;
        }
    }];
}

@end



@implementation WARFeedComponentModel


- (instancetype)init {
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, type)] reduce:^id (NSString* type){
            WARFeedComponentType componentType = WARFeedComponentTextType;
            if ([type isEqualToString:FEED_TEXT_COMPONENT]) {
                componentType = WARFeedComponentTextType;
            }else if ([type isEqualToString:FEED_MEDIA_COMPONENT]){
                componentType = WARFeedComponentMediaType;
            }else if ([type isEqualToString:FEED_LINK_COMPONENT]){
                componentType = WARFeedComponentLinkType;
            }else if ([type isEqualToString:FEED_HOTEL_COMPONENT]){
                componentType = WARFeedComponentHotelType;
            }else if ([type isEqualToString:FEED_STORE_COMPONENT]){
                componentType = WARFeedComponentStoryType;
            }else if ([type isEqualToString:FEED_SCENERY_COMPONENT]){
                componentType = WARFeedComponentSceneryType;
            }else if ([type isEqualToString:FEED_ALBUM_COMPONENT]){
                componentType = WARFeedComponentAlbumType;
            }else if ([type isEqualToString:FEED_FAVOUR_COMPONENT]){
                componentType = WARFeedComponentFavourType;
            }else if ([type isEqualToString:FEED_FAVOUR_GAME]){
                componentType = WARFeedComponentGameType;
            }else{
                
            }
            return @(componentType);
        }] subscribeNext:^(NSNumber* componentType) {
            @strongify(self);
            self.componentType = componentType.integerValue;
        }];
 
    }
    return self;
}
 
@end



@implementation WARFeedComponentContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [WARFeedComponentContent mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"images" : [WARFeedImageComponent class]};
        }];
    }
    return self;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
//    [_images enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////        CALayer *playLayer = self.playImageLayers[idx];
////
////        CGRect playLayerFrame = CGRectMake(obj.frameRect.origin.x * self.contentScale + (obj.frameRect.size.width * self.contentScale - 35) * 0.5, obj.frameRect.origin.y * self.contentScale + (obj.frameRect.size.height * self.contentScale - 35) * 0.5, 35, 35);
////        playLayer.frame = playLayerFrame;
////        playLayer.hidden = !(obj.videoUrl);
//    }];
    
    __block CGFloat maxWidth = 0;
    __block CGFloat maxHeight = 0;
    [_images enumerateObjectsUsingBlock:^(WARFeedImageComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxWidth <= (obj.frameRect.origin.x + obj.frameRect.size.width )) {
            maxWidth = (obj.frameRect.origin.x + obj.frameRect.size.width );
        }
        if (maxHeight <= (obj.frameRect.origin.y + obj.frameRect.size.height)) {
            maxHeight = (obj.frameRect.origin.y + obj.frameRect.size.height);
        }
    }];
    
    WARFeedImageComponent *obj = _images.lastObject;
    _pinTuSize = CGSizeMake(maxWidth * kContentScale, maxHeight * kContentScale);
    
    maxWidth = 0;
    maxHeight = 0;
}
 

@end

@implementation WARFeedLinkComponent

- (instancetype)init
{
    self = [super init];
    if (self) { 
        [WARFeedLinkComponent mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"medias" : [WARFeedMedia class]};
        }];
        
        [WARFeedLinkComponent mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"imgUrl":@"imgURL"};
        }];
        
        @weakify(self)
        [[RACSignal combineLatest:@[RACObserve(self, type)] reduce:^id (NSString* type){
            WARFeedLinkComponentType linkType = WARFeedLinkComponentTypeDefault;
            if ([type isEqualToString:Feed_Link_Component_Summary]) {
                linkType = WARFeedLinkComponentTypeSummary;
            }else if ([type isEqualToString:Feed_Link_Component_Read]){
                linkType = WARFeedLinkComponentTypeRead;
            }else if ([type isEqualToString:Feed_Link_Component_Default]){
                linkType = WARFeedLinkComponentTypeDefault;
            }else if ([type isEqualToString:Feed_Link_Component_WeiBo]){
                linkType = WARFeedLinkComponentTypeWeiBo;
            }else{
                
            }
            return @(linkType);
        }] subscribeNext:^(NSNumber* linkType) {
            @strongify(self);
            self.linkType = linkType.integerValue;
        }];
    }
    return self;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    if (_linkType == WARFeedLinkComponentTypeSummary || _linkType == WARFeedLinkComponentTypeWeiBo) {
        if (_medias.count == 0) { // 纯文本
            _summaryType = WARFeedLinkSummaryTypeText;
        } else if (_medias.count == 1) {
            WARFeedMedia *media = _medias[0];
            if (media.videoId) { // 视频
                _summaryType = WARFeedLinkSummaryTypeVideo;
            } else { // 单图
                _summaryType = WARFeedLinkSummaryTypeSingleImg;
            }
        } else { //三图
            _summaryType = WARFeedLinkSummaryTyperipleImg;
        }
    }
}

@end
 

@implementation WARFeedImageComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self)
        [[RACObserve(self, imgId) filter:^BOOL(id value) {
            return value != nil;
        }] subscribeNext:^(NSString *imgId) {
            @strongify(self);
            self.url = kOriginMediaUrl(imgId);
        }];
    }
    return self;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
    _frameRect = CGRectMake(_rect.x, _rect.y, _rect.w, _rect.h);
    _listRect = CGRectMake(_rect.x * kContentScale, _rect.y * kContentScale, _rect.w * kContentScale, _rect.h * kContentScale);
    _contentOffsetPoint = CGPointMake(_contentOffset.x, _contentOffset.y);
    _viewSizeSize = CGSizeMake(_viewSize.x, _viewSize.y);
    
    _videoUrl = kVideoUrl(_videoId);
    
    _imgId = [_imgId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    _pintuImage = [[WARPublishUploadManager shareduploadManager] getSnapImageDataFromDocumentDirectory:_pintuPath];
}

@end


@implementation WARFeedImageComponentRect

@end


@implementation WARFeedComponentStyle

//+ (void)load{
//    
//    [WARFeedComponentStyle mj_setupObjectClassInArray:^NSDictionary *{
//        return @{ @"alpha" : [WARFeedComponentStyleItem class],
//                  @"blod" : [WARFeedComponentStyleItem class],
//                  @"font" : [WARFeedComponentStyleItem class],
//                  @"italic" : [WARFeedComponentStyleItem class],
//                  @"size" : [WARFeedComponentStyleItem class],
//                  @"textColor" : [WARFeedComponentStyleItem class],
//                  @"underline" : [WARFeedComponentStyleItem class],
//                  @"shadowColor" : [WARFeedComponentStyleItem class]
//                  };
//    }];
//    
//}
@end


@implementation WARFeedComponentStyleItem


@end



@implementation FeedTextLinePositionModifier
- (instancetype)init {
    self = [super init];
    
    //    if (kiOS9Later) {
    //        _lineHeightMultiple = 1.34;   // for PingFang SC
    //    } else {
    _lineHeightMultiple = 1.3125; // for Heiti SC
    //    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    FeedTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end








