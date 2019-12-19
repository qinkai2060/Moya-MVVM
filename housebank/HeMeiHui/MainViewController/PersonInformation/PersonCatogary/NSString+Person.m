//
//  NSString+Person.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "NSString+Person.h"

//每组个数
static NSInteger const kGroupSize = 4;

@implementation NSString (Person)

- (NSString *)numberSuitScanf:(NSString*)number {
    
    if (number == nil) {
        return nil;
    }
    
    if ([NSString validateContactNumber:number]) {
        
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 7) withString:@"*******"];
        return numberString;
    }
    
    return nil;
}

- (BOOL)isEmail:(NSString *)emailString {
    if (emailString == nil) {
        return NO;
    }
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return  [pre evaluateWithObject:emailString];
}

- (BOOL)isIDCard:(NSString *)idCardString {
    if (idCardString == nil) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
   return [pre evaluateWithObject:@"idCardString"];
}

/**
 验证码手机号
 
 @param mobileNum 手机号
 @return YES 通过 NO 不通过
 */
+ (BOOL)validateContactNumber:(NSString *)mobileNum
{
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

- (BOOL)isNotNil
{
    if ( self == nil || [self isEqualToString:@""])
        return NO;
    return YES;
}

- (BOOL)isValidPhone {
    if (self.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:self];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:self];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:self];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (NSURL *)get_Image {
    NSString *str=@"";
    if([self containsString:@"http"]){
        return [NSURL URLWithString:objectOrEmptyStr(self)];

    }else {
        if (self.length > 0) {
            NSString *str3 = [self substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    if ([self containsString:@"!"]) {
                        str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,self];
                        return [NSURL URLWithString:str];
                    }else {
                        str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self,@"!YS"];
                        return [NSURL URLWithString:str];
                    }
                }
            }
        }
    }
    return nil;
}
- (NSString *)get_Image_String {
    NSString *str=@"";
    if([self containsString:@"http"]){
        return objectOrEmptyStr(self);

    }else {
        if (self.length > 0) {
            NSString *str3 = [self substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    if ([self containsString:@"!"]) {
                        str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,self];
                        return str;
                    }else {
                        str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self,@"!YS"];
                        return str;
                    }
                }
            }
        }
    }
    return @"";
}
- (NSString *)get_sharImage {
   NSString *str=@"";
    if([self containsString:@"http"]){
        return objectOrEmptyStr(self);

    }else {
        if (self.length > 0) {
            NSString *str3 = [self substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    if ([self containsString:@"!"]) {
                        str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,self];
                        return str;
                    }else {
                        str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,self,@"!YS"];
                        return str;
                    }
                }
            }
        }
    }
    return @"";
}


- (NSURL *)get_BannerImage {
    NSString *str=@"";
    if([self containsString:@"http"]){
        if ([self containsString:@"!"]) {
            return [NSURL URLWithString:objectOrEmptyStr(self)];
        }else {
            NSString * imageStr = [NSString stringWithFormat:@"%@!YS",self];
            return [NSURL URLWithString:imageStr];
        }
    }else {
        if (self.length > 0) {
            NSString *str3 = [self substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    if ([self containsString:@"!"]) {
                        str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,self];
                        return [NSURL URLWithString:str];
                    }else {
                        str = [NSString stringWithFormat:@"%@%@%@%@",manageTools.appInfoModel.imageServerUrl,self,@"!YS",IMGWH(CGSizeMake(ScreenW, 120))];
                        return [NSURL URLWithString:str];
                    }
                }
            }
        }
    }
    return nil;
}

@end
