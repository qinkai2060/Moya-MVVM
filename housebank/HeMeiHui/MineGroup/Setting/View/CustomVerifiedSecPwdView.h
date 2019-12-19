//
//  CustomVerifiedSecPwdView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CustomVerifiedSecPwdClickSureBlock)(NSString *password);
typedef void(^CustomVerifiedSecPwdClickCloseBlock)();
typedef void(^CustomVerifiedSecPwdClickForgetPassWordBlock)();
@interface CustomVerifiedSecPwdView : UIView

@property (nonatomic, copy) CustomVerifiedSecPwdClickSureBlock sureblock;
@property (nonatomic, copy) CustomVerifiedSecPwdClickCloseBlock closeblock;
@property (nonatomic, copy) CustomVerifiedSecPwdClickForgetPassWordBlock forgetblock;

+(instancetype)showCustomVerifiedSecPwdViewIn:(UIView *)view forgetblock:(void(^)())forgetblock sureblock:(void(^)(NSString *password))sureblock closeblock:(void(^)())closeblock;
@end

NS_ASSUME_NONNULL_END
