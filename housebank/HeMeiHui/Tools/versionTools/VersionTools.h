//
//  VersionTools.h
//  HeMeiHui
//
//  Created by 任为 on 2016/10/17.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SFHFKeychainUtils.h"
#define IOS9_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

#define IOS8_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define IOS7_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define IOS6_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )

#define IOS5_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )

#define IOS4_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )

#define IOS3_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )



#define IS_IPAD         (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)


@interface VersionTools : NSObject

+ (NSString *)osVersion;
+ (NSString *)appVersion;
+ (NSString *)UUIDString;
+ (NSDictionary*)InfoDic;
+ (NSString *)iphoneType;
+ (NSString *)appBoundleID;
@end
