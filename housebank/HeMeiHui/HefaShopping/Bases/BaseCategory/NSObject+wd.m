//
//  NSObject+wd.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/25.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "NSObject+wd.h"

@implementation NSObject (wd)

- (UIImage *)imageWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

#pragma mark --发送通知
- (void)sendNotificationName:(NSString *)notificationName Object:(id)notificationObject {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:notificationObject];
}

- (void)sendNotificationName:(NSString *)notificationName object:(id)notificationObject useInfo:(id )useInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:notificationObject userInfo:useInfo];
}

+ (ManagerTools *)shareManagerTools {
    return [ManagerTools ManagerTools];
}

#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""


//类型识别:将所有的NSNull类型转化成@""

+(id)changeType:(id)myObj

{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

//将NSString类型的原路返回

+(NSString *)stringToString:(NSString *)string

{
    return string;
}

//将Null类型的项目转化成@""

+(NSString *)nullToString

{
    return @"";
}
//将NSDictionary中的Null类型的项目转化成@""

+(NSArray *)nullArr:(NSArray *)myArr

{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

@end
