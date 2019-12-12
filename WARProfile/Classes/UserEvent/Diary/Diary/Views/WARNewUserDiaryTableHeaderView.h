//
//  WARNewUserDiaryTableHeaderView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//
 
#define kTodayViewHeight 135

/**
 TableHeaderView 事件类型 
 */
typedef NS_ENUM(NSUInteger, WARNewUserDiaryTableHeaderActionType) {
    /**
     WARNewUserDiaryTodayTypeRecordToday = 1,
     WARNewUserDiaryTodayTypeFriend,
     WARNewUserDiaryTodayTypeDrafts
     */
    WARNewUserDiaryTableHeaderActionTypeRecordToday = 1,
    WARNewUserDiaryTableHeaderActionTypeFriend = 2,
    WARNewUserDiaryTableHeaderActionTypePublish = 3,
    
    WARNewUserDiaryTableHeaderActionTypeDidMonth = 4
};

#import <UIKit/UIKit.h>
@class WARNewUserDiaryTableHeaderView,WARNewUserDiaryMonthModel;

@protocol WARNewUserDiaryTableHeaderViewDeleagte<NSObject>
- (void)userDiaryTableHeaderView:(WARNewUserDiaryTableHeaderView *)userDiaryTableHeaderView  actionType:(WARNewUserDiaryTableHeaderActionType)actionType value:(id)value;
@end

@interface WARNewUserDiaryTableHeaderView : UIView

@property (nonatomic, weak) id<WARNewUserDiaryTableHeaderViewDeleagte> delegate;
 
@property (nonatomic, copy)NSMutableArray <WARNewUserDiaryMonthModel *> *monthLogs;
@property (nonatomic, copy)NSArray *photos;

@property (nonatomic, assign) BOOL  isShowInputPhotoBtn;
@property (nonatomic,assign) BOOL isScrollIng;

@end
