//
//  WARFeedEnum.h
//  Pods
//
//  Created by 卧岚科技 on 2018/6/19.
//

#define WARIntegrity_M_SIMPLE       @"SIMPLE" //简略版
#define WARIntegrity_M_COMPLETE     @"COMPLETE" //完整版

typedef NS_ENUM(NSUInteger, WARFeedComponentIntegrityType) {
    WARFeedComponentIntegrityTypeComplete,
    WARFeedComponentIntegrityTypeSimple
};


typedef NS_ENUM(NSUInteger, WARFeedLinkSummaryType) {
    WARFeedLinkSummaryTypeText = 1,//纯文本
    WARFeedLinkSummaryTypeVideo,//视频
    WARFeedLinkSummaryTypeSingleImg,//单图
    WARFeedLinkSummaryTyperipleImg,//三图
};


//TEXT、MEDIA、LINK、HOTEL、STORE、SCENERY、ALBUM、COLLECTION
#define FEED_TEXT_COMPONENT          @"TEXT" //纯文本
#define FEED_MEDIA_COMPONENT         @"MEDIA" //多媒体
#define FEED_LINK_COMPONENT          @"LINK" //链接
#define FEED_HOTEL_COMPONENT         @"HOTEL" //酒店
#define FEED_STORE_COMPONENT         @"STORE" //门店
#define FEED_SCENERY_COMPONENT       @"SCENERY" //景点
#define FEED_ALBUM_COMPONENT         @"ALBUM" //相册
#define FEED_FAVOUR_COMPONENT        @"FAVORITE" //收藏
#define FEED_FAVOUR_GAME             @"GAME" //游戏

typedef NS_ENUM(NSUInteger, WARFeedComponentType) {
    WARFeedComponentTextType = 8000,
    WARFeedComponentMediaType,
    WARFeedComponentLinkType,
    WARFeedComponentHotelType,
    WARFeedComponentStoryType,
    WARFeedComponentSceneryType,
    WARFeedComponentAlbumType,
    WARFeedComponentFavourType,
    WARFeedComponentGameType
};


#define Feed_Link_Component_Default @"default"
#define Feed_Link_Component_Read @"read"
#define Feed_Link_Component_Summary @"summary"
#define Feed_Link_Component_WeiBo @"weibo"

typedef NS_ENUM(NSUInteger, WARFeedLinkComponentType) {
    WARFeedLinkComponentTypeDefault,
    WARFeedLinkComponentTypeRead,
    WARFeedLinkComponentTypeSummary,
    WARFeedLinkComponentTypeWeiBo,
};

