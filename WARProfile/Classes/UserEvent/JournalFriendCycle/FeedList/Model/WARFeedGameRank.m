//
//  WARFeedGameRank.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARFeedGameRank.h"
#import "MJExtension.h"
#import "WARDBContactHelper.h"
#import "WARDBUserManager.h"
#import "NSString+Size.h"

@implementation WARFeedGameRank

-(void)mj_keyValuesDidFinishConvertingToObject {
    //是否是自己发布的
    _isMine = [_accountId isEqualToString:[WARDBUserManager userModel].accountId];

    _scoreWidth = [_score widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:13] constrainedToHeight:13];
    _listScoreWidth = [_score widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15] constrainedToHeight:15];
    
    _listNicknameWidth = [_nickname widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16] constrainedToHeight:16];
    _nicknameWidth = [_nickname widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] constrainedToHeight:13];
    
//    if (_score == nil || _score.length <= 0) {
//        _scoreWidth = [@"--" widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:13] constrainedToHeight:13];
//    }
}

@end
