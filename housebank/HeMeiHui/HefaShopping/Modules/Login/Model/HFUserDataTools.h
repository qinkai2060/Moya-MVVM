//
//  HFUserDataTools.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define USERNAME @"userName"
@interface HFUserDataTools : NSObject
+ (void)login:(id)body;
+ (BOOL)isLogin;
+ (BOOL)isVip;
+(void)logout;

+ (NSDictionary*)loginData:(id)obj;

+ (NSString*)userName;
+ (NSString*)loginAreacode;
+ (NSString*)codeValue;
+ (NSString *)getUserUidStr;
+ (NSString*)loginSuccess;
+ (void)loginAtNetease:(id)body;
+ (void)logoutAtNetease;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
