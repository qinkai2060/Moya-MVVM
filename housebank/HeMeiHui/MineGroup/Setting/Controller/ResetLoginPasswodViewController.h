//
//  ResetLoginPasswodViewController.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"
NS_ASSUME_NONNULL_BEGIN
//修改登陆密码成功
typedef void(^ResetPasswordViewLoginSuccessBlock)();
@interface ResetLoginPasswodViewController : BaseSettingViewController

/**
 传过来的tnavigation title   @"修改登录密码"  @"二级密码修改";
 */
@property (nonatomic, strong) NSString *ntitle;

@property (nonatomic, strong) NSString *sid;

@property (nonatomic, copy) ResetPasswordViewLoginSuccessBlock successBlock;
@end

NS_ASSUME_NONNULL_END
