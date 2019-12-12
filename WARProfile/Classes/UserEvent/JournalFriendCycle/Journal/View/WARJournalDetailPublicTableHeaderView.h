//
//  WARJournalDetailPublicTableHeaderView.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import <UIKit/UIKit.h>

@class WARJournalDetailPublicTableHeaderView;
@protocol WARJournalDetailPublicTableHeaderViewDelegate <NSObject>
-(void)headerViewDidAllPraise:(WARJournalDetailPublicTableHeaderView *)headerView;
@end

@interface WARJournalDetailPublicTableHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame momentId:(NSString *)momentId;

/** delegate */
@property (nonatomic, weak) id<WARJournalDetailPublicTableHeaderViewDelegate> delegate;

@end
