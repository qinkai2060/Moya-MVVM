//
//  AssembleClassifications.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleClassifications.h"
@implementation ClassificationsItem
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

@end


@implementation Classifications

@end

@implementation AssembleClassifications

@end
