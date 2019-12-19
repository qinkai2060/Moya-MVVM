//
//  NetWorkManager.m
//  HeMeiHui
//
//  Created by Tracy on 2019/11/4.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager

+ (instancetype)shareManager {
    static NetWorkManager * workManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        workManager = [[NetWorkManager alloc]init];
    });
    return  workManager;
}

- (NSString *)configName {
    NSString * defaultString = @"netWork";
    if (_configName == nil) {
        _configName = defaultString;
    }
    return defaultString;
}

- (NSString *)getForKey:(NSString *)key {
   // 先找到文件
    if(key){
        NSString * serviceConfigJsonFile = [[NSBundle mainBundle]pathForResource:self.configName ofType:@"json"];
        NSError * error = nil;
        NSDictionary *serviceConfig = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:serviceConfigJsonFile] options:NSJSONReadingAllowFragments error:&error];
         NSArray *nameArray = [key componentsSeparatedByString:@"."];
         NSString *category = nameArray[0];
         NSString *name = nameArray[1];
        if ([serviceConfig.allKeys containsObject:category]) {
             if (category && name) {
                NSDictionary * allDic =  [serviceConfig objectForKey:category];
                NSString * value = [allDic objectForKey:name];
                return  value;
            }
        }
    }
    return  @"";
}
@end
