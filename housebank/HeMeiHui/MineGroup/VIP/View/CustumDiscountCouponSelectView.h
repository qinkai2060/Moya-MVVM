//
//  CustumDiscountCouponSelectView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CustumDiscountCouponSelectViewClickCloseBlock)(void);
typedef void(^CustumDiscountCouponSelectViewClickIsNoLoginBlock)(void);//未登录

@interface CustumDiscountCouponSelectView : UIView

@property (nonatomic, copy) CustumDiscountCouponSelectViewClickCloseBlock closeblock;
@property (nonatomic, copy) CustumDiscountCouponSelectViewClickIsNoLoginBlock isNoLoginBlock;
+(instancetype)CustumDiscountCouponSelectViewIn:(UIView *)view closeblock:(void(^)(void))closeblock isNoLoginBlock:(void(^)(void))isNoLoginBlock;

@end

NS_ASSUME_NONNULL_END
