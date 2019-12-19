//
//  YunDianOrderViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderViewController.h"
#import "CustomOrdeTypeSelectView.h"
#import "WRNavigationBar.h"
#import <JXCategoryView/JXCategoryView.h>
#import "YunDianOrderTableViewController.h"
#import "UIButton+CustomButton.h"
#import "HeaderView.h"
#import "CustomNaviOrderTableView.h"
@interface YunDianOrderViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,HearderViewDelegate, CustomNaviOrderTableViewDelegate>
{
    BOOL isClickMore;//是否点击了更多
}
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) JXCategoryNumberView *orderCategoryView;//我的订单
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *btnMore;
@property (nonatomic, strong) UIView *btnMoreLine;
@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) NSArray *arrMenuItems;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) CustomNaviOrderTableView *naviOrderTableView;
@property (nonatomic, strong) NSMutableArray *arrShopList;
@property (nonatomic, strong) YunDianOrderTableViewController *moreOrderController;

@property (nonatomic, strong) YunDianOrderTableViewController *currentController;//当前controller

@end

@implementation YunDianOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;

    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    if (self.currentController) {
        [self.currentController refreshDateNoMJ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    

    self.title = self.shopListModel.shopsName ?: @"全部订单";
    self.rButton.hidden = NO;
    self.arrMenuItems = @[@"退款中",@"已退款",@"拒绝退款", @"取消退款"];
    [self requestShopListIsShowpPross:NO];
    [self.view addSubview:self.orderCategoryView];
    [self createContentView];
    [self.view addSubview:self.line];
    [self btnMore];
    [self btnMoreLine];
    [self.view addSubview:self.verticalLine];
}

/**
 请求店铺列表

 @param isShow 是否加载菊花
 */
- (void)requestShopListIsShowpPross:(BOOL)isShow{
    if (isShow) {
        [SVProgressHUD show];
    }
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic1 = @{
                           @"pageNo":@(1),
                           @"pageSize":@(1),
                           };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/my-shops/order-management/list"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (isShow) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"shopsInfo"])) {
                NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"shopsInfo"]];
                
                self.arrShopList = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[YunDianShopListModel class] json:arrInfo]];
                
                NSMutableArray *arr = [NSMutableArray array];
                NSDictionary *dicall = @{
                                         @"shopsName":@"全部"
                                         };
                YunDianShopListModel *modelAll = [YunDianShopListModel modelWithJSON: dicall];
                [self.arrShopList insertObject:modelAll atIndex:0];
                for (YunDianShopListModel *model in self.arrShopList) {
                    [arr addObject:model.shopsName];
                    //根据id 取出拼接好的店铺名字
                    if ([model.shopsId isEqualToString:self.shopListModel.shopsId]) {
                        self.title = model.shopsName;
                    }
                }
                self.naviOrderTableView.arrDate = arr;
                if (isShow) {
                    self.naviOrderTableView.hidden = NO;
                }
                NSLog(@"%@", self.arrShopList);
            } else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
            
        } else {
            [self showSVProgressHUDErrorWithStatus:@"网络请求异常!"];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (isShow) {
            [SVProgressHUD dismiss];
        }
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}

/**
 HeaderView tableview点击放法

 @param headerView
 @param selectedIndex
 */
- (void)headerView:(HeaderView *)headerView didSelectMenuItemAtIndex:(NSInteger)selectedIndex{
    isClickMore = YES;
    [self btnMoreChangeState:selectedIndex];
    self.moreOrderController.shopModel = self.shopListModel;
    self.moreOrderController.orderState = selectedIndex+4;
    [self performSelector:@selector(after) withObject:nil afterDelay:0.1];
    self.currentController = self.moreOrderController;
    [self.moreOrderController refreshDate];
}

/**
 点击更多下来列表 选中后 改变的状态
 
 @param selectedIndex 第几位
 */
- (void)btnMoreChangeState:(NSInteger)selectedIndex{

    [_btnMore setTitleColor:HEXCOLOR(0x000000) forState:(UIControlStateNormal)];
    _btnMore.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_btnMore setTitle:self.arrMenuItems[selectedIndex] forState:(UIControlStateNormal)];
    [_btnMore layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    
    _orderCategoryView.titleColor = HEXCOLOR(0x333333);
    _orderCategoryView.titleSelectedColor = HEXCOLOR(0x333333);
    _orderCategoryView.titleFont = [UIFont systemFontOfSize:13];
    _orderCategoryView.titleSelectedFont = [UIFont systemFontOfSize:13];
    JXCategoryIndicatorLineView *lineView =  (JXCategoryIndicatorLineView *) _orderCategoryView.indicators[0];
    lineView.indicatorLineViewColor = [UIColor clearColor];//改变三方下划线颜色
    _btnMoreLine.hidden = NO;
    [self.orderCategoryView reloadData];
}

/**
 headerView隐藏
 */
- (void)dismissHeader{
    [_headerView dismissMenuPopover];
}

/**
 rightBarButton点击方法
 */
- (void)rightBarButtonItemAction{
    [self dismissHeader];
    if (self.arrShopList.count == 0) {
        [self requestShopListIsShowpPross:YES];
    } else {
        self.naviOrderTableView.selectStr = self.title;
    self.naviOrderTableView.hidden = !self.naviOrderTableView.hidden;
    
    }
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
            [_moreOrderController.view removeFromSuperview];
            [self changeState];
            NSString *title = @"全部订单";
           self.shopListModel  =  (YunDianShopListModel *)self.arrShopList[index];
            if (![self.shopListModel.shopsName isEqualToString:@"全部"]) {
                title = self.shopListModel.shopsName;
            }
            self.title = title;
            [self loadUrlForStr];
            NSLog(@"%ld", (long)index);
        }
            break;
            
        default:
            break;
    }
}

/**
 通过点击订单类型  刷新orderCategoryView
 */
- (void)loadUrlForStr{
    NSArray *arr  = @[@"全部",@"待付款",@"待发货",@"待收货"];//,@"待评价"
    NSArray *arrcount = @[@(0),@(0),@(0),@(0)];
    _orderCategoryView.defaultSelectedIndex = 0;
    self.listContainerView.defaultSelectedIndex = 0;
    _orderCategoryView.contentEdgeInsetLeft = WScale(20);
    _orderCategoryView.contentEdgeInsetRight = WScale(30);

    _orderCategoryView.counts = arrcount;
    
    _orderCategoryView.titles = arr;
    
    [self.listContainerView reloadData];
    [self.orderCategoryView reloadData];
}

/**
 更多按钮 点击 显示headerview

 @param btn
 */
- (void)btnMoreAction:(UIButton *)btn{
    
    [self.headerView showInView];
    
}


/**
 点击jxcetegory改变更多状态 并且刷新jxcetegory状态
 */
- (void)changeState{
    _btnMoreLine.hidden = YES;
    _orderCategoryView.titleColor = HEXCOLOR(0x333333);
    _orderCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
    _orderCategoryView.titleFont = [UIFont systemFontOfSize:13];
    _orderCategoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
    JXCategoryIndicatorLineView *lineView =  (JXCategoryIndicatorLineView *) _orderCategoryView.indicators[0];
    lineView.indicatorLineViewColor = HEXCOLOR(0xF3344A);
    [_btnMore setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    _btnMore.titleLabel.font = PFR13Font;
    [self.orderCategoryView reloadData];
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
    YunDianOrderTableViewController *order =  [[YunDianOrderTableViewController alloc] init];
    order.shopModel = self.shopListModel;
    order.orderState = index;
    order.nvController = self.navigationController;
    WEAKSELF
    order.ydOrderNumBlock = ^(NSNumber * _Nonnull num) {
        [weakSelf ydOrderNumBlock:num];
    };
    self.currentController = order;
    return order;
}
- (void)ydOrderNumBlock:(NSNumber *)num{
    NSArray *arrcount = @[@(0),@(0),num,@(0)];
    self.orderCategoryView.counts = arrcount;
    [self.orderCategoryView reloadData];
    
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    
    return 4;
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


-(JXCategoryNumberView *)orderCategoryView{
    if(!_orderCategoryView){
        //
        _orderCategoryView = [[JXCategoryNumberView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 100, 44)];
        // dele
        _orderCategoryView.delegate = self;
        // 设置菜单项标题数组
        _orderCategoryView.titles = @[@"全部",@"待付款",@"待发货",@"待收货"];//,@"待评价"
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
        _orderCategoryView.defaultSelectedIndex = 0;
        _orderCategoryView.counts = @[@(0),@(0),@(0),@(0)];
        
        _orderCategoryView.numberLabelFont = [UIFont systemFontOfSize:10];
        _orderCategoryView.numberBackgroundColor = HEXCOLOR(0xF3344A);
        _orderCategoryView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
            if (number > 99) {
                return @"99+";
            }
            return [NSString stringWithFormat:@"%ld", (long)number];
        };
        
        _orderCategoryView.contentEdgeInsetLeft = WScale(20);
        _orderCategoryView.contentEdgeInsetRight = WScale(20);
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
    self.listContainerView.defaultSelectedIndex = 0;
    
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
    
    if (isClickMore) {
        isClickMore = NO;
        [self changeState];
        
        [_moreOrderController.view removeFromSuperview];
    }
   
    
}
- (UIView *)btnMoreLine{
    if (!_btnMoreLine) {
        _btnMoreLine = [[UIView alloc] initWithFrame:CGRectMake(WScale(20), 40.5, WScale(50), 3)];
        _btnMoreLine.backgroundColor = HEXCOLOR(0xF3344A);
        _btnMoreLine.layer.cornerRadius = 1.5;
        _btnMoreLine.layer.masksToBounds = YES;
        _btnMoreLine.hidden = YES;
        [self.btnMore addSubview:_btnMoreLine];
    }
    return _btnMoreLine;
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(_orderCategoryView), ScreenW, 0.5)];
        _line.backgroundColor = RGB(175, 176, 179);
    }
    return _line;
}
- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenW - 100, 14.5, 1, 15)];
        _verticalLine.backgroundColor = HEXCOLOR(0xE5E5E5);
        
    }
    return _verticalLine;
}

- (UIButton *)btnMore{
    if (!_btnMore) {
        _btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _btnMore.frame = CGRectMake(ScreenW - 100, 0, 100, 44);
        [_btnMore setTitle:@"退款售后" forState:(UIControlStateNormal)];
        [_btnMore setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
        _btnMore.titleLabel.font = PFR13Font;
        [_btnMore addTarget:self action:@selector(btnMoreAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_btnMore setImage:[UIImage imageNamed:@"icon_sanjiao_bottom"] forState:(UIControlStateNormal)];
        [_btnMore setSelected:NO];
        _btnMore.adjustsImageWhenHighlighted =  NO;
        [self.view addSubview:_btnMore];
        [_btnMore layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    }
    return _btnMore;
    
}
- (HeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 108, 44 + IPHONEX_SAFE_AREA_TOP_HEIGHT_88, 108, 158) menuItems:self.arrMenuItems view:self.navigationController.view];
        _headerView.hearderViewDelegate = self;
        [_headerView.backGroundButton addTarget:self action:@selector(dismissHeader) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
    
}
- (CustomNaviOrderTableView *)naviOrderTableView{
    if (!_naviOrderTableView) {
        _naviOrderTableView = [[CustomNaviOrderTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenH)];
        _naviOrderTableView.hidden = YES;
        _naviOrderTableView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_naviOrderTableView];
    }
    return _naviOrderTableView;
}
- (YunDianOrderTableViewController *)moreOrderController{
    if (!_moreOrderController) {
        _moreOrderController = [[YunDianOrderTableViewController alloc] init];
        _moreOrderController.view.frame = CGRectMake( 0, 45,ScreenW,ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88 - 45);
        _moreOrderController.nvController = self.navigationController;
    }
    [_moreOrderController refreshBeEmptyView];
    return _moreOrderController;
}
- (void)after{
    [self.view addSubview:_moreOrderController.view];
}
@end
