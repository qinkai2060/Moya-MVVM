//
//  Macros.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 Insect. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define KEYWINDOW  [UIApplication sharedApplication].keyWindow
#define UserInfoData [DCUserInfo findAll].lastObject
//-------常用值 设计图以iPhone6设计为准---------------------------//
#define YQP(x) (x*2*ScreenW/750.0)
/*****************  屏幕适配  ******************/
#define iphone6p (ScreenH == 763)
#define iphone6 (ScreenH == 667)
#define iphone5 (ScreenH == 568)
#define iphone4 (ScreenH == 480)
/** 判断设备是否为iphoneX */
#define IS_iPhoneX isIPhoneX()
/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
/** 系统的状态栏高度 */
#define StatusBarHeight (CGFloat)[[UIApplication sharedApplication] statusBarFrame].size.height
/** 导航栏高度 */
#define KNavBarHeight 44.0
/** 状态栏和导航栏总高度 */
#define KTopHeight (CGFloat)(StatusBarHeight + KNavBarHeight)
/** TabBar高度 */
#define TabBarHeight (CGFloat)(IS_iPhoneX ? (49.f+34.f) : 49.f)
/** 顶部安全区域远离高度 */
#define KTopBarSafeHeight (CGFloat)(IS_iPhoneX ?(44):(20))
/** 底部安全区域远离高度 */
#define KBottomSafeHeight (CGFloat)(IS_iPhoneX ?(34):(0))
/** iPhoneX的状态栏高度差值 */
#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define Is_Kind_Of_NSDictionary_Class(V) [(V) isKindOfClass:[NSDictionary class]]

#define Is_Kind_Of_NSArray_Class(V) [(V) isKindOfClass:[NSArray class]]

#define Is_Kind_Of_NSString_Class(V) [(V) isKindOfClass:[NSString class]]
/** 空字符串检测 */
#define CHECK_STRING(a) ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"(null)"]  ? @"" : ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"<null>"] ? @"" : ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"null"] ? @"" : a)))
#define CHECK_STRING_ISNULL(a)([[NSString stringWithFormat:@"%@",a] isEqualToString:@"(null)"]  ? YES : ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"<null>"] ? YES : ([[NSString stringWithFormat:@"%@",a] isEqualToString:@"null"] ? YES : NO)))
/** 色值 */
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define KLineGrayColor      RGBCOLOR(228.f, 228.f, 228.f)
#define KBackgroundColor    [UIColor colorOfHex:0xf6f6f6]
#define KDarkTextColor      [UIColor colorOfHex:0x333333]
#define KGrayTextColor      [UIColor colorOfHex:0x999999]
/** 全局背景色 */
#define DCBGColor RGB(245,245,245)
/*****************  字体适配  ******************/
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"
#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR24Font [UIFont fontWithName:PFR size:24];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR17Font [UIFont fontWithName:PFR size:17];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];
#define PFR8Font [UIFont fontWithName:PFR size:8];
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define KIsiPhoneX ((int)((ScreenH/ScreenW)*100) == 216) ? YES : NO
#define IPHONEX_SAFE_AREA_TOP_HEIGHT_88 ((KIsiPhoneX)? (88) : (64))
#define IPHONEX_SAFE_AREA_TOP_HEIGHT_122 ((KIsiPhoneX)? (122) : (64))
#define IPHONEX_SAFEAREA ((KIsiPhoneX)? (44) : (20))

//获取当前版本号
#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//获取当前版本的biuld
#define BIULD_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//获取当前设备的UDID
#define DIV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define KeyWindow [UIApplication sharedApplication].keyWindow
// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]
//app主体颜色
#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]
#define USERDEFAULT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define objectOrNull(obj) ((obj) ? (obj) : [NSNull null])
#define objectOrEmptyStr(obj) ((obj != nil) ? (obj) : @"")
#define objectOrEmptyNSNumber(obj) ((obj) ? (obj) : @0)

static inline BOOL isIPhoneX() {
    BOOL iPhoneX = NO;
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    
    return iPhoneX;
}

#endif /* Macros_h */

