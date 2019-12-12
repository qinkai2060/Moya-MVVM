//
//  WARMomentTrackInfoLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <Foundation/Foundation.h>
#import "WARMomentTraceInfo.h"

@interface WARMomentTrackInfoLayout : NSObject

/**
 根据足迹信息生成布局

 @param traceInfo 足迹信息
 @return WARMomentTrackInfoView 布局
 */
+ (WARMomentTrackInfoLayout *)layoutWithTraceInfo:(WARMomentTraceInfo *)traceInfo;

/** traceInfo */
@property (nonatomic, strong) WARMomentTraceInfo *traceInfo;
/** mainTitleF */
@property (nonatomic, assign) CGRect mainTitleF;
/** locationF */
@property (nonatomic, assign) CGRect locationF;
/** shareF */
@property (nonatomic, assign) CGRect shareF;
/** activitionF */
@property (nonatomic, assign) CGRect activitionF;
@end
