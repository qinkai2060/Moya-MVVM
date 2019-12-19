//
//  WelfareOrderListViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WelfareOrderListViewController.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderHeaderView.h"
#import "MyOrderFooterView.h"
#import "MyOrderTableViewEmptyView.h"
#import "OrderInfoListModel.h"
#import "MyOrderProductListModel.h"
#import "JudgeOrderType.h"
#import "CustomPasswordAlter.h"
#import "MyJumpHTML5ViewController.h"
#import "SpMainMineViewController.h"
#import "ShopListViewController.h"

@interface WelfareOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MyOrderTableViewEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *arrDate;//数据源
@end

@implementation WelfareOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"页面初始化加载%lu", (unsigned long)self.orderState);
}

/**
 订单列表 接口 ALL("0", "全部"), WAIT_PAY("1", "待付款"), WAIT_SEND("2", "待发货"), WAIT_RECEIEVE("3", "待收货"), DURING_RETURN("4", "退款中"), HAS_RETURN("5", "已退货"), HAS_CANCEL("6", "已取消"), WAIT_EVALUATE("7", "已完成"), HAS_COMPLETE("8", "已完成"), HAS_OVER("9", "已终止"), HAS_EVALUATE("10", "已评价");
 */
- (void)requestFindAllOrders{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSNumber * orderState = @(0);
    
    switch (self.orderState) {
        case WelfareOrderListTypeCancle://已取消
            orderState = @(6);
            break;
        case WelfareOrderListTypeFinsh://已完成
            orderState = @(7);
            break;
        default:
            orderState = @(self.orderState);
            break;
    }
    NSDictionary *dic1 = @{
                           @"sid":sid,
                           @"pageNo":@(_currentPage),
                           @"pageSize":@"10",
                           @"orderState":orderState,
                           @"terminal":@"P_TERMINAL_MOBILE"
                           };
    NSLog(@"福利订单请求body:%@", dic1);
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/findBuyerWelfareOrder"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"])&&
                Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"orderInfoList"])) {
                
                NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"orderInfoList"]];
                
                NSArray * arr = [NSArray modelArrayWithClass:[OrderInfoListModel class] json:arrInfo];
                
                if (arr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (self.currentPage == 1) {
                    //下拉刷新
                    self.arrDate = [NSMutableArray arrayWithArray:arr];
                    
                } else {
                    //上啦加载
                    if (!arr.count) {
                        return ;
                    }
                    for (OrderInfoListModel *model in arr) {
                        [self.arrDate addObject:model];
                    }
                }
                [self.tableView reloadData];
            } else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
        } else {
            [self showSVProgressHUDErrorWithStatus:@"网络请求异常!"];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}

/**
 头部点击方法  跳转商店  全球家酒店
 
 @param section 区
 */
- (void)tableViewHeaderClisckInSection:(NSInteger)section{
    NSLog(@"头部点击方法%ld",(long)section);
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    
    ShopListViewController *shopVC = [[ShopListViewController alloc] init];
    shopVC.shopId = model.shopsId;
    [self.nvController pushViewController:shopVC animated:YES];
    
}

/**
 footer btn 点击方法
 
 @param section 区
 @param clickType btn类型
 */
- (void)tableViewFooterClisckInSection:(NSInteger)section clickType:(MyOrderFooterViewTypeClick)clickType{
    
    NSLog(@"btn类型跳转%@", self.nvController);
    
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    switch (clickType) {
        case MyOrderFooterViewTypeGoPay://付款
        {
            [self goToPay:model];
            
        }
            break;
        case MyOrderFooterViewTypeCanceloOrder://取消订单
        {
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"是否取消订单?" suret:@"确认" closet:@"取消" sureblock:^{
                
                [self requestCancelOrder:model.orderNo];
            } closeblock:^{
                
            }];
            
        }
            break;
        case MyOrderFooterViewTypeUrgeOrder://催单
        {
            NSInteger duration = [[JudgeOrderType getSystemTimeString13] integerValue] - [model.createDate integerValue];
            if (duration < 24 * 60 * 60 * 1000) {
                [self showSVProgressHUDErrorWithStatus:@"订单支付后24小时后才可催单请耐心等待!"];
                return;
            }
            [self requestReminderOrder:model.orderNo];
        }
            break;
        case MyOrderFooterViewTypeSure://确认收货
        {
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"是否确认收货?" suret:@"确认" closet:@"取消" sureblock:^{
                [self requestSureOrder:model.orderNo];
            } closeblock:^{
                
            }];
        }
            break;
        case MyOrderFooterViewTypeViewLogistics://查看物流
        {
            NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/logisticsdetail?id=%@&orderNo=%@", model.order_id,model.orderNo];
            [self pushH5ForUrl:strUrl];
        }
            break;
        case MyOrderFooterViewTypeEvaluate://评价
        {
            
            NSString *strUrl = @"";
            
            strUrl = [NSString stringWithFormat:@"/html/home/#/mall/makeComment?orderNo=%@", model.orderNo];
            
            [self pushH5ForUrl:strUrl];
        }
            break;
            
        case MyOrderFooterViewTypeDelete://删除
        {
            NSLog(@"删除删除删除删除删除");
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"是否确认删除订单?" suret:@"确认" closet:@"取消" sureblock:^{
                [self requestOrderDeleteOrderNo:model.orderNo section:section];
            } closeblock:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}
/**
 删除订单
 
 @param orderNo 订单号
 @param section 所在区
 */
- (void)requestOrderDeleteOrderNo:(NSString *)orderNo section:(NSInteger)section{
    
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSMutableDictionary *dic1 = [@{
                                   @"orderNo":orderNo
                                   } mutableCopy];
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/order/delete"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            
            [self.arrDate removeObjectAtIndex:section];
            [self.tableView reloadData];
            
            //            [self.tableView.mj_header beginRefreshing];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}

/**
 付款跳转
 
 @param model OrderInfoListModel
 */
- (void)goToPay:(OrderInfoListModel *)model{
    NSString *webUrl  = [NSString stringWithFormat:@"/html/home/#/pay/order/shopping/cashier?orderNo=%@", model.orderNo];
    [self pushH5ForUrl:webUrl];
}
/**
 跳转h5
 
 @param url web链接
 */
- (void)pushH5ForUrl:(NSString *)url{
    NSLog(@"%@", self.navigationController);
    MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
    HtmlVC.webUrl = url;
    [self.nvController pushViewController:HtmlVC animated:YES];
}
/**
 //确认收货
 
 @param orderNo 订单号
 */
- (void)requestSureOrder:(NSString *)orderNo{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                           @"sid":sid,
                           @"orderNo":orderNo,
                           };
    NSLog(@"%@", dic1);
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/receiveConfirm"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"收货成功!"];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}


/**
 取消订单 非全球家订单
 
 @param orderNo 订单号
 */
- (void)requestCancelOrder:(NSString *)orderNo{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                           @"sid":sid,
                           @"orderNo":orderNo,
                           };
    NSLog(@"%@", dic1);
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/cancelOrder"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"订单取消成功!"];
            [self.tableView.mj_header beginRefreshing];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}

/**
 我要催单
 
 @param orderNo 订单号
 */
- (void)requestReminderOrder:(NSString *)orderNo{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                           @"sid":sid,
                           @"orderNo":orderNo,
                           };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/reminderOrder"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"催单成功，请耐心等待"];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}


#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.emptyView.hidden = self.arrDate.count ? YES : NO;
    return self.arrDate.count;
}
- (MyOrderTableViewEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [MyOrderTableViewEmptyView showMyOrderTableViewEmptyViewInSuperView:_tableView];
    }
    return _emptyView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
//    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
//        
        return 70;
//    } else {
//        return [JudgeOrderType returnTableViewFooter:model];
//    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MyOrderHeaderView *header = [[MyOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    WEAKSELF
    header.clickBlock = ^(NSInteger section) {
        [weakSelf tableViewHeaderClisckInSection:section];
    };
    header.tag = 1000 + section;
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    header.infoListModel = model;
    return header;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat height = 0.f;
    
    
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        
        height = 70;
    } else {
        height = [JudgeOrderType returnTableViewFooter:model];
    }
    
    
    MyOrderFooterView *footer = [[MyOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, height)];
    footer.tag = 2000 + section;
    WEAKSELF
    footer.clickBlock = ^(MyOrderFooterViewTypeClick clickType, NSInteger section) {
        [weakSelf tableViewFooterClisckInSection:section clickType:clickType];
    };
    footer.infoListModel = model;
    return footer;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    
    return model.orderProductList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    if (!cell) {
        cell = [[MyOrderTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"MyOrderTableViewCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 3000 + indexPath.row;
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[indexPath.section];
    NSArray *arr = [NSArray arrayWithArray:model.orderProductList];
    
    cell.productModel = (MyOrderProductListModel *)arr[indexPath.row];
    
    return cell;
}

/**
 订单详情跳转
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[indexPath.section];
    
    
//    NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/my/purchase/orderDetails?orderNo=%@", model.orderNo];
    NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/my/purchase/orderDetails?orderNo=%@", model.orderNo];

    [self pushH5ForUrl:strUrl];
    
}

- (UIView *)listView {
    return self.view;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenHeight - 44 - IPHONEX_SAFE_AREA_TOP_HEIGHT_122) style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            self.tableView.mj_footer.state = MJRefreshStateIdle;
            [self requestFindAllOrders];
        }];
        // 上拉刷新
        _tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            _currentPage++;
            [self requestFindAllOrders];
        }];
        //解决tableview上啦加载的问题tableview上移的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        footerView.backgroundColor = HEXCOLOR(0xF5F5F5);
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}
@end
