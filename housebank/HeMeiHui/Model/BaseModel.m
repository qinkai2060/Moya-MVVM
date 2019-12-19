//
//  BaseModel.m
//  loanPro
//
//  Created by 任为 on 2017/8/31.
//  Copyright © 2017年 Reeve. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
    [super setValuesForKeysWithDictionary:[self rmoveNilFromDic:keyedValues]];
}

- (NSDictionary*)rmoveNilFromDic:(NSDictionary*)dic{
    
    NSArray *keys = [dic allKeys];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString *key in keys) {
        
        if ([mutableDic valueForKey:key]==[NSNull null]) {
            
            [mutableDic setValue:@"NSNULL" forKey:key];
        }
    }
    
    return [mutableDic copy];
}

@end
