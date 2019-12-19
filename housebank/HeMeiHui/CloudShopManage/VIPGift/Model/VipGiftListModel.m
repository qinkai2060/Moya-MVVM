//
//  VipGiftListModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftListModel.h"

@implementation VipGiftListModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"playID":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end
