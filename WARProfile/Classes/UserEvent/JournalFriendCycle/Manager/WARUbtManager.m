//
//  WARUbtManager.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/23.
//

#import "WARUbtManager.h"
#import "WARNetwork.h"
#import "WARMacros.h"
#import "NSString+UUID.h"

@implementation WARUbtManager

+ (void)buryPointWithUbtParam:(WARUbtParam *)ubtParam compeletion:(void (^)(BOOL success, NSError *err))compeletion {
    NSString* uri = [NSString stringWithFormat:@"https://wander.wallan-tech.com:1443/media-dc/ubt/wander/info"];
    
    /// action -》 content
    NSMutableDictionary *actionContentParams = [NSMutableDictionary dictionary];
    actionContentParams[@"imageList"] = ubtParam.action.content.imageList;
    actionContentParams[@"textList"] = ubtParam.action.content.textList;
    actionContentParams[@"videoList"] = ubtParam.action.content.videoList;
//    [actionContentParams setObject:ubtParam.action.content.imageList forKey:@"imageList"];
//    [actionContentParams setObject:ubtParam.action.content.textList forKey:@"textList"];
//    [actionContentParams setObject:ubtParam.action.content.videoList forKey:@"videoList"];
    
    /// action
    NSMutableDictionary *actionParams = [NSMutableDictionary dictionary];
//    [actionParams setObject:ubtParam.action.type forKey:@"type"];
    //    [actionParams setObject:actionContentParams forKey:@"content"];
    actionParams[@"type"] = ubtParam.action.type;
    actionParams[@"content"] = actionContentParams;
    
    /// target
    NSMutableDictionary *targetParams = [NSMutableDictionary dictionary];
    targetParams[@"targetId"] = ubtParam.target.targetId;
    targetParams[@"type"] = ubtParam.target.type;
//    [targetParams setObject:ubtParam.target.targetId forKey:@"id"];
//    [targetParams setObject:ubtParam.target.type forKey:@"type"];
    
    /// params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"accountId"] = ubtParam.accountId;
    params[@"time"] = [NSString UUIDTimestamp];
    params[@"action"] = actionParams;
    params[@"target"] = targetParams;
//    [params setObject:ubtParam.accountId forKey:@"accountId"];
//    [params setObject:[NSString UUIDTimestamp] forKey:@"time"];
//    [params setObject:actionParams forKey:@"action"];
//    [params setObject:targetParams forKey:@"target"];
    
    [WARNetwork postDataFromURI:uri params:params completion:^(id responseObj, NSError *err) {
        NDLog(@"responseObj = %@", responseObj);
        if (!err) {
            if (compeletion) {
                compeletion(YES,nil);
            }
        } else {
            if (compeletion) {
                compeletion(NO,err);
            }
        }
    }];
}

@end
