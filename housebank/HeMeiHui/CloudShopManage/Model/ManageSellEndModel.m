//
//  ManageSellEndModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageSellEndModel.h"

@implementation ManageSellEndModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)identifier {
    return @"ManageOwnEndTableViewCell";
}

- (CGFloat)height {
    return 150 ;
}
@end
