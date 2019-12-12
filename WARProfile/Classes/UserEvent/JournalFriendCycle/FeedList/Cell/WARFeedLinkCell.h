//
//  WARFeedLinkCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/24.
//

#import "WARFeedCell.h"

@class WARFeedLinkCell,WARFeedLinkComponent;
@protocol WARFeedLinkCellDelegate <NSObject>

- (void)linkCell:(WARFeedLinkCell *)cell didLink:(WARFeedLinkComponent *)link;

@end

@interface WARFeedLinkCell : WARFeedCell
/** delegate */
@property (nonatomic, weak) id<WARFeedLinkCellDelegate> delegate;

@end
