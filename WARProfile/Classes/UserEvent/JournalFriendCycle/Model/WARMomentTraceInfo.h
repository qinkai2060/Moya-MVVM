//
//  WARMomentTraceInfo.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

/**
 足迹信息类型
 
 - WARMomentTrackTypeActivation: 我的足迹-激活探索
 - WARMomentTrackTypeMine: 我的足迹-自己探索
 - WARMomentTrackTypeOther: 他人足迹
 */
typedef NS_ENUM(NSUInteger, WARMomentTrackType) {
    WARMomentTrackTypeActivation = 1,
    WARMomentTrackTypeMine,
    WARMomentTrackTypeOther
};

#import <Foundation/Foundation.h>

@interface WARMomentTraceInfo : NSObject
/** lat */
@property (nonatomic, copy) NSString *lat;
/** lon */
@property (nonatomic, copy) NSString *lon;
/** locInfo */
@property (nonatomic, copy) NSString *locInfo;
/** location */
@property (nonatomic, copy) NSString *location;

/** 辅助字段 */
/** trackType */
@property (nonatomic, assign) WARMomentTrackType trackType;
@end
