//
//  MyOrderTableViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyOrderTableViewController.h"
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

#define ALL_ORDER @""//全部订单
#define STORE_ORDER @"P_BIZ_CATEGORY_MDD"//商城订单
#define CLOUD_ORDER @"P_BIZ_CLOUD_WAREHOUSE_ORDER"//云店
#define WORLDHOME_ORDER @"P_BIZ_CATEGORY_DD"//全球家
#define DELEGATE_ORDER @"P_BIZ_AGENT_ORDER"//代理
#define WELL_BEING_ORDER @"P_BIZ_WELFARE_ORDER"//福利
#define RM_ORDER @"P_BIZ_REGISTRATION_ORDER"//rm

@interface MyOrderTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MyOrderTableViewEmptyView *emptyView;
@property (nonatomic, strong) NSString *requestType;
@property (nonatomic, strong) NSMutableArray *arrDate;//数据源
@end

@implementation MyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"页面初始化加载%lu", (unsigned long)self.orderState);
}

- (void)setStrType:(NSString *)strType{
    _strType = strType;
    if ([strType isEqualToString:@"全部"]){
        self.requestType = ALL_ORDER;
    } else  if ([strType isEqualToString:@"商城"]){
        self.requestType = STORE_ORDER;
    } else  if ([strType isEqualToString:@"云店"]){
        self.requestType = CLOUD_ORDER;
    } else  if ([strType isEqualToString:@"全球家"]){
        self.requestType = WORLDHOME_ORDER;
    } else  if ([strType isEqualToString:@"RM注册订单"]){
        self.requestType = RM_ORDER;
    } else  if ([strType isEqualToString:@"代理订单"]){
        self.requestType = DELEGATE_ORDER;
    } else {
        //不会走到这里
    }
    
}

/**
 订单列表 接口
 */
- (void)requestFindAllOrders{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSNumber * orderState = @(0);
    if ([self.strType isEqualToString:@"全球家"]) {
        switch (self.orderState) {
            case 0:
                orderState = @(-1);
                break;
            case 1:
                orderState = @(-2);
                break;
            case 2:
                orderState = @(-3);
                break;
                
            default:
                break;
        }
    } else {
        if (self.orderState == 4) {
            //待评价传7
            orderState = @(11);
        } else {
            orderState = @(self.orderState);
        }
    }
    
    NSDictionary *dic1 = @{
                          @"sid":sid,//@"62a69330-3d6e-49f7-9e4a-a5e2e7692c5b",
                          @"pageNo":@(_currentPage),
                          @"pageSize":@"10",
                          @"orderState":orderState,
                          @"orderBizCategory":self.requestType,
                          @"terminal":@"P_TERMINAL_MOBILE"
                          };
    //http://192.168.0.107:8080
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/findAllOrders"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"orderInfoList"]];
            
            NSArray * arr = [NSArray modelArrayWithClass:[OrderInfoListModel class] json:arrInfo];
            
            if (arr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (_currentPage == 1) {
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
            NSLog(@"%@", arr);
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
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
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        //全球家订单
        NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/global/hotelDetails?hotelId=%@&startDate=%@&endDate=%@", model.hotelId,[JudgeOrderType timeStrNYR:model.bookCheckinTime], [JudgeOrderType timeStrNYR:model.checkoutTime]];
        [self pushH5ForUrl:strUrl];
    } else {
        
        ShopListViewController *shopVC = [[ShopListViewController alloc] init];
        shopVC.shopId = model.shopsId;
        [self.nvController pushViewController:shopVC animated:YES];
    }
    
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
                if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
                    [self requestGlobalCancelOrder:model.orderNo];
                } else {
                    [self requestCancelOrder:model.orderNo];
                }
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
            if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
                //全球家
                strUrl = [NSString stringWithFormat:@"/html/home/#/global/makeComment?orderNo=%@", model.orderNo];
                
            } else {
                strUrl = [NSString stringWithFormat:@"/html/home/#/mall/makeComment?orderNo=%@", model.orderNo];
            }
            [self pushH5ForUrl:strUrl];
        }
            break;
        case MyOrderFooterViewTypeGoBugAgain://再次预定
        {
            NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/global/hotelDetails?hotelId=%@&startDate=%@&endDate=%@", model.hotelId,[JudgeOrderType timeStrNYR:model.bookCheckinTime], [JudgeOrderType timeStrNYR:model.checkoutTime]];
            [self pushH5ForUrl:strUrl];
            
        }
            break;
        case MyOrderFooterViewTypeBackOut://退订
        {
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"是否退订?" suret:@"确认" closet:@"取消" sureblock:^{
                [self requestGlobalBackOutOrder:model.orderNo];
            } closeblock:^{
                
            }];
        }
            break;
        case MyOrderFooterViewTypeRefun://退款
        {
            
            NSLog(@"退款退款退款退款退款退款");
        }
            break;
      
        case MyOrderFooterViewTypeVerifyCode://核销码

        {
           
            NSLog(@"核销码核销码核销码核销码核销码核销码");
            NSString *strUrl = [NSString stringWithFormat:@"/html/house/oto/oto-orderVerification.html?orderNo=%@", model.orderNo];
            [self pushH5ForUrl:strUrl];

        }
            break;
        case MyOrderFooterViewTypeSurePS://确认收货 配送
        {
            
            NSLog(@"确认收货 配送确认收货 配送确认收货 配送");
            [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[UIApplication sharedApplication].keyWindow title:@"是否确认收货?" suret:@"确认" closet:@"取消" sureblock:^{
                [self requestSurePS:model.orderNo];
            } closeblock:^{
                
            }];

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
 付款跳转

 @param model OrderInfoListModel
 */
- (void)goToPay:(OrderInfoListModel *)model{
    NSString *webUrl = @"";
    if ([JudgeOrderType judgeStoreOrderType:model.orderBizCategory]) {//商城订单跳新的
        webUrl = [NSString stringWithFormat:@"/html/home/#/pay/order/shopping/cashier?orderNo=%@", model.orderNo];
    } else if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]){//全球家
        webUrl = [NSString stringWithFormat:@"/html/home/#/pay/order/hotel/cashier?orderNo=%@", model.orderNo];
    } else {
        //其他的跳老的收款台
        webUrl = [NSString stringWithFormat:@"/html/pay/main/cashierPay.html?orderInfoNoList=%@", model.orderNo];

    }
    
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
 取消订单 全球家订单
 
 @param orderNo 订单号
 */
- (void)requestGlobalCancelOrder:(NSString *)orderNo{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                          @"sid":sid,
                          @"orderNo":orderNo,
                          };
    NSLog(@"%@", dic1);
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/orderInfo/cancel"];
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
 退订 全球家订单
 
 @param orderNo 订单号
 */
- (void)requestGlobalBackOutOrder:(NSString *)orderNo{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                          @"sid":sid,
                          @"orderNo":orderNo,
                          @"cancelRemark":@"" //备注
                          };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/orderInfo/cancel"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"订单退订成功!"];
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
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[section];
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        
        return 70;
    } else {
        return [JudgeOrderType returnTableViewFooter:model];
    }
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
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        //全球家只有一个cell
        return 1;
    } else {
        return model.orderProductList.count;
    }
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
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        //全球家只有一个cell
        cell.infoListModel = model;
    } else {
        cell.productModel = (MyOrderProductListModel *)arr[indexPath.row];
    }
    return cell;
}

/**
 订单详情跳转
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfoListModel *model = (OrderInfoListModel *)self.arrDate[indexPath.section];
    
    if ([JudgeOrderType judgeGlobalHomeOrderType:model.orderBizCategory]) {
        NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/global/hotelorderinfo?orderNo=%@", model.orderNo];
        [self pushH5ForUrl:strUrl];
    } else {
        NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/order/mall/orderDetails?orderNo=%@", model.orderNo];
        [self pushH5ForUrl:strUrl];
    }

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
            if ([self.strType isEqualToString:@"全部"]) {
                [self requestOrderNum];
            }
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

/**
 请求代付款数量
 */
- (void)requestOrderNum{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"orderState":@(1),
                          @"orderBizCategory":self.requestType
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/countOrders"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic1 = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic1 objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSNumber *num = [[dic1 objectForKey:@"data"] objectForKey:@"count"];
            if ([num integerValue] > 0) {
                if (self.orderNumBlock) {
                    self.orderNumBlock(num);
                }
            }
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
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
 确认收货 配送

 @param orderNo 订单号
 */
- (void)requestSurePS:(NSString *)orderNo{
    [SVProgressHUD show];

    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    
    
    NSMutableDictionary *dic1 = [@{
                                   @"orderNo":orderNo
                                   } mutableCopy];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/receive/confirm"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];

        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            [self showSVProgressHUDSuccessWithStatus:@"确认收货成功!"];

            [self.tableView.mj_header beginRefreshing];
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD show];

        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
@end
