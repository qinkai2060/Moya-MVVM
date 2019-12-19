//
//  HFUntilTool.h
//  housebank
//
//  Created by usermac on 2018/11/7.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IMGWH(imageSize) [NSString stringWithFormat:@"YS/both/%.fx%.f/rotate/auto",imageSize.width*2,imageSize.height*2]

NS_ASSUME_NONNULL_BEGIN

@interface HFUntilTool : NSObject
+ (id)EmptyCheckobjnil:(id)obj;
- (UIViewController *)currentVC:(UIView*)v;
+ (CGSize)boundWithStr:(NSString*)str font:(CGFloat)font  maxSize:(CGSize)size;
+ (CGSize)boundWithStr:(NSString*)str blodfont:(CGFloat)font  maxSize:(CGSize)size;
+ (NSString*)dataStr:(NSString*)number;
+(NSString*)productLevelStr:(NSInteger)productLevel;
+ (NSString*)thousandsFload:(CGFloat)cashPrice;
//8-20 字母数字组合
+(BOOL)judgePassWordLegal:(NSString *)pass;
//邮箱正则
+(BOOL)isValidateEmail:(NSString *)email;
/**
 验证号码规则

 @param mobileNum 号码
 @return 成功
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum;
+ (BOOL)isValidateByRegex:(NSString *)mobliePhone;

+ (NSString*) judgePasswordStrength:(NSString*) _password;
+ (NSString *)convertTimeSecond:(NSInteger)timeSecond;
@end

NS_ASSUME_NONNULL_END
