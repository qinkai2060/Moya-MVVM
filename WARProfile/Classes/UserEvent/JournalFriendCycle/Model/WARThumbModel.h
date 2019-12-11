//
//  WARThumbModel.h
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import <Foundation/Foundation.h>
#import "WARMomentUser.h"
#import "WARJournalThumbLayout.h"
#import "WARFriendDetailThumbLayout.h"

@interface WARThumbModel : NSObject

/** 分页字段 */
@property (nonatomic, copy) NSString *refId;
/** 分页字段 */
@property (nonatomic, copy) NSString *lastId;
/** 点赞人列表 */
@property (nonatomic, copy) NSArray <WARMomentUser *> *thumbUserBos;

/** 辅助字段 */
/** 显示点赞展开收起按钮 */
@property (nonatomic, assign) BOOL showLikeExtend;
/** 日志详情点赞布局 */
@property (nonatomic, strong) WARJournalThumbLayout *journalThumbLayout;
/** 朋友圈详情点赞布局 */
@property (nonatomic, strong) WARFriendDetailThumbLayout *friendDetailThumbLayout;

/** 点赞用户 */
@property (nonatomic, strong) NSAttributedString *thumbUsersAttributedContent;
@property (nonatomic, strong) NSAttributedString *noIconThumbUsersAttributedContent;
/** 限制点赞用户显示数量 */
@property (nonatomic, strong) NSAttributedString *limitThumbUsersAttributedContent;
@property (nonatomic, strong) NSAttributedString *noIconLimitThumbUsersAttributedContent;
@end
