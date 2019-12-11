//
//  WARJournalSuspendingBar.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import <UIKit/UIKit.h>
#import "WARMomentEnum.h"

#define kWARJournalSuspendingBarHeight 46.5

/**
 点击朋友圈回调
 */
typedef void(^WARJournalSuspendingBarDidFriendBlock)(void);
/**
 点击我的足迹回调
 */
typedef void(^WARJournalSuspendingBarDidFootprintBlock)(void);
/**
群主动态与通知
 */
typedef void(^WARJournalSuspendingBarDidGroupMomentBlock)(void);

@interface WARJournalSuspendingBar : UIView

- (instancetype)initWithFrame:(CGRect)frame herderType:(WARJournalTableHeaderType)herderType;

- (void)configFriendBadge:(NSInteger)friendBadge ;
- (void)configFootprintBadge:(NSInteger)footprintBadge;
- (void)configGroupMomentBadge:(NSInteger)groupMomentBadge;

/** 朋友圈 */
@property (nonatomic, copy) WARJournalSuspendingBarDidFriendBlock didFriendBlock;
/** 我的足迹 */
@property (nonatomic, copy) WARJournalSuspendingBarDidFootprintBlock didFootprintBlock;
/** 群主动态与通知 */
@property (nonatomic, copy) WARJournalSuspendingBarDidGroupMomentBlock didGroupMomentBlock;

@end
