//
//  OrderInfoListModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "OrderInfoListModel.h"

@implementation OrderInfoListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderProductList" : [MyOrderProductListModel class],
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"order_id" : @"id"
             };
}
@end
