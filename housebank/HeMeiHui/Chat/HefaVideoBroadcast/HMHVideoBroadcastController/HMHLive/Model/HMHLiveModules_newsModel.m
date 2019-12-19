//
//  HMHLiveModules_newsModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMHLiveModules_newsModel.h"

@implementation HMHLiveModules_newsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [HMHLivieNewsItemsModel class],
             
             };
}
@end
