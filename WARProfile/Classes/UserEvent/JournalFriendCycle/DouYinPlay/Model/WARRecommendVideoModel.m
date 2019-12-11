//
//  WARRecommendVideoModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import "WARRecommendVideoModel.h"
#import "MJExtension.h"

@implementation WARRecommendVideoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"videos" : @"WARRecommendVideo"};//前边，是属性数组的名字，后边就是类名
}

@end
