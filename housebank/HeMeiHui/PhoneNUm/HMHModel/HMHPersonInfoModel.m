//
//  HMHPersonInfoModel.m
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import "HMHPersonInfoModel.h"

@implementation HMHPersonInfoModel

+ (NSString *)primaryKey{
    
    
    return @"mobileID";
}

+ (NSArray<NSString *> *)indexedProperties {
    
    return @[@"contactName"];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
