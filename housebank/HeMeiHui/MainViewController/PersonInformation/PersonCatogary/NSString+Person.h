//
//  NSString+Person.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Person)

/**
 验证是否是电话号码,并隐藏

 @param number <#number description#>
 @return <#return value description#>
 */
-(NSString *)numberSuitScanf:(NSString*)number;


/**
 是否是邮箱

 @param emailString <#emailString description#>
 @return <#return value description#>
 */
- (BOOL)isEmail:(NSString *)emailString;

/**
 是否是身份证

 @param idCardString <#idCardString description#>
 @return <#return value description#>
 */
- (BOOL)isIDCard:(NSString *)idCardString;


/**
 空格分组String

 @param string <#string description#>
 @return <#return value description#>
 */
- (NSString *)groupedString:(NSString *)string;


/**
 除去空格

 @param str <#str description#>
 @return <#return value description#>
 */
- (NSString *)removingSapceString:(NSString *)str;

- (BOOL)isNotNil;

- (BOOL)validateContactNumber:(NSString *)mobileNum;

- (BOOL)isValidPhone;

- (NSURL *)get_Image;

- (NSString *)get_Image_String;

- (NSURL *)get_BannerImage;

- (NSString *)get_sharImage ;
@end

NS_ASSUME_NONNULL_END
