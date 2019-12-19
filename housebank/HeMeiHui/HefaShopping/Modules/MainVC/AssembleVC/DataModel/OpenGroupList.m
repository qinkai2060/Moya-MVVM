//
//  OpenGroupList.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/3.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "OpenGroupList.h"
@implementation OpenGroupListItem
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
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.ID = value;
}

//+(JSONKeyMapper *)keyMapper{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"ID"}];
//}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end


@implementation OpenGroup
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
@end


@implementation OpenGroupList
@end

