//
//  WARFeedGameRankModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/4.
//

#import "WARFeedGameRankModel.h"
#import "MJExtension.h"
#import "WARLocalizedHelper.h"


@implementation WARFeedGameRankModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"ranks" : @"WARFeedGameRank",
             @"gameRanks" : @"WARFeedGameRank"
             };//前边，是属性数组的名字，后边就是类名
}


- (void)mj_keyValuesDidFinishConvertingToObject {
    if (_ranks.count < 4) {
        
        NSMutableArray <WARFeedGameRank *> *tempRanks = [NSMutableArray <WARFeedGameRank *>array];
        for (int i = _ranks.count; i < 4 ; i++) {
            WARFeedGameRank *rank = [[WARFeedGameRank alloc]init];
            rank.nickname = WARLocalizedString(@"虚位以待");
            rank.ranking = i + 1;
            rank.score = @"--  ";
            rank.scoreWidth = 40;
            [tempRanks addObject:rank];
        }
        
        if (_ranks == nil) {
            _ranks =  [NSMutableArray <WARFeedGameRank *>array];
        }
        [_ranks addObjectsFromArray:tempRanks];
    }
    
//    __block CGFloat maxScoreWidth = 0;
//    [_ranks enumerateObjectsUsingBlock:^(WARFeedGameRank * _Nonnull rank, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (maxScoreWidth < rank.scoreWidth) {
//            maxScoreWidth = rank.scoreWidth;
//        }
//    }];
//
//    [_ranks enumerateObjectsUsingBlock:^(WARFeedGameRank * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.scoreWidth = maxScoreWidth;
//    }];
}

@end
