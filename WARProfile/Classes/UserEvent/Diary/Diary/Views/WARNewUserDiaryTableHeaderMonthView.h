//
//  WARNewUserDiaryTableHeaderMonthView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import <UIKit/UIKit.h>
@class WARNewUserDiaryMonthModel;
@class WARNewUserDiaryTableHeaderMonthView;

@protocol WARNewUserDiaryTableHeaderMonthViewDeleagte<NSObject>
- (void)userDiaryMonthView:(WARNewUserDiaryTableHeaderMonthView *)userDiaryMonthView value:(WARNewUserDiaryMonthModel *)value;
@end

@interface WARNewUserDiaryTableHeaderMonthView : UIView

@property (nonatomic, weak) id<WARNewUserDiaryTableHeaderMonthViewDeleagte> delegate;
@property (nonatomic, copy) NSMutableArray <WARNewUserDiaryMonthModel *>*monthLogs;

- (void)reloadData;

@end
