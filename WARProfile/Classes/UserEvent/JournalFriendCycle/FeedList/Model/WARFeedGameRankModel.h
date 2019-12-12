//
//  WARFeedGameRankModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/4.
//

#import <Foundation/Foundation.h>
#import "WARFeedGameRank.h"

@interface WARFeedGameRankModel : NSObject
/** cursor */
@property (nonatomic, copy) NSString *cursor;
/** rankName */
@property (nonatomic, copy) NSString *rankName;
/** ranks */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRank *>*ranks;
/** gameRanks */
@property (nonatomic, strong) NSMutableArray <WARFeedGameRank *>*gameRanks;
@end
