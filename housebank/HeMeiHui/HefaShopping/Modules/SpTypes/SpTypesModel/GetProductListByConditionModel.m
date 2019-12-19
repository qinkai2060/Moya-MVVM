//
//  GetProductListByConditionModel.m
//  housebank
//
//  Created by liqianhong on 2018/11/1.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "GetProductListByConditionModel.h"

@implementation GetProductListByConditionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.productId=value;
    }
}

@end
