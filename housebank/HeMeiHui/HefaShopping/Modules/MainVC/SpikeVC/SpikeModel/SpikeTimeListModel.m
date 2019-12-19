//
//  SpikeTimeListModel.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpikeTimeListModel.h"
//@implementation SpikeTimesItem
//- (id) init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
//
//+ (BOOL)propertyIsOptional:(NSString *)propertyName
//{
//    return YES;
//}
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    if([key isEqualToString:@"sort"])
//        self.productId = value;
//}
//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"sort":@"productId"}];
//}
//
//@end


@implementation SpikeTime
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end

@implementation SpikeTimeListModel
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}


@end
