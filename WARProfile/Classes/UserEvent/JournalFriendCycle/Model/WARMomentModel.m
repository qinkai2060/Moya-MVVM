//
//  WARMomentModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMomentModel.h"
#import "MJExtension.h"

@implementation WARMomentModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"moments" : @"WARMoment"};//前边，是属性数组的名字，后边就是类名
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    /** 类型过滤，有的类型还没有写样式过滤出去 */
    NSMutableArray *filterArray = [NSMutableArray array];
    [_moments enumerateObjectsUsingBlock:^(WARMoment * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hasIncompatible) {
            [filterArray addObject:obj];
        }
    }];
    _moments = [NSArray arrayWithArray:filterArray];
}


@end
