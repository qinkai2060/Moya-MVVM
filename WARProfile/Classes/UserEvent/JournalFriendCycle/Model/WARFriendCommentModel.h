//
//  WARFriendCommentModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARFriendComment.h"
#import "WARFriendCommentLayout.h"

@interface WARFriendCommentModel : NSObject

@property (nonatomic, copy) NSArray <WARFriendComment *> *comments;
@property (nonatomic, copy) NSString *refId;

/** 辅助字段 */
/** 日志详情评论列表布局 */
@property (nonatomic, strong) NSArray <WARFriendCommentLayout *> *journalCommentLayoutArray;
@end
