//
//  AESTools.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/11/7.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESTools : NSObject

// 加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
// 解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
