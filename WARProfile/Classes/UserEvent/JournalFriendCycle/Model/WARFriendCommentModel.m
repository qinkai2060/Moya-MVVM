//
//  WARFriendCommentModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARFriendCommentModel.h"
#import "MJExtension.h"

@implementation WARFriendCommentModel

- (NSArray<WARFriendComment *> *)comments {
    if (!_comments) {
        _comments = [NSArray array];
    }
    return _comments;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"comments" : @"WARFriendComment"};//前边，是属性数组的名字，后边就是类名
}

@end
