//
//  WARCommentWrapper.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARCommentWrapper.h"

@implementation WARCommentWrapper

- (instancetype)init{
    self = [super init];
    if (self) {
        _praiseCount = 0;
        _commentCount = 0;
    }
    return self;
}

- (WARFriendCommentModel *)comment {
    if (!_comment) {
        _comment = [[WARFriendCommentModel alloc] init];
    }
    return _comment;
}

- (WARThumbModel *)thumb {
    if (!_thumb) {
        _thumb = [[WARThumbModel alloc] init];
    }
    return _thumb;
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
}

@end
