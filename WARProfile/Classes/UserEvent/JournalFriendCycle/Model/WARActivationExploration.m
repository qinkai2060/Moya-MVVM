//
//  WARActivationExploration.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARActivationExploration.h"
#import "MJExtension.h"
#import "WARUIHelper.h"
#import "WARDBContactHelper.h"

@implementation WARActivationExploration

- (void)mj_keyValuesDidFinishConvertingToObject {
    _formatTime = [WARUIHelper timeInfoOfMomentWithTimeIntervalSecond:[_time doubleValue]];
    
    //accountId 获取用户信息
    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
}

@end

