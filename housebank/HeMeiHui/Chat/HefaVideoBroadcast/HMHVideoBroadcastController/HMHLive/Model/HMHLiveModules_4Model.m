//
//  HMHLiveModules_4Model.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMHLiveModules_4Model.h"

@implementation HMHLiveModules_4Model
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [HMHLiveModules_4ItemsModel class],
             
             };
}
@end
