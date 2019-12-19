//
//  YunDianNewRefundDetailModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailModel.h"

@implementation YunDianNewRefundDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"orderProduct" : [YunDianNewRefundOrderProductModel class],
             @"buyerRefundImages" : [YunDianNewRefundBuyerOrSellerRefundImagesMode class],
             @"sellerRefundImages" : [YunDianNewRefundBuyerOrSellerRefundImagesMode class],
             };
}

@end
