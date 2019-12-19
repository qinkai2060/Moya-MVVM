//
//  VipGiftShopModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftShopModel.h"

@implementation VipGiftShopModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"productID":@"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end
