//
//  WARFeedLayout.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedComponentLayout.h"
 
@implementation WARFeedPageLayout

- (void)setPage:(WARFeedPageModel *)page{
    _page = page;
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:page.components.count];
    for (WARFeedComponentModel* component in page.components) {
    
        NSArray* styles = [WARFeedComponentStyle mj_objectArrayWithKeyValuesArray:component.style];
        component.componentStyles = styles;
        WARFeedComponentLayout* layout = [[WARFeedComponentLayout alloc] init];
        layout.component = component;
        
        _singlePageContentHeight += layout.cellHeight;
        _diaryContentHeight += layout.diaryCellHeight;
        _friendContentHeight += layout.friendCellHeight;
        
        [arr addObject:layout];
    }
    _componentLayoutArr = arr;
}

/**
 根据数据page 生成布局
 
 @param page
 */
- (void)configComponentLayoutsWithPage:(WARFeedPageModel *)page contentScale:(CGFloat)contentScale momentShowType:(WARMomentShowType)momentShowType isMultilPage:(BOOL)isMultilPage{
    _page = page;
    _contentScale = contentScale;
    _momentShowType = momentShowType;
    _isMultilPage = isMultilPage;
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:page.components.count];
    for (WARFeedComponentModel* component in page.components) {
        
        NSArray* styles = [WARFeedComponentStyle mj_objectArrayWithKeyValuesArray:component.style];
        component.componentStyles = styles;
        WARFeedComponentLayout* layout = [[WARFeedComponentLayout alloc] init];
        layout.contentScale = contentScale;//先设置比例，后设置model；后期数据设置youhua用一个方法设置。
        layout.momentShowType = momentShowType;
        layout.isMultilPage = isMultilPage;
        layout.component = component;
        
        _singlePageContentHeight += layout.cellHeight;
        _diaryContentHeight += layout.diaryCellHeight;
        _friendContentHeight += layout.friendCellHeight;
        
        [arr addObject:layout];
    }
    _componentLayoutArr = arr;
}

@end


@implementation WARFeedComponentLayout

- (void)setComponent:(WARFeedComponentModel *)component{
    // 默认设置为1.0
    if (_contentScale <= 0) {
        _contentScale = 1.0;
    }
    
    _component = component;
    
    CGFloat cellHeight = 0;
    CGFloat diaryCellHeight = 0;
    CGFloat friendCellHeight = 0;
    if (!kStringIsEmpty(component.content.text) && (component.componentType == WARFeedComponentTextType)) {
        _textLayout = nil;
        FeedTextLinePositionModifier *modifier = [FeedTextLinePositionModifier new];
        
        switch (_momentShowType) {
            case WARMomentShowTypeUserDiary:
            case WARMomentShowTypeFriendFollow:
            case WARMomentShowTypeFriend:
            case WARMomentShowTypeFriendFollowDetail:
            case WARMomentShowTypeFriendDetail:
            {
                if (_isMultilPage) {
                    NSMutableAttributedString *text = [self richText:component];
                    if (text.length == 0) return;
                
                    modifier.font = [UIFont fontWithName:@"PingFang SC" size:text.yy_font.pointSize];
                    modifier.paddingTop = 0;
                    modifier.paddingBottom = 0;

                    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;//10是lable在cell中的间距
                    CGFloat maxHeight = HUGE;

                    YYTextContainer *container = [YYTextContainer new];
                    container.size = CGSizeMake(maxWidth, maxHeight);
                    container.linePositionModifier = modifier;
                    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
                    if (!_textLayout) return;
                } else {
                    NSMutableAttributedString *text = [self richDiaryText:component];
                    if (text.length == 0) return;

                    modifier.font = [UIFont fontWithName:@"PingFang SC" size:text.yy_font.pointSize];
                    modifier.paddingTop = 0;
                    modifier.paddingBottom = 0;

                    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);//10是lable在cell中的间距
                    CGFloat maxHeight = HUGE;

                    YYTextContainer *container = [YYTextContainer new];
                    container.size = CGSizeMake(maxWidth, maxHeight);
                    container.linePositionModifier = modifier;
                    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
                    if (!_textLayout) return;
                    
                }
            }
                break;
            case WARMomentShowTypeFullText:{
                NSMutableAttributedString *text = [self richText:component];
                if (text.length == 0) return;
                modifier.font = [UIFont fontWithName:@"PingFang SC" size:text.yy_font.pointSize];
                modifier.paddingTop = 0;
                modifier.paddingBottom = 0;
                
                YYTextContainer *container = [YYTextContainer new];
                container.size = CGSizeMake((kScreenWidth - 26), HUGE);
                container.linePositionModifier = modifier;
                
                _textLayout = [YYTextLayout layoutWithContainer:container text:text];
                if (!_textLayout) return;
            }
                break;
            default:{ 
            }
                break;
        }
        
        cellHeight = [modifier heightForLineCount:_textLayout.rowCount] + (component.isLastComponent ? 6 : 10);
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
        
    } else if (component.componentType == WARFeedComponentMediaType) {
        WARFeedImageComponent* imageComponent = component.content.pintu;

        CGFloat imgH = imageComponent.viewSizeSize.height ;
        
        cellHeight = imgH;
        diaryCellHeight = imgH;
        friendCellHeight = imgH;
        
        switch (_momentShowType) {
            case WARMomentShowTypeUserDiary:
            case WARMomentShowTypeFriendFollow:
            case WARMomentShowTypeFriend:
            {
                if (_isMultilPage) {
                    cellHeight *= _contentScale;
                } else {
                    cellHeight *= _contentScale * kImageTextScale;
                }
            }
                break;
            case WARMomentShowTypeFriendDetail:
            case WARMomentShowTypeFriendFollowDetail:{
                cellHeight *= _contentScale * kImageTextScale;
            }
                break;
            case WARMomentShowTypeFullText:{
                
            }
                break;
            default:{
            }
                break;
        }
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
        
    } else if (component.componentType == WARFeedComponentLinkType) {
        WARFeedLinkComponent *linkComponent = component.content.link;
        WARFeedLinkLayout *linkLayout = [WARFeedLinkLayout linkLayout:linkComponent];
        
        _linkLayout = linkLayout;
        
        cellHeight += linkLayout.cellHeight;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if (component.componentType == WARFeedComponentSceneryType) {
        WARFeedScenery *scenery = component.content.scenery;
        switch (scenery.editionEnum) {
            case WARFeedComponentIntegrityTypeSimple:
            { 
                WARSimpleSceneryLayout *simpleSceneryLayout = [WARSimpleSceneryLayout simpleSceneryLayout:scenery];
                _simpleSceneryLayout = simpleSceneryLayout;
                cellHeight = 84 * kLinkContentScale;
            }
                break;
            case WARFeedComponentIntegrityTypeComplete:
            {
                WARFeedSceneryLayout *sceneryLayout = [WARFeedSceneryLayout sceneryLayout:scenery];
                _sceneryLayout = sceneryLayout;
                cellHeight = sceneryLayout.contentHeight;
            }
                break;
        }
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if (component.componentType == WARFeedComponentStoryType) {
        WARFeedStore *store = component.content.store;
        switch (store.editionEnum) {
            case WARFeedComponentIntegrityTypeSimple:
            {
                WARSimpleStoreOrHotelLayout *simpleStoreLayout = [WARSimpleStoreOrHotelLayout simpleStoreLayout:store];
                _simpleStoreLayout = simpleStoreLayout;
                cellHeight = 84 * kLinkContentScale;
            }
                break;
            case WARFeedComponentIntegrityTypeComplete:
            {
                WARFeedStoreLayout *storeLayout = [WARFeedStoreLayout storeLayout:store];
                _storeLayout = storeLayout;
                cellHeight = storeLayout.contentHeight;
            }
                break;
        }
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if (component.componentType == WARFeedComponentHotelType) {
        WARFeedStore *hotel = component.content.hotel;
        switch (hotel.editionEnum) {
            case WARFeedComponentIntegrityTypeSimple:
            {
                WARSimpleStoreOrHotelLayout *simpleHotelLayout = [WARSimpleStoreOrHotelLayout simpleStoreLayout:hotel];
                _simpleHotelLayout = simpleHotelLayout;
                cellHeight = 84 * kLinkContentScale;
            }
                break;
            case WARFeedComponentIntegrityTypeComplete:
            {
                WARFeedStoreLayout *hotelLayout = [WARFeedStoreLayout storeLayout:hotel];
                _hotelLayout = hotelLayout;
                cellHeight = hotelLayout.contentHeight;
            }
                break;
        }
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if(component.componentType == WARFeedComponentAlbumType) {
        WARFeedAlbum *album = component.content.album;
        
        WARFeedAlbumLayout *albumLayout = [WARFeedAlbumLayout albumLayout:album];
        _albumLayout = albumLayout;
        
        cellHeight = albumLayout.contentHeight;
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if(component.componentType == WARFeedComponentFavourType){
        WARFeedAlbum *favour = component.content.favour;
        
        WARFeedAlbumLayout *favourLayout = [WARFeedAlbumLayout albumLayout:favour];
        _favourLayout = favourLayout;
        
        cellHeight = favourLayout.contentHeight;
        
        cellHeight += 10;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    } else if(component.componentType == WARFeedComponentGameType){
        WARFeedGame *game = component.content.game; 
        WARFeedGameLayout *gameLayout = [WARFeedGameLayout gameLayout:game isMultiPage:_isMultilPage];
        _gameLayout = gameLayout;
        
        cellHeight = gameLayout.contentHeight;
        
        cellHeight += 3;
        diaryCellHeight = cellHeight;
        friendCellHeight = cellHeight;
    }
    
    _cellHeight = cellHeight;
    _diaryCellHeight = diaryCellHeight;
    _friendCellHeight = friendCellHeight;
}

/**
 与发布文本保持一致

 @param component component description
 @return return value description
 */
- (NSMutableAttributedString *)richText:(WARFeedComponentModel *)component {
    
    if (!component) return nil;
    NSMutableString *string = component.content.text.mutableCopy;
    if (string.length == 0) return nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (WARFeedComponentStyle* style in component.componentStyles) {
        
        NSRange range = NSMakeRange(style.from, style.to > text.length ? text.length : style.to);
        
        UIColor *color = [UIColor colorWithHexString:style.textColor];
        
        [text yy_setColor:color range:range];
        
        // 阴影
        if (!kStringIsEmpty(style.shadowColor)) {
            NSShadow* shadow = [[NSShadow alloc] init];
            shadow.shadowBlurRadius = 6.0;
            shadow.shadowColor = [UIColor colorWithHexString:style.shadowColor];
            shadow.shadowOffset = CGSizeMake(0, 0);
            [text yy_setShadow:shadow range:range];
        }
        
        // 下划线
        if (style.underline) {
            YYTextDecoration *decoration = [[YYTextDecoration alloc] init];
            decoration.style = style.underline ? YYTextLineStyleSingle : YYTextLineStyleNone;
            decoration.width = @1;
            decoration.color = color;
            [text yy_setTextUnderline:decoration range:range];
        }
        
        // 字体
        CGFloat fontSize = style.size * _contentScale;
        NSString* fontName = [UIFont systemFontOfSize:fontSize].fontName;
        if (!kStringIsEmpty(style.font)) {
            fontName = style.font;
        }else{
            fontName = [UIFont systemFontOfSize:fontSize].fontName;
        }
        fontName = style.blod ? [UIFont boldSystemFontOfSize:fontSize].fontName : fontName;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        if (!font) {
            font = [UIFont systemFontOfSize:fontSize];
        }
        
        // 斜体
        if (style.italic) {
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(6 * (CGFloat)M_PI / 180), 1, 0, 0);
            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:style.font matrix :matrix];
            font = [UIFont fontWithDescriptor:desc size:fontSize];
        }
        
        [text yy_setFont:font range:range];
        
        
        // 行间距
        if (style.lineSpacing) {
            [text yy_setLineSpacing:style.lineSpacing range:range];
        }
        
        [text yy_setLineSpacing:style.lineSpacing range:range];

    }
    
    return text;
}

/**
 日志文本，与发布文本保持一致
 
 @param component component description
 @return return value description
 */
- (NSMutableAttributedString *)richDiaryText:(WARFeedComponentModel *)component {
    
    if (!component) return nil;
    NSMutableString *string = component.content.text.mutableCopy;
    if (string.length == 0) return nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (WARFeedComponentStyle* style in component.componentStyles) {
        
        NSRange range = NSMakeRange(style.from, style.to > text.length ? text.length : style.to);
        
        UIColor *color = [UIColor colorWithHexString:style.textColor];
        
        [text yy_setColor:color range:range];
        
        // 阴影
        if (!kStringIsEmpty(style.shadowColor)) {
            NSShadow* shadow = [[NSShadow alloc] init];
            shadow.shadowBlurRadius = 6.0;
            shadow.shadowColor = [UIColor colorWithHexString:style.shadowColor];
            shadow.shadowOffset = CGSizeMake(0, 0);
            [text yy_setShadow:shadow range:range];
        }
        
        // 下划线
        if (style.underline) {
            YYTextDecoration *decoration = [[YYTextDecoration alloc] init];
            decoration.style = style.underline ? YYTextLineStyleSingle : YYTextLineStyleNone;
            decoration.width = @1;
            decoration.color = color;
            [text yy_setTextUnderline:decoration range:range];
        }
        
        // 字体
        CGFloat fontSize = style.size * _contentScale;
        NSString* fontName = [UIFont systemFontOfSize:fontSize].fontName;
        if (!kStringIsEmpty(style.font)) {
            fontName = style.font;
        }else{
            fontName = [UIFont systemFontOfSize:fontSize].fontName;
        }
        fontName = style.blod ? [UIFont boldSystemFontOfSize:fontSize].fontName : fontName;
        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
        if (!font) {
            font = [UIFont systemFontOfSize:fontSize];
        }
        
        // 斜体
        if (style.italic) {
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(6 * (CGFloat)M_PI / 180), 1, 0, 0);
            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:style.font matrix :matrix];
            font = [UIFont fontWithDescriptor:desc size:fontSize];
        }
        
        [text yy_setFont:font range:range];
        
        
        // 行间距
        if (style.lineSpacing) {
            [text yy_setLineSpacing:style.lineSpacing range:range];
        }
        
        [text yy_setLineSpacing:style.lineSpacing range:range];
        
    }
    
    return text;
}



/**
 朋友圈单页文本，与发布样式无关，根据UI做调整

 @param component component description
 @return return value description
 */
- (NSMutableAttributedString *)richFriendText:(WARFeedComponentModel *)component {
    
    if (!component) return nil;
    NSMutableString *string = component.content.text.mutableCopy;
    if (string.length == 0) return nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    UIColor *color = [UIColor colorWithHexString:@"343C4F"];
    [text yy_setColor:color range:NSMakeRange(0, text.length)];
 
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [text yy_setFont:font range:NSMakeRange(0, text.length)];
    
    return text;
}

@end
 
