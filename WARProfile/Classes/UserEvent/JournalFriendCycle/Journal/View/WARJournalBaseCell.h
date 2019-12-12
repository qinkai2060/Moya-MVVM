//
//  WARJournalBaseCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

typedef NS_ENUM(NSUInteger, WARJournalBaseCellActionType) {
    WARJournalBaseCellActionTypeDidTopPop = 1,
    WARJournalBaseCellActionTypeDidBottomPop = 2,
    WARJournalBaseCellActionTypeDidPageContent = 3,
    WARJournalBaseCellActionTypeScrollHorizontalPage = 4,
    WARJournalBaseCellActionTypeFinishScrollHorizontalPage = 5,
    
    WARJournalBaseCellActionTypeDidImage = 10
};


#import <UIKit/UIKit.h>
@class WARMoment,WARJournalTopView,WARJournalBottomView,WARJournalBaseCell,WARFeedImageComponent,WARFeedComponentContent,WARFeedLinkComponent,WARFeedGame;

@protocol WARJournalBaseCellDelegate <NSObject>

@optional
-(void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell actionType:(WARJournalBaseCellActionType)actionType value:(id)value; 
-(void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView ;
-(void)journalBaseCellShowPop:(WARJournalBaseCell *)journalBaseCell actionType:(WARJournalBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;
-(void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didLink:(WARFeedLinkComponent *)linkContent;
-(void)journalBaseCell:(WARJournalBaseCell *)journalBaseCell didGameLink:(WARFeedLinkComponent *)didGameLink;
-(void)journalBaseCellDidAllRank:(WARJournalBaseCell *)journalBaseCell game:(WARFeedGame *)game;

-(void)journalBaseCellDidPriase:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath;
-(void)journalBaseCellDidComment:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath;

-(void)journalBaseCellDidDelete:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath;
-(void)journalBaseCellDidPublish:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath;

-(void)journalBaseCellDidAllContext:(WARJournalBaseCell *)journalBaseCell  indexPath:(NSIndexPath *)indexPath;
@end

@interface WARJournalBaseCell : UITableViewCell

@property (nonatomic, weak) id<WARJournalBaseCellDelegate> delegate;

@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WARJournalTopView *topView;
@property (nonatomic, strong) WARJournalBottomView *bottomView;
  
- (void)setUpUI; 

@end
