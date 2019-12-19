//
//  YunDianOrderTableViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderTableViewController.h"
#import "YunDianOrderListTableViewCell.h"
#import "YunDianOrderFooterView.h"
#import "YunDianOrderHeaderView.h"
#import "MyOrderTableViewEmptyView.h"
#import "YunDianOrderListModel.h"
#import "YunDianOrderProductsModel.h"
#import "JudgeOrderType.h"
#import "CustomPasswordAlter.h"
#import "MyJumpHTML5ViewController.h"
#import "SpMainMineViewController.h"
#import "ShopListViewController.h"
#import "YunDianOrderDetailViewController.h"
#import "YunDianRefundDetailViewController.h"
#import "UCEScanViewController.h"
#import "ManageLogisticsViewController.h"
#import "YunDianNewRefundDetailViewController.h"
@interface YunDianOrderTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MyOrderTableViewEmptyView *emptyView;
@property (nonatomic, strong) NSString *requestType;
@property (nonatomic, strong) NSMutableArray *arrDate;//数据源

@end

@implementation YunDianOrderTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
}

/**
 订单列表 接口 订单状态（1：待支付，2：待发货，3：待收货，4：退货中，5：已退货，6：已取消，7：已完成，8：已分润，9：已终止，10：已评价）
 */
- (void)requestFindAllOrders{
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSMutableDictionary *dic1 = [@{
                                   @"pageNo":@(_currentPage),
                                   @"pageSize":@(10),
                                   } mutableCopy];
    if (self.shopModel && ![self.shopModel.shopsName isEqualToString:@"全部"]) {
        [dic1 setObject:self.shopModel.shopsId forKey:@"shopsId"];
    }
    if (self.orderState  > 0 && self.orderState < 4) {
        [dic1 setObject:@(self.orderState) forKey:@"orderState"];
    }
    if (self.orderState >= 4){
        switch (self.orderState) {
            case 4:
                //退款中
                [dic1 setObject:@(1) forKey:@"returnState"];
                break;
            case 5:
                //已退款
                [dic1 setObject:@(4) forKey:@"returnState"];
                
                break;
            case 6:
                //拒绝退款
                [dic1 setObject:@(3) forKey:@"returnState"];
                
                break;
            case 7:
                //取消退款
                [dic1 setObject:@(2) forKey:@"returnState"];
                
                break;
            default:
                break;
        }
    }
    NSLog(@"销售订单请求body:%@", dic1);
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/my-shops/order-management/list"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@", utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"销售订单:%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 ) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"orderList"])) {
                NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"orderList"]];
                
                NSNumber *num = [[dic objectForKey:@"data"] objectForKey:@"waitSendGoodsCount"];
                if ([num integerValue] > 0) {
                    if (self.ydOrderNumBlock) {
                        self.ydOrderNumBlock(num);
                    }
                }
                
                
                NSArray * arr = [NSArray modelArrayWithClass:[YunDianOrderListModel class] json:arrInfo];
                
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
                    for (YunDianOrderListModel *model in arr) {
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
 头部点击方法  跳转商店 
 
 @param section 区
 */
- (void)tableViewHeaderClisckInSection:(NSInteger)section{
    NSLog(@"头部点击方法%ld",(long)section);
//    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
//
//    ShopListViewController *shopVC = [[ShopListViewController alloc] init];
//    shopVC.shopId = model.shopsId;
//    [self.nvController pushViewController:shopVC animated:YES];
//
}

/**
 footer btn 点击方法
 
 @param section 区
 @param clickType btn类型
 */
- (void)tableViewFooterClisckInSection:(NSInteger)section clickType:(YunDianOrderFooterViewTypeClick)clickType{
    
    NSLog(@"btn类型跳转%@", self.nvController);
    
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
    switch (clickType) {
            
        case YunDianOrderFooterViewTypeVerifyCode://核销
        {
            UCEScanViewController *vc = [[UCEScanViewController alloc] init];
            vc.autoGoBack = YES;
            vc.scanCodeType = ScanCodeTypeAll;
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderNo = model.orderNo;
            vc.nvController = self.nvController;
            [self.nvController presentViewController:vc animated:YES completion:nil];
            vc.complete = ^(NSString *str) {
                
                
            };
        }
            break;
        case YunDianOrderFooterViewTypeRefun://退款
            
        {
//            YunDianRefundDetailViewController *vc = [[YunDianRefundDetailViewController alloc] init];
//            vc.orderNo = model.orderNo;
//            vc.shopsType = model.shopsType;
//            vc.distribution = model.distribution;
//            if (model.orderProducts.count) {
//                YunDianOrderProductsModel *productsModel = (YunDianOrderProductsModel *)model.orderProducts[0];
//                vc.orderReturnId = productsModel.orderReturnId;
//            }
//
//            [self.nvController pushViewController:vc animated:YES];
//
//
            
            
            
            YunDianNewRefundDetailViewController *vc = [[YunDianNewRefundDetailViewController alloc] init];
            vc.orderNo = model.orderNo;
            if (model.orderProducts.count) {
                           YunDianOrderProductsModel *productsModel = (YunDianOrderProductsModel *)model.orderProducts[0];
                           vc.refundNo = productsModel.refundNo;
                       }
            [self.nvController pushViewController:vc animated:YES];
        }
            break;
        case YunDianOrderFooterViewTypeReason://查看原因
        {
//            YunDianRefundDetailViewController *vc = [[YunDianRefundDetailViewController alloc] init];
//            vc.orderNo = model.orderNo;
//            vc.shopsType = model.shopsType;
//            vc.distribution = model.distribution;
//            if (model.orderProducts.count) {
//
//                YunDianOrderProductsModel *productsModel = (YunDianOrderProductsModel *)model.orderProducts[0];
//                vc.orderReturnId = productsModel.orderReturnId;
//            }
//            [self.nvController pushViewController:vc animated:YES];
            YunDianNewRefundDetailViewController *vc = [[YunDianNewRefundDetailViewController alloc] init];
                       vc.orderNo = model.orderNo;
                       if (model.orderProducts.count) {
                                      YunDianOrderProductsModel *productsModel = (YunDianOrderProductsModel *)model.orderProducts[0];
                                      vc.refundNo = productsModel.refundNo;
                                  }
                       [self.nvController pushViewController:vc animated:YES];
        }
            break;
        case YunDianOrderFooterViewTypeDispatchGoods://发货
        {
            NSString *url = [NSString stringWithFormat:@"/html/mall/tobeshipped.html?orderNo=%@",model.orderNo];
            MyJumpHTML5ViewController *HtmlVC = [[MyJumpHTML5ViewController alloc] init];
            HtmlVC.webUrl = url;
            HtmlVC.hidesBottomBarWhenPushed=YES;
            HtmlVC.navigationController.navigationBar.hidden=YES;
            [self.nvController pushViewController:HtmlVC animated:YES];
            
        }
            break;
        case YunDianOrderFooterViewTypeViewLogistics://查看物流
        {
            ManageLogisticsViewController * logistVC = [[ManageLogisticsViewController alloc] init];
            logistVC.logisticsID = model.orderId;
            [self.nvController pushViewController:logistVC animated:YES];
        }
            break;
            
            
            
        default:
            break;
    }
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
 订单详情跳转
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[indexPath.section];
    YunDianOrderProductsModel *productsModel = (YunDianOrderProductsModel *)model.orderProducts[indexPath.row];
    
    if (self.orderState >= 4) {
        //退款售后
//        YunDianRefundDetailViewController *vc = [[YunDianRefundDetailViewController alloc] init];
//        vc.orderNo = model.orderNo;
//        vc.shopsType = model.shopsType;
//        vc.distribution = model.distribution;
//        vc.orderReturnId = productsModel.orderReturnId;
//        [self.nvController pushViewController:vc animated:YES];
        
        
        
        YunDianNewRefundDetailViewController *vc = [[YunDianNewRefundDetailViewController alloc] init];
        vc.orderNo = model.orderNo;
        vc.refundNo = productsModel.refundNo;
        [self.nvController pushViewController:vc animated:YES];
        
        
    } else {
        //正常订单
        
        YunDianOrderDetailViewController *vc = [[YunDianOrderDetailViewController alloc] init];
        vc.orderNo = model.orderNo;
        vc.commented = model.commented;
        [self.nvController pushViewController:vc animated:YES];
    }
    
}
- (void)refreshBeEmptyView{
    self.arrDate = [NSMutableArray array];
    [self.tableView reloadData];
}
- (void)refreshDate{
    [self.tableView.mj_header beginRefreshing];
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
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
    
    
    return [JudgeOrderType returnYunDianTableViewFooter:model];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YunDianOrderHeaderView *header = [[YunDianOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    WEAKSELF
    
    header.clickHeaderBlock = ^(NSInteger section) {
        [weakSelf tableViewHeaderClisckInSection:section];
    };
    header.tag = 1000 + section;
    header.state = self.orderState;
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
    header.orderListModel = model;
    return header;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
    YunDianOrderFooterView *footer = [[YunDianOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [JudgeOrderType returnYunDianTableViewFooter:model])];
    footer.state = self.orderState;
    footer.tag = 2000 + section;
    WEAKSELF
    footer.clickBlock = ^(YunDianOrderFooterViewTypeClick clickType, NSInteger section) {
        [weakSelf tableViewFooterClisckInSection:section clickType:clickType];
    };
    footer.orderListModel = model;
    return footer;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[section];
    
    return model.orderProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YunDianOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YunDianOrderListTableViewCell"];
    if (!cell) {
        cell = [[YunDianOrderListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"YunDianOrderListTableViewCell"]];
    }
    cell.state = self.orderState;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 3000 + indexPath.row;
    YunDianOrderListModel *model = (YunDianOrderListModel *)self.arrDate[indexPath.section];
    NSArray *arr = [NSArray arrayWithArray:model.orderProducts];
    cell.productsModel = (YunDianOrderProductsModel *)arr[indexPath.row];
    if ([model.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        cell.orderListModel = model;
        
    }
    return cell;
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
            //                [self requestOrderNum];
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

- (void)refreshDateNoMJ{
    if (_currentPage == 1) {
        _currentPage = 1;
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        [self requestFindAllOrders];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

@end
