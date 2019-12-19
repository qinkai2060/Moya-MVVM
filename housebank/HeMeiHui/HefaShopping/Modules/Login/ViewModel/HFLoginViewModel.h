//
//  HFLoginViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFLoginViewModel : HFViewModel

/**
 国家
 */
@property(nonatomic,strong)NSString *countryStr;
/**
 国家码
 */
@property(nonatomic,strong)NSString *countryCode;

/**
 登录的用户名
 */
@property(nonatomic,strong)NSString *userName;
/**
 密码登录
 */
@property(nonatomic,strong)NSString *passWord;

/**
 密码登录执行操作
 */
@property(nonatomic,strong)RACCommand *passWordLoginCommnd;

/**
 密码登录接收信号
 */
@property(nonatomic,strong)RACSubject *passWordLoginSubject;

/**
 快速登录网络请求
 */
@property(nonatomic,strong)RACCommand *quickLoginCommnd;

/**
 快速登录操作接收
 */
@property(nonatomic,strong)RACSubject *quickLoginSubject;

/**
 快速登录的发送验证码
 */
@property(nonatomic,strong)RACCommand *sendQuickCodeCommand;

/**
 滑块验证码
 */
@property(nonatomic,strong)NSString *NECaptchaValidate;
/**
 验证用户名密码
 */
@property(nonatomic,strong)RACSignal *validSigal;
/**
 验证用户名验证码
 */
@property(nonatomic,strong)RACSignal *codevalidSigal;
/**
 是否同意
 */
@property(nonatomic,assign)BOOL isAgree;
/**
 验证码
 */
@property(nonatomic,strong)NSString *code;

/**
 验证用户名验证码
 */
@property(nonatomic,strong)RACSubject *codeverifySuvject;

/**
 进入会员
 */
@property(nonatomic,strong)RACSubject *memberSubject;
/**
 进入隐私
 */
@property(nonatomic,strong)RACSubject *privacySubject;
/**
 进入会员
 */
@property(nonatomic,strong)RACSubject *findmemberSubject;
/**
 进入隐私
 */
@property(nonatomic,strong)RACSubject *findprivacySubject;
/**
 进入会员
 */
@property(nonatomic,strong)RACSubject *regmemberSubject;
/**
 进入隐私
 */
@property(nonatomic,strong)RACSubject *regprivacySubject;

/**
 进入找回密码
 */
@property(nonatomic,strong)RACSubject *findPassWordSubject;

/**
 关闭国家手机区号
 */
@property(nonatomic,strong)RACSubject *countryCodeCloseSubject;

/**
 打开国家手机区号
 */
@property(nonatomic,strong)RACSubject *openCountryCodeSubject;

/**
 选择国家
 */
@property(nonatomic,strong)RACSubject *didSelectCountryCodeSubject;

#pragma mark *****注册界面的信号网络请求以及参数*******
@property(nonatomic,copy)NSString *regPhone;

@property(nonatomic,copy)NSString *regPassWord;

@property(nonatomic,copy)NSString *regCode;

@property(nonatomic,assign)BOOL regAgree;

@property(nonatomic,copy)NSString *regNECaptchaValidate;

/**
 国家码
 */
@property(nonatomic,strong)NSString *regcountryCode;

@property(nonatomic,strong)RACSignal *regValidSigal;

/**
 注册请求
 */
@property(nonatomic,strong)RACCommand *regCommnd;

/**
 注册请求接收
 */
@property(nonatomic,strong)RACSubject *regSubject;
/**
 注册发送验证码
 */
@property(nonatomic,strong)RACCommand *regsendCodeCommnd;
/**
 注册发送验证码接收
 */
@property(nonatomic,strong)RACSubject *regsendCodeSubject;

/**
 注册成功发送账户接收
 */
@property(nonatomic,strong)RACSubject *regSuccessPhoneSubject;
/**
 注册成功发送密码接收
 */
@property(nonatomic,strong)RACSubject *regSuccessPassWordSubject;
#pragma mark *****找回密码的信号网络请求以及参数*******
@property(nonatomic,copy)NSString *findPhone;

@property(nonatomic,copy)NSString *findPassWord;

@property(nonatomic,copy)NSString *findSurePassWord;

@property(nonatomic,copy)NSString *findCode;

@property(nonatomic,assign)BOOL findAgree;

@property(nonatomic,copy)NSString *findNECaptchaValidate;

@property(nonatomic,strong)RACSignal *findValidSigal;
/**
 国家码
 */
@property(nonatomic,strong)NSString *findcountryCode;


/**
 注册请求
 */
@property(nonatomic,strong)RACCommand *findCommnd;

/**
 注册请求接收
 */
@property(nonatomic,strong)RACSubject *findSubject;
/**
 注册发送验证码
 */
@property(nonatomic,strong)RACCommand *findsendCodeCommnd;
/**
 注册发送验证码接收
 */
@property(nonatomic,strong)RACSubject *findsendCodeSubject;

/**
 修改找回成功成功发送账户接收
 */
@property(nonatomic,strong)RACSubject *findSuccessPhoneSubject;
/**
  修改找回成功成功发送账户接收
 */
@property(nonatomic,strong)RACSubject *findSuccessPassWordSubject;
@end

NS_ASSUME_NONNULL_END
