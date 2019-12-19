//
//  SaveShoppingCar.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/22.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SaveShoppingCar.h"
@implementation ShoppingCar
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
        self.shoppingCarId = value;
}
//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"shoppingCarId"}];
//}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"shoppingCarId":@"id"};
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


@implementation ShoppingCarData
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


@implementation SaveShoppingCar
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

