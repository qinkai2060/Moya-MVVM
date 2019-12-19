
//
//  ManageSelectShopModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageSelectShopModel.h"

@implementation ManageSelectShopModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)identifier {
    return @"ManageShopViewCellTableViewCell";
}

- (CGFloat)height {
    return 175 ;
}


@end
