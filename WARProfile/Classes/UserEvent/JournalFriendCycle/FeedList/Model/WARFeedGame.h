//
//  WARFeedGame.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "WARFeedGameRankModel.h"

@class WARFeedComponentContent;
@interface WARFeedGame : NSObject
/** 排序 */
@property (nonatomic, assign) BOOL ascend;
/** 游戏id */ 
@property (nonatomic, copy) NSString *gameId;
/** 游戏名 */
@property (nonatomic, copy) NSString *gameName;
/** 游戏链接地址 */
@property (nonatomic, copy) NSString *gameUrl;
/** 是否显示排行榜 */
@property (nonatomic, assign) BOOL showRank;
/** 游戏截图或者封面图 */
@property (nonatomic, strong) WARFeedComponentContent *media; 
/** 排名版 */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRankModel *> *gameRanks;

/** 辅助字段 */
/** 是否属于多页 */
@property (nonatomic, assign) BOOL isMultiPage;
@end
