//
//  WARActivationExploration.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <Foundation/Foundation.h>

#import "WARMomentTraceInfo.h"
#import "WARDBContactModel.h"

@interface WARActivationExploration : NSObject
/** accountId */
@property (nonatomic, copy) NSString *accountId;
/** time */
@property (nonatomic, copy) NSString *time;
/** traceInfo */
@property (nonatomic, strong) WARMomentTraceInfo *traceInfo;

/** 辅助字段 */
/** formatTime */
@property (nonatomic, copy) NSString *formatTime;
/** 根据accountId 从数据库查询到的联系人 */
@property (nonatomic, strong) WARDBContactModel *friendModel;
@end
