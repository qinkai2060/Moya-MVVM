//
//  WARIronBody.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARFeedModel.h"

@interface WARIronBody : NSObject

/** componentPageCount */
@property (nonatomic, assign) NSInteger componentPageCount;
/** 分页内容 */
@property (nonatomic, copy) NSArray <WARFeedPageModel *> *pageContents;

@end
