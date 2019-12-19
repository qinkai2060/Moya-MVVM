//
//  CustomOrdeTypeSelectView.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CustomOrdeTypeSelectViewClickBlock)(NSString *strType);

@interface CustomOrdeTypeSelectView : UIView
@property (nonatomic, copy) CustomOrdeTypeSelectViewClickBlock clickBlock;

/**
 订单选择框初始化集成方法

 @param view 父试图
 @param dataArr 数据源数组
 @param currentTitle 当前navigation title
 @param clickBlock 点击回调
 @return 订单选择框
 */
+(instancetype)showCustomOrdeTypeSelectViewViewIn:(UIView *)view dataArr:(NSArray *)dataArr currentTitle:(NSString *)currentTitle clickBlock:(void(^)(NSString *strType))clickBlock;
@end

NS_ASSUME_NONNULL_END
