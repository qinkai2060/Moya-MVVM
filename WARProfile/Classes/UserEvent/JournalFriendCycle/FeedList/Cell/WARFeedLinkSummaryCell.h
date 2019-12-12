//
//  WARFeedLinkSummaryCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import "WARFeedCell.h"
@class WARFeedLinkComponent;
@class WARFeedLinkSummaryCell;

@protocol WARFeedLinkSummaryCellDelegate <NSObject>

- (void)linkSummaryCell:(WARFeedLinkSummaryCell *)cell didLink:(WARFeedLinkComponent *)link;

@end


@interface WARFeedLinkSummaryCell : WARFeedCell

/** delegate */
@property (nonatomic, weak) id<WARFeedLinkSummaryCellDelegate> delegate;

@end
