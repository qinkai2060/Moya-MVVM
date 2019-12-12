//
//  WARNewUserDiaryTableHeaderTodayView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

/**
 <#Description#>

 - WARNewUserDiaryTodayTypeRecordToday: <#WARNewUserDiaryTodayTypeRecordToday description#>
 - WARNewUserDiaryTodayTypeFriend: <#WARNewUserDiaryTodayTypeFriend description#>
 - WARNewUserDiaryTodayTypeDrafts: <#WARNewUserDiaryTodayTypeDrafts description#>
 */
typedef NS_ENUM(NSUInteger, WARNewUserDiaryTodayType) {
    WARNewUserDiaryTodayTypeRecordToday = 1,
    WARNewUserDiaryTodayTypeFriend,
    WARNewUserDiaryTodayTypePublish
};

#import <UIKit/UIKit.h>
@class WARNewUserDiaryTableHeaderTodayView;

@protocol WARNewUserDiaryTableHeaderTodayViewDeleagte<NSObject>
- (void)userDiaryTodayView:(WARNewUserDiaryTableHeaderTodayView *)userDiaryTodayView  didItemType:(WARNewUserDiaryTodayType)itemType;
@end

@interface WARNewUserDiaryTableHeaderTodayView : UIView

@property (nonatomic, weak) id<WARNewUserDiaryTableHeaderTodayViewDeleagte> delegate;

@end


#pragma mark - WARNewUserDiaryTodayItemView

@class WARNewUserDiaryTodayItemModel,WARNewUserDiaryTodayItemView;
@protocol WARNewUserDiaryTodayItemViewDeleagte<NSObject>
- (void)userDiaryTodayItemView:(WARNewUserDiaryTodayItemView *)userDiaryTodayItemView  didItemType:(WARNewUserDiaryTodayType)itemType;
@end

@interface WARNewUserDiaryTodayItemView : UIView

@property (nonatomic, weak) id<WARNewUserDiaryTodayItemViewDeleagte> delegate;
@property (nonatomic, strong) WARNewUserDiaryTodayItemModel *item;

- (void)showTipView:(BOOL)show;

@end


#pragma mark - WARNewUserDiaryTodayItemModel

@interface WARNewUserDiaryTodayItemModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showTip;
@property (nonatomic, assign) WARNewUserDiaryTodayType itemType;

@property (nonatomic, assign) NSInteger unreadMomentCount;
@property (nonatomic, assign) NSInteger drafsCount;

@end
