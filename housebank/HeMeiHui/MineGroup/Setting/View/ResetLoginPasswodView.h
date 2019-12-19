//
//  ResetLoginPasswodView.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResetLoginPasswodViewSureBlock)();

@interface ResetLoginPasswodView : UIView
/**
 原密码
 */
@property (nonatomic, strong) UITextField *textfOriginal;
/**
 新密码
 */
@property (nonatomic, strong) UITextField *textfNew;
/**
 确认密码
 */
@property (nonatomic, strong) UITextField *textfNewAgain;

@property (nonatomic, strong) ResetLoginPasswodViewSureBlock sureBlock;
@end

NS_ASSUME_NONNULL_END
