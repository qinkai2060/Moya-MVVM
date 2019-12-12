//
//  WARMacBody.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#define WARMacBody_M_TEXT          @"M_TEXT" //纯文本
#define WARMacBody_M_VIDEO         @"M_VIDEO" //视频
#define WARMacBody_M_SINGLEIMG     @"M_SINGLEIMG" //单图
#define WARMacBody_M_TRIPLEIMG     @"M_TRIPLEIMG" //三图

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WARMacBodyContentType) {
    WARMacBodyContentTypeText = 1,//纯文本
    WARMacBodyContentTypeVideo,//视频
    WARMacBodyContentTypeSingleImg,//单图
    WARMacBodyContentTypeTripleImg,//三图
};

@interface WARMacBody : NSObject

/** json */
@property (nonatomic, copy) NSString *conent;
/** M_TEXT,//纯文本 M_VIDEO,//视频 M_SINGLEIMG, //单图 M_TRIPLEIMG, //三图 */
@property (nonatomic, assign) NSString *contentType;

/** 辅助字段 */
/** contentTypeEnum */
@property (nonatomic, assign) WARMacBodyContentType contentTypeEnum;
@end
