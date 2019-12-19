//
//  HFUserDataTools.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFUserDataTools.h"
#import "JPUSHService.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "NIMContactTools.h"
#import "HFDBHandler.h"
@implementation HFUserDataTools
+ (void)login:(id)body{
    NSLog(@"%@",body);
    NSDictionary *dic = body;
    NSString *accid = [NSString stringWithFormat:@"%@",dic[@"accid"]];
    NSString *token = [NSString stringWithFormat:@"%@",dic[@"token"]];
    NSString *uid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    NSString *mobilephone = [NSString stringWithFormat:@"%@",dic[@"mobilephone"]];
    NSString *icon = [NSString stringWithFormat:@"%@",dic[@"imagePath"]];
    NSString *sid = [NSString stringWithFormat:@"%@",dic[@"sid"]];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (accid.length > 0) {
        [ud setObject:accid forKey:@"accid"];
    }
    if (token.length > 0) {
        [ud setObject:token forKey:@"token"];
    }
    if (uid.length > 0) {
        [ud setObject:uid forKey:@"uid"];
    }
    if (mobilephone.length > 0) {
        [ud setObject:mobilephone forKey:@"mobilephone"];
    }
    if (sid.length>0) {
        
        [ud setObject:sid forKey:@"sid"];
        
    }
    if (icon.length>0) {
        
        [ud setObject:icon forKey:@"imagePath"];
        
    }
    [ud synchronize];
    [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
    
    [HFUserDataTools loginAtNetease:body];
    
}

+ (NSDictionary*)loginData:(id)obj {
   
    NSString *sid = [NSString stringWithFormat:@"%@",obj[@"sid"]].length == 0 ?@"":[NSString stringWithFormat:@"%@",obj[@"sid"]];
    NSString *accid = [NSString stringWithFormat:@"%@",obj[@"accid"]].length == 0 ?@"":[NSString stringWithFormat:@"%@",obj[@"accid"]];
    NSString *uid = [NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"userId"]].length == 0 ?@"":[NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"userId"]];
    NSString *mobilephone = [NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"mobilephone"]].length == 0?@"":[NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"mobilephone"]];
    NSString *icon = [NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"imagePath"]].length == 0?@"":[NSString stringWithFormat:@"%@",obj[@"userCenterInfo"][@"imagePath"]];
    NSString *token = [NSString stringWithFormat:@"%@",obj[@"token"]].length == 0 ? @"":[NSString stringWithFormat:@"%@",obj[@"token"]];
    [HFDBHandler cacheLoginData:obj[@"userCenterInfo"]];
    return @{@"accid":accid,@"sid":sid,@"uid":uid,@"mobilephone":mobilephone,@"token":token,@"imagePath":icon};
}
//只要小于2 并且登录 他就弹弹
+ (BOOL)isVip {
    return [[HFUntilTool EmptyCheckobjnil:[[HFDBHandler selectLoginData] valueForKey:@"vipLevel"]] integerValue]<2 &&[self isLogin];
}

//字典转换为json
+(NSString *)convertToJsonData:(NSDictionary *)dict{
    if (dict) {
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString;
        
        if (!jsonData) {
            
            NSLog(@"%@",error);
            
        }else{
            
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0,jsonString.length};
        
        //去掉字符串中的空格
        
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        //去掉字符串中的换行符
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        
        return mutStr;
    }
  
    return @"";
}
+ (NSString*)loginSuccess{
    if([HFDBHandler selectLoginData]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"userCenterInfo":[HFDBHandler selectLoginData]}];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"sid"] forKey:@"sid"];
        [dict setObject:@"P_TERMINAL_MOBILE_B" forKey:@"teminal"];
        [dict setObject:[[NSUserDefaults standardUserDefaults]  objectForKey:@"codeValue"]forKey:@"codeValue"];//loginAreacode
        [dict setObject:[[NSUserDefaults standardUserDefaults]  objectForKey:@"loginAreacode"] forKey:@"loginAreacode"];
        [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] forKey:@"loginName"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"";
}
+ (BOOL)isLogin {
    NSString *sid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sid"];
    return  sid.length == 0 ? NO:YES;
}
+ (NSString*)userName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
}
+ (NSString*)codeValue {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"codeValue"];
}
+ (NSString*)loginAreacode {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginAreacode"];
}
+ (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    return @"";
}
+ (void)loginAtNetease:(id)body{
    NSDictionary *dic = body;
    // 徐少
    NSString *accid = dic[@"accid"];
    NSString *token = dic[@"token"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:accid forKey:@"account"];
    [ud setObject:token forKey:@"token"];
    [ud synchronize];
    if (accid&&token) {
        [[[NIMSDK sharedSDK] loginManager] login:accid
                                           token:token
                                      completion:^(NSError *error) {
                                          if (error == nil)
                                          {
                                              LoginData *sdkData = [[LoginData alloc] init];
                                              sdkData.account   = accid;
                                              sdkData.token     = token;
                                              [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                              [[NTESServiceManager sharedManager] start];
                                              NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                              [ud setObject:accid forKey:@"account"];
                                              [ud setObject:token forKey:@"token"];
                                              [ud synchronize];
                                              
                                          }
                                      }];
    }
    
}
+(void)logout{
    [self logoutAtNetease];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobilephone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imagePath"];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
   
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:2];
    //  [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"ture" forKey:@"isLogout"];

    [HFDBHandler cacheLoginData:@{@"vipLevel":@"1"}];//退出登录 给她个免费会员

    
}
+ (void)logoutAtNetease{
    NIMContactTools *NIMTools = [NIMContactTools  shareTools];
    NIMTools.contactTab = nil;
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
        [[NTESServiceManager sharedManager] destory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}
@end
