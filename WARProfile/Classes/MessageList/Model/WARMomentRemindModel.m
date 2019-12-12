//
//  WARMomentRemindModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARMomentRemindModel.h"

@implementation WARMomentRemindModel

- (NSMutableArray<WARMomentRemind *> *)reminds {
    if (!_reminds) {
        _reminds = [NSMutableArray <WARMomentRemind *>array];
    }
    return _reminds;
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"reminds" : @"WARMomentRemind"};//前边，是属性数组的名字，后边就是类名
}

@end
