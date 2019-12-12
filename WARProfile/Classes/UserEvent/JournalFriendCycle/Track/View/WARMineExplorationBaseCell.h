//
//  WARMineExplorationBaseCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

typedef NS_ENUM(NSUInteger, WARMineExpCellActionType) {
    WARMineExpCellActionTypeDidActivition = 1,
    WARMineExpCellActionTypeDidPageContent = 2,
    WARMineExpCellActionTypeScrollHorizontalPage = 3,
    WARMineExpCellActionTypeFinishScrollHorizontalPage = 4,
    
    WARMineExpCellActionTypeDidImage = 10
};

#import <UIKit/UIKit.h>

@class WARFeedImageComponent;
@class WARMoment;
@class WARMineExplorationTopView;
@class WARMineExplorationBottomView;
@class WARMineExplorationBaseCell;
@class WARFeedLinkComponent;

@protocol WARMineExplorationBaseCellDelegate <NSObject>
@optional
-(void)mineExpBaseCell:(WARMineExplorationBaseCell *)mineExpBaseCell actionType:(WARMineExpCellActionType)actionType value:(id)value;
 
-(void)mineExpBaseCell:(WARMineExplorationBaseCell *)mineExpBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView;
-(void)mineExpBaseCell:(WARMineExplorationBaseCell *)mineExpBaseCell didLink:(WARFeedLinkComponent *)linkContent;
-(void)mineExpBaseCellDidPriase:(WARMineExplorationBaseCell *)mineExpBaseCell  indexPath:(NSIndexPath *)indexPath;
-(void)mineExpBaseCellDidComment:(WARMineExplorationBaseCell *)mineExpBaseCell  indexPath:(NSIndexPath *)indexPath;
@end

@interface WARMineExplorationBaseCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id<WARMineExplorationBaseCellDelegate> delegate;

@property (nonatomic, strong) WARMoment *moment;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WARMineExplorationTopView *topView;
@property (nonatomic, strong) WARMineExplorationBottomView *bottomView;

- (void)setUpUI;

@end
