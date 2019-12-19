//
//  WelfareViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WelfareViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "WRNavigationBar.h"
#import "WelfareGoodsListViewController.h"
#import "WelfareOrderViewController.h"
@interface WelfareViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryNumberView *welfareCategoryView;//福利订单
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation WelfareViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationItem.titleView = self.welfareCategoryView;
    [self createContentView];
}

-(JXCategoryNumberView *)welfareCategoryView{
    if(!_welfareCategoryView){
        //
        _welfareCategoryView = [[JXCategoryNumberView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        // dele
        _welfareCategoryView.delegate = self;
        // 设置菜单项标题数组
        _welfareCategoryView.titles = @[@"福利商品",@"福利订单"];//,@"待评价"
        // 背景色
        _welfareCategoryView.backgroundColor = [UIColor whiteColor];
        // 标题色、标题选中色、标题字体、标题选中字体
        _welfareCategoryView.titleColor = HEXCOLOR(0x333333);
        _welfareCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _welfareCategoryView.titleFont = [UIFont systemFontOfSize:13];
        _welfareCategoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
        // 标题色是否渐变过渡
        _welfareCategoryView.titleColorGradientEnabled = YES;
        _welfareCategoryView.numberLabelOffset = CGPointMake(9, 0);
        _welfareCategoryView.defaultSelectedIndex = 0;
        
    
        // 下划线
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        // 下划线颜色
        lineView.indicatorLineViewColor = HEXCOLOR(0xF3344A);
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
        _welfareCategoryView.indicators = @[lineView];
        
    }
    
    return _welfareCategoryView;
}
//传递scrolling事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}


#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}
- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    if (index == 0) {
        WelfareGoodsListViewController *goods = [[WelfareGoodsListViewController alloc] init];
        goods.nvController = self.navigationController;
        return goods;
    } else {
        WelfareOrderViewController *order = [[WelfareOrderViewController alloc] init];
        order.nvController = self.navigationController;
        return order;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {

    return 2;
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)createContentView {
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.listContainerView];
    self.listContainerView.defaultSelectedIndex = 0;
//    self.listContainerView.scrollView.scrollEnabled = NO;
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.welfareCategoryView.contentScrollView = self.listContainerView.scrollView;
    
    [self.welfareCategoryView reloadData];
    [self.listContainerView reloadData];
    
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
}

//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
    

    
}
@end
