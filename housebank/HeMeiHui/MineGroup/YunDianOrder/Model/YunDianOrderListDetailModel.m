//
//  YunDianOrderListDetailModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderListDetailModel.h"

@implementation YunDianOrderListDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderProductList" : [YunDianorderDetailProductListModel class],
             @"orderReceiptAddress": [YunDianOrderAddress class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"wl_id" : @"id"
             };
}
@end
