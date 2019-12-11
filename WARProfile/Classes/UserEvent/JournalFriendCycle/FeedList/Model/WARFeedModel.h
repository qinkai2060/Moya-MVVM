//
//  WARFeedModel.h
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import <Foundation/Foundation.h>
#import "YYText.h"
#import "WARFeedEnum.h"

#define WARFeedImageComponentMediaPhoto                     @"PHOTO"
#define WARFeedImageComponentMediaVideo                     @"VIDEO"

@interface WARFeedModel : NSObject

@end


/**
 页的数据对象
 */
@class WARFeedComponentModel;
@interface WARFeedPageModel : NSObject
/** 页的索引 */
@property (nonatomic, assign) NSInteger pageIndex;
/** 多个组件 */
@property (nonatomic, strong) NSMutableArray <WARFeedComponentModel*> *components;
/** 内容不满一页时的高度 */
@property (nonatomic, assign) CGFloat height;

/** 辅助字段 */
/** 是否存在不兼容的类型 */
@property (nonatomic, assign) BOOL hasIncompatible;
@end
 
/**
 组件信息
 */
@class WARFeedComponentContent, WARFeedComponentStyle;
@interface WARFeedComponentModel : NSObject
/** 组件Id */
@property (nonatomic, copy) NSString *componentId;
/** 组件，将josn解析为对象 */
@property (nonatomic, strong) WARFeedComponentContent *content;
/** 样式 */
@property (nonatomic, copy) NSString* style;
/** 宽 */
@property (nonatomic, assign) CGFloat width;
/** 高 */
@property (nonatomic, assign) CGFloat height;
/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** 组件类型 */
@property (nonatomic, copy) NSString *type;

/** 辅助字段 */
/** 组件类型(枚举)*/
@property (nonatomic, assign) WARFeedComponentType componentType;
/** 组件样式 */
@property (nonatomic, strong) NSArray <WARFeedComponentStyle *> *componentStyles;
/** 在页内的索引 */
@property (nonatomic, assign) NSInteger indexOfComponent;
/** 所在页的索引 */
@property (nonatomic, assign) NSInteger indexOfPage;
/** 是否存在不兼容的类型 */
@property (nonatomic, assign) BOOL hasIncompatible;
/** 是否为该page的最后一个组件 */
@property (nonatomic, assign) BOOL isLastComponent;
/** 是否为该page的第一个组件 */
@property (nonatomic, assign) BOOL isFirstComponent;
/** 发布容器中组件唯一标识 */
@property (nonatomic, copy) NSString *serialNum;
@end


/**
 组件内容
 */
@class WARFeedLinkComponent, WARFeedComponentStyle, WARFeedImageComponent,WARFeedLinkComponent,WARFeedAlbum ,WARFeedStore ,WARFeedScenery ,WARFeedGame;
@interface WARFeedComponentContent : NSObject

/** 图片 */
@property (nonatomic, strong) NSArray <WARFeedImageComponent *>*images;
/** 拼图 */
@property (nonatomic, strong) WARFeedImageComponent *pintu;
/** pinTuSize */
@property (nonatomic, assign) CGSize pinTuSize;
/** 文本 */
@property (nonatomic, copy) NSString *text;
/** link */
@property (nonatomic, strong) WARFeedLinkComponent *link;
/** 相册 */
@property (nonatomic, strong) WARFeedAlbum *album;
/** 收藏 */
@property (nonatomic, strong) WARFeedAlbum *favour;
/** 景点 */
@property (nonatomic, strong) WARFeedScenery *scenery;
/** 店铺 */
@property (nonatomic, strong) WARFeedStore *store;
/** 酒店 */
@property (nonatomic, strong) WARFeedStore *hotel;
/** 游戏 */
@property (nonatomic, strong) WARFeedGame *game;

@end


@class WARFeedMedia;
@interface WARFeedLinkComponent:NSObject
/** 图片 */
@property (nonatomic, copy) NSString *imgURL;
/** 媒体文件对象数组(目前有3个或1个) */
@property (nonatomic, copy) NSArray <WARFeedMedia *>*medias;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subTitle;
/** 链接url */
@property (nonatomic, copy) NSString *url;
/** 链接类型 defualt，read，summary（摘要） */
@property (nonatomic, copy) NSString *type;

/** 辅助字段 */
/** 链接类型 枚举*/
@property (nonatomic, assign) WARFeedLinkComponentType linkType;
@property (nonatomic, assign) WARFeedLinkSummaryType summaryType;
/** 图片 */
@property (nonatomic, copy) NSString *imgUrl;
@end

/**
 图片组件
 */
@class WARFeedImageComponentRect;
@interface WARFeedImageComponent : NSObject
//{,\"contentOffset\":\"{0, 0}\",\"frame\":\"{{0, 0}, {128, 154.67708333333334}}\",\"zoomScale\":0,\"imgId\":\"MOMENT-5afc0c34963a654a27c4e58f\"}
/** 图片宽 */
@property (nonatomic, copy) NSString* imgW;
/** 图片高 */
@property (nonatomic, copy) NSString* imgH;
/** 图片id（上传成功之后的ID） */
@property (nonatomic, copy) NSString* imgId;
/** 视频id（上传成功之后的ID） */
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSURL* videoUrl;
/** 缩放比 */
@property (nonatomic, assign) CGFloat zoomScale;
/** 偏移量 */
@property (nonatomic, assign) CGPoint contentOffsetPoint;
@property (nonatomic, strong) WARFeedImageComponentRect *contentOffset;
/** 可见尺寸 */
@property (nonatomic, assign) CGSize viewSizeSize;
@property (nonatomic, strong) WARFeedImageComponentRect *viewSize;
/** 位置 */
@property (nonatomic, assign) CGRect frameRect;
@property (nonatomic, assign) CGRect listRect;
@property (nonatomic, strong) WARFeedImageComponentRect *rect;

@property (nonatomic, strong) NSURL* url;

/** 拼图本地路径 */
@property (nonatomic, copy) NSString* pintuPath;
/** pintuImage */
@property (nonatomic, strong) UIImage *pintuImage;
/** 图本地路径 */
@property (nonatomic, copy) NSString* identifier;
/** mediaType （PHOTO/VIDEO）*/
@property (nonatomic, copy) NSString* mediaType;
@end


/**
 x,y,w,h
 */
@interface WARFeedImageComponentRect : NSObject
/** x */
@property (nonatomic, assign) CGFloat x;
/** y */
@property (nonatomic, assign) CGFloat y;
/** w */
@property (nonatomic, assign) CGFloat w;
/** h */
@property (nonatomic, assign) CGFloat h;
@end


/**
 组件样式
 */
@class WARFeedComponentStyleItem;
@interface WARFeedComponentStyle : NSObject
/** 字体 */
@property (nonatomic, copy) NSString *font;
/** 颜色 */
@property (nonatomic, copy) NSString *textColor;
/** 阴影 */
@property (nonatomic, copy) NSString *shadowColor;
/** 粗体 */
@property (nonatomic, getter=isBlod) BOOL blod;
/** 加粗 */
@property (nonatomic, getter=isItalic) BOOL italic;
/** 下划线 */
@property (nonatomic, getter=isUnderline) BOOL underline;
/** 大小 */
@property (nonatomic, assign) NSInteger size;
/** 开始位置 */
@property (nonatomic, assign) NSInteger from;
/** 结束位置 */
@property (nonatomic, assign) NSInteger to;
/** 透明度 */
@property (nonatomic, assign) CGFloat alpha;
/** 行间距 */
@property (nonatomic, assign) CGFloat lineSpacing;

@end


/**
 组件样式描述
 */
@interface WARFeedComponentStyleItem : NSObject
/** 开始位置 */
@property (nonatomic, assign) NSInteger from;
/** 结束位置 */
@property (nonatomic, assign) NSInteger to;
/** 值 */
@property (nonatomic, assign) id value;
@end



/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface FeedTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end







