//
//  WARFriendCycleTableHeaderView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/18.
//

#import <UIKit/UIKit.h>

#import "WARFriendCycleSegmentBar.h"

#define kHeaderView (347)
#define kWARFriendCycleTableHeaderViewHeight (347)

@class WARProfileMasksModel;
@class WARFriendCycleTableHeaderView;

@protocol WARFriendCycleTableHeaderViewDelegate <NSObject>
-(void)headerView:(WARFriendCycleTableHeaderView *)headerView didSelectIndex:(NSInteger)index state:(WARFriendCycleTagState)state;
-(void)headerViewDidUserHeader:(WARFriendCycleTableHeaderView *)headerView ;
@end

@interface WARFriendCycleTableHeaderView : UIView
/** delegate */
@property (nonatomic, weak) id<WARFriendCycleTableHeaderViewDelegate> delegate;
/** Description */
@property (nonatomic, strong) WARProfileMasksModel *model;

@property (nonatomic, strong) WARFriendCycleSegmentBar *segmentBar;
@end
