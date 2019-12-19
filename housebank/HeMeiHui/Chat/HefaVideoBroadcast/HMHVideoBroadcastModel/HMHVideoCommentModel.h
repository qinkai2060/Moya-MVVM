//
//  VideoCommentModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/15.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHVideoCommentModel : NSObject
// 自增Id
@property (nonatomic, strong) NSNumber *id;
//
@property (nonatomic, strong) NSNumber *commentUserId;
//
@property (nonatomic, strong) NSString *commentUserName;
// 父级评论id
@property (nonatomic, strong) NSNumber *pid;
// 视频编号
@property (nonatomic, strong) NSString *vno;
// 评论内容
@property (nonatomic, strong) NSString *content;
// 头像
@property (nonatomic, strong) NSString *commentUserAvatar;
// 评论时间
@property (nonatomic, strong) NSString *commentTime;
// 评论人
@property (nonatomic, strong) NSString *commentUser;
// 点赞数量
@property (nonatomic, strong) NSString *likeCount;
// 是否点赞
@property (nonatomic, assign) BOOL myLike;
//审核状态(0正常、1禁止)
@property (nonatomic, strong) NSString *approvalStatus;
//描述
@property (nonatomic, strong) NSString *description;
// 插入时间
@property (nonatomic, strong) NSString *insertTime;
// 插入者
@property (nonatomic, strong) NSString *insertUser;
// 更新时间
@property (nonatomic, strong) NSString *updateTime;
// 更新者
@property (nonatomic, strong) NSString *updateUser;

// ==============================================
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, strong) NSString *likesNum;

@end
