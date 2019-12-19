//
//  SpTypeFirstLevelModel.m
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypeFirstLevelModel.h"

@implementation SpTypeFirstLevelModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.levelId=value;
    }
}

@end
