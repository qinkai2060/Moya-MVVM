//
//  YunDianOrderListModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderListModel.h"

@implementation YunDianOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderProducts" : [YunDianOrderProductsModel class],
             };
}

@end
