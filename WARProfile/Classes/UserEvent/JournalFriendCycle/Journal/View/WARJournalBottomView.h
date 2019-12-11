//
//  WARJournalBottomView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <UIKit/UIKit.h>


@class WARMoment,WARJournalBottomView,WARMomentSendingView,WARMomentSendFailView;

@protocol WARJournalBottomViewDelegate <NSObject>
@optional

-(void)journalBottomViewShowPop:(WARJournalBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;
-(void)journalBottomViewDidPriase:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)journalBottomViewDidComment:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;

-(void)journalBottomViewDidAllContext:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)journalBottomViewDidDelete:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)journalBottomViewDidPublish:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
@end

@interface WARJournalBottomView : UIView

@property (nonatomic, weak) id<WARJournalBottomViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WARMoment *moment;

/** 发布中 */
@property (nonatomic, strong) WARMomentSendingView *sendingView;
/** 发布失败 */
@property (nonatomic, strong) WARMomentSendFailView *sendFailView;

- (void)showAllContext:(BOOL)show;

@end
