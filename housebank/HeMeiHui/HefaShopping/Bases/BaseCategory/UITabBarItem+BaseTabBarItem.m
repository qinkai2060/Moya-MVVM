//
//  UITabBarItem+BaseTabBarItem.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "UITabBarItem+BaseTabBarItem.h"
#define IOS_VERSION_MIN_REQUIRED_7  ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0]intValue] >= 7)
@implementation UITabBarItem (BaseTabBarItem)
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UITabBarItem *tabBarItem = nil;
    
    
    if (IOS_VERSION_MIN_REQUIRED_7) {
        
        // 关于UITabbarItem在 iOS 8 上显示不知道哪里来的蓝色并且模糊的问题解决办法
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
        
    } else {
        
        tabBarItem = [[UITabBarItem alloc] init];
        
        tabBarItem.title = title;
        
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:image];
    }
    
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -2.0)];
    
    return tabBarItem;
}
@end
