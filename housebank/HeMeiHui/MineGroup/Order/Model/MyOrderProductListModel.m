//
//  MyOrderProductListModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderProductListModel.h"

@implementation MyOrderProductListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"product_id" : @"id"
             };
}
@end
