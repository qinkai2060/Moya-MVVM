//
//  AppDelegate.h
//  HeMeiHui
//
//  Created by 任为 on 16/9/19.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDGuideScrollView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GuideScrollViewDeledate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)BOOL isFull;///<是否允许自动旋转
@property(nonatomic,assign)NSInteger allowRotation;
@property(nonatomic,strong)WDGuideScrollView *guideView;



@end

