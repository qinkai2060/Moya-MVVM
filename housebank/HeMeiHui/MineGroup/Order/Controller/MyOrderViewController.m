//
//  MyOrderViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "MyOrderViewController.h"
#import "NavigationBarTitleView.h"
#import "CustomOrdeTypeSelectView.h"
#import "WRNavigationBar.h"
#import <JXCategoryView/JXCategoryView.h>
#import "MyOrderTableViewController.h"
#import "CustomNaviOrderTableView.h"
@interface MyOrderViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate, CustomNaviOrderTableViewDelegate>

@property (nonatomic, strong) JXCategoryNumberView *orderCategoryView;//我的订单
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) NSString *strType;//订单类型
@property (nonatomic, strong)CustomNaviOrderTableView * naviOrderTableView;
@end

@implementation MyOrderViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_orderCategoryView), ScreenW, 0.5)];
        _line.backgroundColor = RGB(175, 176, 179);
    }
    return _line;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"全部订单";
    self.strType = @"全部";
    self.rButton.hidden = NO;
    [self.view addSubview:self.orderCategoryView];
    [self createContentView];
    [self.view addSubview:self.line];
}
-(JXCategoryNumberView *)orderCategoryView{
    if(!_orderCategoryView){
        //
        _orderCategoryView = [[JXCategoryNumberView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        // dele
        _orderCategoryView.delegate = self;
        // 设置菜单项标题数组
        _orderCategoryView.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
        // 背景色
        _orderCategoryView.backgroundColor = [UIColor whiteColor];
        // 标题色、标题选中色、标题字体、标题选中字体
        _orderCategoryView.titleColor = HEXCOLOR(0x333333);
        _orderCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _orderCategoryView.titleFont = [UIFont systemFontOfSize:13];
        _orderCategoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
        // 标题色是否渐变过渡
        _orderCategoryView.titleColorGradientEnabled = YES;
        _orderCategoryView.numberLabelOffset = CGPointMake(9, 0);
        _orderCategoryView.defaultSelectedIndex = self.type;
        _orderCategoryView.counts = @[@(0),@(0),@(0),@(0),@(0)];

        _orderCategoryView.numberLabelFont = [UIFont systemFontOfSize:10];
        _orderCategoryView.numberBackgroundColor = HEXCOLOR(0xF3344A);
        _orderCategoryView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
            if (number > 99) {
                return @"99+";
            }
            return [NSString stringWithFormat:@"%ld", (long)number];
        };
        
        _orderCategoryView.contentEdgeInsetLeft = 20;
        _orderCategoryView.contentEdgeInsetRight = 20;
        // 下划线
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        // 下划线颜色
        lineView.indicatorLineViewColor = HEXCOLOR(0xF3344A);
        lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
        _orderCategoryView.indicators = @[lineView];
        
    }
    
    return _orderCategoryView;
}
- (void)createContentView {
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.listContainerView];
    self.listContainerView.defaultSelectedIndex = self.type;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.orderCategoryView.mas_bottom);
        
    }];
    [self.view layoutIfNeeded];
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.orderCategoryView.contentScrollView = self.listContainerView.scrollView;
    
    [self.orderCategoryView reloadData];
    [self.listContainerView reloadData];
    
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    
}

//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
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
    MyOrderTableViewController *order =  [[MyOrderTableViewController alloc] init];
    order.orderState = index;
    order.strType = self.strType;
    order.nvController = self.navigationController;
    WEAKSELF
    order.orderNumBlock = ^(NSNumber * _Nonnull num) {
        [weakSelf orderNumBlock:num];
    };
    return order;
}
- (void)orderNumBlock:(NSNumber*)num{
    NSArray *arrcount = @[@(0),num,@(0),@(0),@(0)];
    self.orderCategoryView.counts = arrcount;
    [self.orderCategoryView reloadData];

}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    if ([self.strType isEqualToString: @"全球家"]) {
        return 3;
    }
    return 5;
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


- (void)rightBarButtonItemAction{
    self.naviOrderTableView.selectStr = self.title;
    self.naviOrderTableView.hidden = !self.naviOrderTableView.hidden;
}
/**
 选择订单类型
 
 @param clickType 点击类型
 @param index cell点击的.row
 */
-(void)customNaviOrderTableViewDelegateType:(CustomNaviOrderTableViewClickType)clickType index:(NSInteger)index{
    switch (clickType) {
        case CustomNaviOrderTableViewClickClose://空白处点击
        {
            self.naviOrderTableView.hidden = YES;
        }
            break;
        case CustomNaviOrderTableViewClickTableSelect://cell点击
        {
            self.naviOrderTableView.hidden = YES;
            
            [self loadUrlForStr:self.titleArr[index]];
            if ([self.titleArr[index] isEqualToString:@"全部"]) {
                self.title = @"全部订单";
            } else {
                self.title = self.titleArr[index];
            }
            NSLog(@"%ld", index);
        }
            break;
            
        default:
            break;
    }
}
- (CustomNaviOrderTableView *)naviOrderTableView{
    if (!_naviOrderTableView) {
        _naviOrderTableView = [[CustomNaviOrderTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenH)];
        _naviOrderTableView.hidden = YES;
        _naviOrderTableView.delegate = self;
        _naviOrderTableView.arrDate = self.titleArr;
        [[UIApplication sharedApplication].keyWindow addSubview:_naviOrderTableView];
    }
    return _naviOrderTableView;
}
- (void)loadUrlForStr:(NSString *)str{
    NSArray *arr  = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    NSArray *arrcount = @[@(0),@(0),@(0),@(0),@(0)];
    _orderCategoryView.defaultSelectedIndex = 0;
    self.listContainerView.defaultSelectedIndex = 0;
    _orderCategoryView.contentEdgeInsetLeft = 20;
    _orderCategoryView.contentEdgeInsetRight = 20;
    self.strType = str;
    if ([str isEqualToString:@"全部"]){

    } else  if ([str isEqualToString:@"商城"]){
        
    } else  if ([str isEqualToString:@"云店"]){
        
    } else  if ([str isEqualToString:@"全球家"]){
        arr = @[@"全部",@"进行中",@"已结束"];
        arrcount =  @[@(0),@(0),@(0)];
        _orderCategoryView.contentEdgeInsetLeft = WScale(60);
        _orderCategoryView.contentEdgeInsetRight = WScale(60);
    } else  if ([str isEqualToString:@"RM注册订单"]){
        
    } else  if ([str isEqualToString:@"代理订单"]){
        
    } else {
        //不会走到这里
    }
    _orderCategoryView.counts = arrcount;

    _orderCategoryView.titles = arr;
    
    [self.listContainerView reloadData];
    [self.orderCategoryView reloadData];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



@end
