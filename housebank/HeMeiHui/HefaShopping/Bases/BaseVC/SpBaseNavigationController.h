//
//  BaseNavigationController.h
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpBaseNavigationController;
@protocol SpBaseNavigationControllerDelegate<NSObject>
- (void)beforePopViewController:(SpBaseNavigationController*)viewcontroller;
@end
@interface SpBaseNavigationController : UINavigationController
@property(nonatomic,weak)id <SpBaseNavigationControllerDelegate> navdelegate;
@end
