//
//  BaseNavigationController.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpBaseNavigationController.h"

@interface SpBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation SpBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
  
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
//    if ([viewController isKindOfClass:[HFPayMentViewController class]]) {
//        HFPayMentViewController *vc = (HFPayMentViewController*)viewController;
//        SpBaseNavigationController *nav = (SpBaseNavigationController*) vc.navigationController;
//        nav.navdelegate = vc;
//    }else  {
//         self.navdelegate = viewController;
//    }

}

- (void)back {
    
    if ([self.navdelegate respondsToSelector:@selector(beforePopViewController:)]) {
        [self.navdelegate beforePopViewController:self];
    }else {
        [self popViewControllerAnimated:YES];
    }
        
   
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return self.childViewControllers.count >0;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    //只有一个控制器的时候禁止手势，防止卡死现象
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if (self.childViewControllers.count > 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    //只有一个控制器的时候禁止手势，防止卡死现象
    if (self.childViewControllers.count == 1) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
