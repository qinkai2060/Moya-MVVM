//
//  HFDefine.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#ifndef HFDefine_h
#define HFDefine_h

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kFONT(FontSize)      SYSTEM_VERSION_LESS_THAN(@"9") ? [UIFont systemFontOfSize:FontSize]:[UIFont fontWithName:@"PingFangSC-Regular" size:FontSize]
#define kFONT_BOLD(FontSize)      SYSTEM_VERSION_LESS_THAN(@"9") ? [UIFont systemFontOfSize:FontSize]:[UIFont fontWithName:@"PingFangSC-Medium" size:FontSize]
//状态栏的高度
#define STATUSBAR_HEIGHT (IS_IPHONE_X()) ? 44.0 : 20.0

//导航栏的高度
#define NAVBAR_HEIGHT  (IS_IPHONE_X()) ? 44.0 : 44.0

//状态栏 + 导航栏 的高度
#define  STATUSBAR_NAVBAR_HEIGHT  ((STATUSBAR_HEIGHT) + (NAVBAR_HEIGHT))

// 屏幕宽高
#define SCREEN_HEIGHT            [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH             [[UIScreen mainScreen] bounds].size.width
#define SCREEN_SIZE             [[UIScreen mainScreen] bounds].size


static inline BOOL IS_IPHONE_X() {
    
    if (CGSizeEqualToSize(SCREEN_SIZE, CGSizeMake(375, 812))) {
        return YES;
    }
    if (CGSizeEqualToSize(SCREEN_SIZE, CGSizeMake(812, 375))) {
        return YES;
    }
    if (CGSizeEqualToSize(SCREEN_SIZE, CGSizeMake(414, 896))) {
        return YES;
    }
    if (CGSizeEqualToSize(SCREEN_SIZE, CGSizeMake(896, 414))) {
        return YES;
    }
    return NO;
}

#endif /* HFDefine_h */
