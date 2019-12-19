//
//  DiscountCouponModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscountCouponModel : NSObject
@property (nonatomic, strong) NSNumber *couponAmount;//面额
@property (nonatomic, strong) NSNumber *couponId;//优惠券ID
@property (nonatomic, strong) NSString *couponNo; //优惠券编号 16位长度
@property (nonatomic, copy) NSString *couponName;//优惠券名称
@property (nonatomic, strong) NSNumber *hasReceviedCount;//已领取数
@property (nonatomic, copy) NSString *subTitle;// 子标题
@property (nonatomic, strong) NSNumber *recevieFlag;//领取标识, 1立即领取 2已领完(已达个人上线) 3已领完(库存已领完)
@property (nonatomic, strong) NSNumber *validityType;//有效期类型 1固定时间;2领取后N天
@property (nonatomic, copy) NSString *validityEnd;//有效期结束
@property (nonatomic, copy) NSString *validityStart; //有效期开始
@property (nonatomic, strong) NSNumber *validityDays; //领取后3天有效
@end

NS_ASSUME_NONNULL_END
