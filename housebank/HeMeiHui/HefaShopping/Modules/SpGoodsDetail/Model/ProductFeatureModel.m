//
//  ProductFeatureModel.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/20.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ProductFeatureModel.h"
@implementation SKUItem
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.featureId = value;
}
//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"featureId"}];
//}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"featureId":@"id"};
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


@implementation DescartesCombinationMap
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


@implementation SeriesAttributesItem
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.featureDetailId = value;
}
//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"featureDetailId"}];
//}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"featureDetailId":@"id"};
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


@implementation ProductTtributesMap
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


@implementation RsMap
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


@implementation FeatureModelDetail
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


@implementation ProductFeatureModel
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

