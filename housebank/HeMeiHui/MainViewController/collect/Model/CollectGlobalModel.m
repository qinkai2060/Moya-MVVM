//
//  CollectGlobalModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectGlobalModel.h"

@implementation CollectGlobalItemModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end

@implementation CollectGlobalModel

- (NSString *)identifier {
    return @"CollectGlobalHomeViewCell";
}

- (CGFloat)height {
    return 120 ;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end
