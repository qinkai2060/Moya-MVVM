//
//  ManageLogticsListModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageLogticsListModel.h"

@implementation ManageLogticsListModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (NSString *)identifier {
    return @"ManageLogticsTableViewCell";
}

- (CGFloat)height {
    return 80 ;
}

@end
