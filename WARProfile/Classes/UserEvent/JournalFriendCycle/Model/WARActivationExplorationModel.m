//
//  WARActivationExplorationModel.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARActivationExplorationModel.h"
#import "MJExtension.h"

@implementation WARActivationExplorationModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"trackLists" : @"WARActivationExploration"};//前边，是属性数组的名字，后边就是类名
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
}

@end
