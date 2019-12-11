//
//  WARFeedStoreComponent.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import <Foundation/Foundation.h>
#import "WARFeedEnum.h"

@interface WARFeedStore : NSObject
/** COMPLETE、SIMPLE（完整版、简略版） */
@property (nonatomic, copy) NSString *edition;
/** 餐饮类型（如西餐） */
@property (nonatomic, copy) NSString *foodType;
/** 图片数量 */
@property (nonatomic, assign) NSInteger imageCount;
/** images */
@property (nonatomic, strong) NSArray<NSString *> *images;
/** location */
@property (nonatomic, copy) NSString *location;
/** 主图id */
@property (nonatomic, copy) NSString *mainImageId;
/** price */
@property (nonatomic, copy) NSString *price;
/** 评分 */
@property (nonatomic, assign) CGFloat score;
/** title */
@property (nonatomic, copy) NSString *title;
/** url */
@property (nonatomic, copy) NSString *url;

/** 辅助字段 */
/** COMPLETE、SIMPLE（完整版、简略版） */
@property (nonatomic, assign) WARFeedComponentIntegrityType editionEnum;
@end
