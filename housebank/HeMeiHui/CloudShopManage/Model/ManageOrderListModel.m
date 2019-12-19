//
//  ManageOrderListModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOrderListModel.h"

@implementation ManageOrderListModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)identifier {
    return @"ManageOrderTableViewCell";
}

- (CGFloat)height {
    return 90 ;
}

@end
