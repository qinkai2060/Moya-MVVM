//
//  CustomPasswordAlter.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, CustomPasswordAlterType) {
//
//    CustomPasswordAlterDefault, //默认 一个按钮
//    CustomPasswordAlterDouble // 两个按钮
//};


NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomPasswordAlterClickSureBlock)();
typedef void(^CustomPasswordAlterClickCloseBlock)();

@interface CustomPasswordAlter : UIView

@property (nonatomic, copy) CustomPasswordAlterClickSureBlock sureblock;
@property (nonatomic, copy) CustomPasswordAlterClickCloseBlock closeblock;

/**
 自定义密码提示框
 
 @param view 父试图
 @param title 提示语
 @param suret 确认按钮的title
 @param closet 关闭按钮的title 如果是一个按钮的话  closet传nil 或 @""
 @param sureblock 确认按钮回调
 @param closeblock 关闭按钮回调
 @return 密码提示框返回
 */
+(instancetype)showCustomPasswordAlterViewViewIn:(UIView *)view title:(NSString *)title suret:(NSString *)suret closet:(NSString *)closet sureblock:(void(^)())sureblock closeblock:(void(^)())closeblock;


@end

NS_ASSUME_NONNULL_END
