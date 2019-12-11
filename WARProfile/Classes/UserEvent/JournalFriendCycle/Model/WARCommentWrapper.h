//
//  WARCommentWrapper.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARFriendCommentModel.h"
#import "WARThumbModel.h"

@interface WARCommentWrapper : NSObject

/** 评论相关 */
@property (nonatomic, strong) WARFriendCommentModel *comment;
/** 评论数 */
@property (nonatomic, assign) NSInteger commentCount;
/** 点赞数 */
@property (nonatomic, assign) NSInteger praiseCount;
/** 点赞相关 */
@property (nonatomic, strong) WARThumbModel *thumb;
/** 是否点过赞 */
@property (nonatomic, assign) BOOL thumbUp;

@end
