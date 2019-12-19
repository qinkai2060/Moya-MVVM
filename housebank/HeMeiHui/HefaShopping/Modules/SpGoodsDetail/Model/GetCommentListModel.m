//
//  GetCommentListModel.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "GetCommentListModel.h"

@implementation GetCommentListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.commentId=value;
    }
}

@end
