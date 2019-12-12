//
//  WARFriendComment.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARFriendComment.h"
#import "MJExtension.h"
#import "WARMacros.h"

@implementation WARFriendComment

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"medias" : @"WARMomentMedia"};//前边，是属性数组的名字，后边就是类名
}

- (NSString *)formatCommentTime {
    NSString *string;
    
    NSTimeInterval interval = [_commentTime doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日  HH:mm"];
    string = [formatter stringFromDate: date];
    
    return string;
}

- (NSString *)totalTitle {
    NSString *string;
    if (kObjectIsEmpty(_replyorInfo)) { //名字(_commentorInfo.nickname) + 内容(_title)
        NSString* commentUserName = _whisper ? (kStringIsEmpty(_commentorInfo.nickname) ? @"" : [NSString stringWithFormat:@"%@悄悄说",_commentorInfo.nickname]):(kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname);
        NSString* content = kStringIsEmpty(_title) ? @"" : _title;
        string = [NSString stringWithFormat:@"%@：%@",commentUserName,  content];
    } else { //名字(_commentorInfo.nickname) 回复 : 名字(_replyorInfo.nickname)+ 内容(_title)
        NSString* commentUserName = kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname;
        NSString* replyUserName = _whisper ? (kStringIsEmpty(_replyorInfo.nickname) ? @"" : [NSString stringWithFormat:@"%@悄悄说",_replyorInfo.nickname]) : (kStringIsEmpty(_replyorInfo.nickname) ? @"" : _replyorInfo.nickname);
        NSString* content = kStringIsEmpty(_title) ? @"" : _title;
        string = [NSString stringWithFormat:@"%@回复%@：%@",commentUserName, replyUserName, content];
    }
     
    return string;
}

- (NSString *)nameTitle {
    NSString *string;
    if (kObjectIsEmpty(_replyorInfo)) { //名字(_commentorInfo.nickname)
        NSString* commentUserName = _whisper ? (kStringIsEmpty(_commentorInfo.nickname) ? @"" : [NSString stringWithFormat:@"%@悄悄说",_commentorInfo.nickname]):(kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname);;
        string = [NSString stringWithFormat:@"%@ ",commentUserName];
    } else { //名字(_commentorInfo.nickname) 回复 : 名字(_replyorInfo.nickname)
        NSString* commentUserName = kStringIsEmpty(_commentorInfo.nickname) ? @"" : _commentorInfo.nickname;
        NSString* replyUserName = _whisper ? (kStringIsEmpty(_replyorInfo.nickname) ? @"" : [NSString stringWithFormat:@"%@悄悄说",_replyorInfo.nickname]) : (kStringIsEmpty(_replyorInfo.nickname) ? @"" : _replyorInfo.nickname);
        string = [NSString stringWithFormat:@"%@回复%@",commentUserName, replyUserName];
    }
    
    return string;
}

- (NSString *)contentTitle {
    return kStringIsEmpty(_title) ? @"" : _title; 
}


@end
