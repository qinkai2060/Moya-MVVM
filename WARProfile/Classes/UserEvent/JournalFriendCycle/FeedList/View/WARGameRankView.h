//
//  WARGameRankView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import <UIKit/UIKit.h>
#import "WARFeedGame.h"

@class WARGameSegmentView;
@protocol WARGameSegmentViewDelegate <NSObject>
@optional
- (void)gameSegmentView:(WARGameSegmentView *)gameSegmentView didIndex:(NSInteger)index;
@end

@interface WARGameSegmentView : UIView
/** delegate */
@property (nonatomic, weak) id<WARGameSegmentViewDelegate> delegate;

/** tags */
@property (nonatomic, strong) NSMutableArray <NSString *>*tags;
@end

@interface WARGameRankViewCell:UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** rank */
@property (nonatomic, strong) WARFeedGameRank *rank;
@end

@interface WARAllGameRankCell:UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end


typedef void(^WARGameRankViewAllRankBlock)(void);
@interface WARGameRankView : UIView
/** 排名版 */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRankModel *> *gameRanks;
/** game */
@property (nonatomic, strong) WARFeedGame *game;
/** allRankBlock */
@property (nonatomic, copy) WARGameRankViewAllRankBlock allRankBlock;
@end

