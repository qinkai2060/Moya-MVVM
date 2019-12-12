//
//  WARFeedSceneryComponent.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//


#import <Foundation/Foundation.h>
#import "WARFeedEnum.h"

@interface WARFeedScenery : NSObject
/** 描述文本 */
@property (nonatomic, copy) NSString *subTitle;
/** 图片数量 */
@property (nonatomic, assign) NSInteger imageCount;
/** images */
@property (nonatomic, strong) NSArray<NSString *> *images;
/** 主图id */
@property (nonatomic, copy) NSString *mainImageId;
/** title */
@property (nonatomic, copy) NSString *title;
/** COMPLETE、SIMPLE（完整版、简略版） */
@property (nonatomic, copy) NSString *edition;
/** location */
@property (nonatomic, copy) NSString *location;
/** url */
@property (nonatomic, copy) NSString *url;

/** 辅助字段 */
/** COMPLETE、SIMPLE（完整版、简略版） */
@property (nonatomic, assign) WARFeedComponentIntegrityType editionEnum;
@end
