//
//  WARFeedLayout.h
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import "WARFeedHeader.h"
#import "WARFeedModelProtocol.h"
#import "WARSimpleSceneryLayout.h"
#import "WARFeedScenery.h"
#import "WARSimpleStoreOrHotelLayout.h"
#import "WARFeedStoreLayout.h"
#import "WARFeedSceneryLayout.h"
#import "WARFeedAlbumLayout.h"
#import "WARFeedGameLayout.h"
#import "WARFeedLinkLayout.h"

@class WARFeedComponentLayout;
@interface WARFeedPageLayout : NSObject

/**
 根据数据page 生成布局

 @param page
 */
- (void)configComponentLayoutsWithPage:(WARFeedPageModel *)page
                          contentScale:(CGFloat)contentScale
                            momentShowType:(WARMomentShowType)momentShowType
                          isMultilPage:(BOOL)isMultilPage;

/** 组件的数据对象 */
@property (nonatomic, strong) WARFeedPageModel *page;

/** 多个组件 */
@property (nonatomic, strong) NSMutableArray <WARFeedComponentLayout *> *componentLayoutArr;

/** 辅助字段 */
/** 是多页 */
@property (nonatomic, assign) BOOL isMultilPage;
/** 朋友圈相对缩放比 */
@property (nonatomic, assign) BOOL contentScale;
/** momnt类型 */
@property (nonatomic, assign) WARMomentShowType momentShowType;
/** 单页内容真实高度 */
@property (nonatomic, assign) CGFloat singlePageContentHeight;
@property (nonatomic, assign) CGFloat diaryContentHeight;
@property (nonatomic, assign) CGFloat friendContentHeight;
@end

@class WARFeedComponentLinkLayout,WARSimpleSceneryLayout;
@interface WARFeedComponentLayout : NSObject

/** 组件的数据对象 */
@property (nonatomic, strong) WARFeedComponentModel *component;

@property (nonatomic, strong, readonly) NSAttributedString *attrText; 
/** 文本布局 */
@property (nonatomic, strong) YYTextLayout *textLayout;
/** 摘要链接 layout */
@property (nonatomic, strong) WARFeedLinkLayout *linkLayout;
/** 景点简版 layout */
@property (nonatomic, strong) WARSimpleSceneryLayout *simpleSceneryLayout;
/** 商铺简版 layout */
@property (nonatomic, strong) WARSimpleStoreOrHotelLayout *simpleStoreLayout;
/** 酒店简版 layout */
@property (nonatomic, strong) WARSimpleStoreOrHotelLayout *simpleHotelLayout;
/** 商铺 layout */
@property (nonatomic, strong) WARFeedStoreLayout *storeLayout;
/** 酒店 layout */
@property (nonatomic, strong) WARFeedStoreLayout *hotelLayout;
/** 景点 layout */
@property (nonatomic, strong) WARFeedSceneryLayout *sceneryLayout;
/** 相册 layout */
@property (nonatomic, strong) WARFeedAlbumLayout *albumLayout;
/** 收藏 layout */
@property (nonatomic, strong) WARFeedAlbumLayout *favourLayout;
/** 游戏排行 layout */
@property (nonatomic, strong) WARFeedGameLayout *gameLayout;

/** 辅助字段 */
/** 是多页 */
@property (nonatomic, assign) BOOL isMultilPage;
/** 内容缩放比 */
@property (nonatomic, assign) CGFloat contentScale;
/** moment展现在什么模块 */
@property (nonatomic, assign) WARMomentShowType momentShowType;
/** 组件高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 日志单页组件高度 */
@property (nonatomic, assign, readonly) CGFloat diaryCellHeight;
/** 朋友圈单页组件高度 */
@property (nonatomic, assign, readonly) CGFloat friendCellHeight;

@end

 
