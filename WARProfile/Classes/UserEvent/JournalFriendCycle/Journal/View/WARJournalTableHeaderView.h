//
//  WARJournalTableHeaderView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <UIKit/UIKit.h>
#import "WARMomentEnum.h"

/**
 点击朋友圈回调
 */
typedef void(^WARJournalTableHeaderViewDidFriendBlock)(void);
/**
 点击我的足迹回调
 */
typedef void(^WARJournalTableHeaderViewDidFootprintBlock)(void);
/**
 点击群主动态
 */
typedef void(^WARJournalTableHeaderViewDidGroupMomentBlock)(void);

@class WARJournalTableHeaderItemView;
@interface WARJournalTableHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame herderType:(WARJournalTableHeaderType)herderType;

+ (CGFloat)herderHeightWithHeaderType:(WARJournalTableHeaderType)herderType;

/** 朋友圈 */
@property (nonatomic, strong) WARJournalTableHeaderItemView *friendItem;
/** 我的足迹 */
@property (nonatomic, strong) WARJournalTableHeaderItemView *footprintItem;
/** 他的足迹 */
@property (nonatomic, strong) WARJournalTableHeaderItemView *otherFootprintItem;
/** 群主动态 */
@property (nonatomic, strong) WARJournalTableHeaderItemView *groupMomentItem;

@property (nonatomic, copy) WARJournalTableHeaderViewDidFriendBlock didFriendBlock;
@property (nonatomic, copy) WARJournalTableHeaderViewDidFootprintBlock didFootprintBlock;
@property (nonatomic, copy) WARJournalTableHeaderViewDidGroupMomentBlock didGroupMomentBlock;

@end
 
/**
 点击item回调
 */
typedef void(^JournalTableHeaderItemDidBlock)(void);

@interface WARJournalTableHeaderItemView : UIView

/**
 配置数据

 @param icon 图标
 @param title 标题
 @param badge badge
 @param userIconId userIconId
 */
- (void)configIcon:(UIImage *)icon
             title:(NSString *)title
             badge:(NSInteger)badge
        userIconId:(NSString *)userIconId;

- (void)configBadge:(NSInteger)badge
        userIconId:(NSString *)userIconId;

- (void)hideLine:(BOOL)hide;
    
/** 点击Item回调 */
@property (nonatomic, copy) JournalTableHeaderItemDidBlock didItemBlock;

@end
