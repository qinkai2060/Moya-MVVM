//
//  HKFloatManager.m
//  WeChatFloat
//
//  Created by HeiKki on 2018/6/6.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKFloatManager.h"
#import "HKTransitionPush.h"
#import "HKTransitionPop.h"
#import "WARMacros.h"
#import "NSObject+VC.h"
#import <objc/runtime.h>

#define kVideoWindowWidth   155
#define kVideoWindowHeight   100

#define userLogoutSuccessNotification @"userLogoutSuccessNotification"
#define kWARUserDidLogoutNotification @"kWARUserDidLogoutNotification"

@interface HKFloatManager()<HKFloatBallDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *tempFloatViewController;
@property (nonatomic, assign) BOOL showFloatBall;
@property (nonatomic, strong) NSMutableArray<NSString *> *floatVcClass;
@property (nonatomic, strong) WARPlayerController *currentPlayer;

/** <#Description#> */
@property (nonatomic, strong) UIWindow *showWindow;
@end
@implementation HKFloatManager

+ (instancetype)shared{
    static HKFloatManager * floatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatManager = [[super allocWithZone:nil] init];
        floatManager.floatVcClass = [NSMutableArray array];
        [floatManager war_currentNavigationController].delegate = floatManager;
        
        [kNotificationCenter addObserver:self selector:@selector(dismiss) name:userLogoutSuccessNotification object:nil];
//        [kNotificationCenter addObserver:self selector:@selector(dismiss) name:kWARUserDidLogoutNotification object:nil];
        
        floatManager.showWindow = kKeyWindow;//[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        floatManager.showWindow.windowLevel = UIWindowLevelAlert;// + 1;
        
    });
    return floatManager;
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

+ (void)addFloatVcs:(NSArray<NSString *>*)vcClass{
    [vcClass enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![[HKFloatManager shared].floatVcClass containsObject:obj]) {     
            [[HKFloatManager shared].floatVcClass addObject:obj];
        }
    }];
}

- (void)addPlayer:(WARPlayerController *)player {
    self.currentPlayer = player;
    
}

- (void)showSmallVideoWindow {
    self.showFloatBall = YES;
    
    if ([self.floatVcClass containsObject:NSStringFromClass([[self war_currentViewController] class])]){
        self.tempFloatViewController = [self war_currentViewController];
    }
    
    if (self.showFloatBall) {
        self.floatViewController = self.tempFloatViewController;
        self.floatBall.alpha = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.showWindow addSubview:self.floatBall];
        });
    }
}

- (void)showSmallWindow {
    
    [self.showWindow addSubview:self.floatBall];
    
    //    self.showFloatBall = YES;
//
//    if (self.showFloatBall) {
//        self.floatBall.alpha = 1;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.showWindow addSubview:self.floatBall];
//        });
//    }
}


- (void)showSmallVideoWindow:(UIView *)view {
    self.showFloatBall = YES;
    
    if ([self.floatVcClass containsObject:NSStringFromClass([[self war_currentViewController] class])]){
        self.tempFloatViewController = [self war_currentViewController];
    }
    
    if (self.showFloatBall) {
        self.floatViewController = self.tempFloatViewController;
        self.floatBall.alpha = 1;
        [self.floatBall addSubview:view];
        view.frame = self.floatBall.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.showWindow addSubview:self.floatBall];
        });
    }
}

- (void)dismissSmallVideoWindow {
    [self.currentPlayer stop];
    self.tempFloatViewController = nil;
    self.floatViewController = nil;
    [self.floatBall removeFromSuperview];
    self.floatBall = nil;
}

+ (void)dismiss {
    [[self shared] dismissSmallVideoWindow];
}

#pragma mark - HKFloatBallDelegate

- (void)floatBallClose:(HKFloatBall *)floatBall {
    [self dismissSmallVideoWindow];
}

- (void)floatBallDidClick:(HKFloatBall *)floatBall{
    [[self war_currentNavigationController] pushViewController:self.floatViewController animated:YES];
    [self dismissSmallVideoWindow];
}

- (void)floatBallFullScreen:(HKFloatBall *)floatBall {
//    [self.currentPlayer enterFullScreen:YES animated:YES];
    [self.currentPlayer enterLandscapeFullScreen:UIDeviceOrientationLandscapeLeft animated:YES];
}

- (void)floatBallBeginMove:(HKFloatBall *)floatBall{
 
}

-(void)floatBallEndMove:(HKFloatBall *)floatBall{

}

#pragma UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    
//    UIViewController *vc  = self.floatViewController;
//    if (vc) {
//        if(operation==UINavigationControllerOperationPush){
//            if (toVC != vc) {
//                return nil;
//            }
//            HKTransitionPush *transition = [[HKTransitionPush alloc]init];
//            return transition;
//        }else if(operation==UINavigationControllerOperationPop){
//            if (fromVC != vc) {
//                return nil;
//            }
//            HKTransitionPop *transition = [[HKTransitionPop alloc]init];
//            return transition;
//        }else{
//            return nil;
//        }
//    }else{
//        return nil;
//    }

    if (operation == UINavigationControllerOperationPop) {
        if ([toVC isKindOfClass:NSClassFromString(@"WARFriendCycleViewController")]) {
            HKTransitionPop *transition = [[HKTransitionPop alloc]init];
            return transition;
        } else{
            return nil;
        }
    } else{
        return nil;
    }
}

#pragma mark - Setter 

- (void)setShowFloatBall:(BOOL)showFloatBall{
    _showFloatBall = showFloatBall;
}

#pragma mark - Lazy

-(HKFloatBall *)floatBall{
    if (!_floatBall) {
        _floatBall = [[HKFloatBall alloc]initWithFrame:CGRectMake(kScreenWidth - kVideoWindowWidth - 15, kScreenHeight - kVideoWindowHeight - kSafeAreaBottom - 15, kVideoWindowWidth, kVideoWindowHeight)];
        _floatBall.delegate = self;
    };
    return _floatBall;
}

+(id)allocWithZone:(NSZone *)zone{
    return [HKFloatManager shared];
}

-(id)copyWithZone:(NSZone *)zone{
    return [HKFloatManager shared];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [HKFloatManager shared];
}

@end
