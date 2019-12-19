//
//  ResetSecondaryPasswordView.h
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ResetSecondaryPasswordViewBlock)();
@interface ResetSecondaryPasswordView : UIView
@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UITextField *textfVerificationCode;
@property (nonatomic, strong) UITextField *textfNewSerceCode;
@property (nonatomic, copy) ResetSecondaryPasswordViewBlock block;
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;
@end

NS_ASSUME_NONNULL_END
