//
//  WARFloatWindowManager.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/5.
//

#import "WARFloatWindowManager.h"
#import "HKTransitionPop.h"
#import "NSObject+VC.h"

@interface WARFloatWindowManager()<UINavigationControllerDelegate>

@end

@implementation WARFloatWindowManager

#pragma mark - 单例

+ (instancetype)shared{
    static WARFloatWindowManager * floatWindowManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建
        floatWindowManager = [[super allocWithZone:nil] init];
        
        //导航控制器代理
        [floatWindowManager war_currentNavigationController].delegate = floatWindowManager;
    });
    return floatWindowManager;
}

+(id)allocWithZone:(NSZone *)zone{
    return [WARFloatWindowManager shared];
}

-(id)copyWithZone:(NSZone *)zone{
    return [WARFloatWindowManager shared];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [WARFloatWindowManager shared];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:NSClassFromString(@"WARFriendCycleViewController")]) {
        HKTransitionPop *transition = [[HKTransitionPop alloc]init];
        return transition;
    } else{
        return nil;
    }
}


#pragma mark - Private

#pragma mark - Setter And Getter


@end
