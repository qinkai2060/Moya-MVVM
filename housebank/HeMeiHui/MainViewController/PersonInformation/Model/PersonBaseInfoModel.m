//
//  PersonBaseInfoModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonBaseInfoModel.h"

@implementation PersonBaseInfoModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end
