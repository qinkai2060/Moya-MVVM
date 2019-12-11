//
//  WARJournalDetailModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/17.
//

#import "WARJournalDetailModel.h"
#import "MJExtension.h"
#import "WARDBContactHelper.h"

@implementation WARJournalDetailModel

- (void)mj_keyValuesDidFinishConvertingToObject {
    _isFriendMoment = [_fMoment isEqualToString:@"TRUE"];
    _isPublicMoment = [_pMoment isEqualToString:@"TRUE"];
    
    //accountId 获取用户信息
    _friendModel = [[WARDBContactHelper sharedInstance] modelWithAccountId:_accountId];
}

@end
