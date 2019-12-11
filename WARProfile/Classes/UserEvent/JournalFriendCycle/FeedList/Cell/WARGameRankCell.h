//
//  WARGameCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARFeedCell.h"

@class WARFeedImageComponent;
@class WARFeedLinkComponent;
@class WARGameRankCell;
@class WARFeedGame;
@protocol WARGameRankCellDelegate <NSObject>
@optional 
- (void)gameRankCell:(WARGameRankCell *)cell didLink:(WARFeedLinkComponent *)link;
- (void)gameRankCellDidAllRank:(WARGameRankCell *)cell game:(WARFeedGame *)game;
@end

@interface WARGameRankCell : WARFeedCell
@property (nonatomic, weak) id<WARGameRankCellDelegate> delegate;
@end
