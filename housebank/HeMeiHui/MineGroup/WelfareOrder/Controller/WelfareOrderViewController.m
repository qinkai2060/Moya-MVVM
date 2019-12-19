//
//  WelfareOrderViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WelfareOrderViewController.h"
#import "CustomCategoryView.h"
#import "WelfareOrderListViewController.h"

@interface WelfareOrderViewController ()<CustomCategoryViewDelegate>
@property (nonatomic, strong) CustomCategoryView *categoryView;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSMutableArray *arrController;
@end

@implementation WelfareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.categoryView];
    [self createViewController];
    [self addChildViewController:(WelfareOrderListViewController *)self.arrController[0]];
    [self.view addSubview:((WelfareOrderListViewController *)self.arrController[0]).view];
    self.currentVC = (WelfareOrderListViewController *)self.arrController[0];
    
}
- (void)didSelectCustomCategoryViewDelegateTilte:(NSString *)title index:(NSInteger)index{
    if (self.currentVC == (WelfareOrderListViewController *)self.arrController[index]) {
        return;
    } else {
        if (![self.arrController[index] isMemberOfClass:[WelfareOrderListViewController class]]) {
            WelfareOrderListViewController *order = [[WelfareOrderListViewController alloc] init];
            [order.view setFrame:CGRectMake(0, 45, ScreenW , ScreenH - 45)];
            order.nvController = self.nvController;
            order.orderState = index;
            self.arrController[index] = order;
        }
        [self replaceController:self.currentVC newController:(WelfareOrderListViewController *)self.arrController[index]];
        
    }
}
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        } else {
            self.currentVC = oldController;
        }
    }];
}
- (CustomCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[CustomCategoryView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
        _categoryView.delegate = self;
    }
    return _categoryView;
}
- (void)createViewController{
    self.arrController = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {//共6种订单类型
        if (i == 0) {
            WelfareOrderListViewController *order = [[WelfareOrderListViewController alloc] init];
            [order.view setFrame:CGRectMake(0, 45, ScreenW, ScreenH - 45)];
            order.orderState = WelfareOrderListTypeAll;
            order.nvController = self.nvController;
            [self.arrController addObject:order];
        } else {
            [self.arrController addObject:@"先不创建"];
        }
    }
}

- (UIView *)listView {
    return self.view;
}

@end
