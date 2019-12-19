//
//  ManageOrderModel.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOrderModel.h"
@interface ManageOrderModel ()
//@property (nonatomic, strong) NSArray <ManageOrderListModel *> *orderProductList;
@end

@implementation ManageOrderModel
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

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
