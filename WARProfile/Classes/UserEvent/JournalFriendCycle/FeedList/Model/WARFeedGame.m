//
//  WARFeedGame.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/4.
//

#import "WARFeedGame.h"
#import "MJExtension.h"

@implementation WARFeedGame

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"gameRanks" : @"WARFeedGameRankModel"};//前边，是属性数组的名字，后边就是类名
}



@end
