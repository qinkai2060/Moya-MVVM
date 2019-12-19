//
//  YunDianOrderDetailViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianOrderDetailViewController.h"
#import "YunDianOrderDetailTableViewCell.h"
#import "YunDianOrderDetailHeaderView.h"
#import "YunDianOrderDetailFooterView.h"
#import "YunDianDetailBottomView.h"
#import "YunDianOrderListDetailModel.h"
#import "WRNavigationBar.h"
#import "ManageLogisticsViewController.h"
#import "JudgeOrderType.h"
#import "UCEScanViewController.h"
#import "MyJumpHTML5ViewController.h"

@interface YunDianOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource, YunDianDetailBottomViewDelegate, YunDianOrderDetailHeaderViewClickDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YunDianDetailBottomView *detailBottomView;
@property (nonatomic, strong) YunDianOrderListDetailModel *detailModel;
@property (nonatomic, strong) NSDictionary *dic_wl;//物流信息
@end

@implementation YunDianOrderDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView.mj_header beginRefreshing];

    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self.view addSubview:self.tableView];

//    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.detailBottomView];
}

/**
 订单详情接口
 */
- (void)requestYDOrderDetail{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                           @"orderNo":self.orderNo
                           };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/details"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 ) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) && Is_Kind_Of_NSDictionary_Class([[dic objectForKey:@"data"] objectForKey:@"productOrderInfo"])) {
                NSDictionary *dicData = [[dic objectForKey:@"data"] objectForKey:@"productOrderInfo"];
                
                self.detailModel = [YunDianOrderListDetailModel modelWithJSON:dicData];
                
                if([JudgeOrderType returnYunDianDetailTableViewHeaderHeight:self.detailModel] == 220){
                    //有物流的情况下请求
                    [self requestViewLogistics];
                } else {
                    [self.tableView.mj_header endRefreshing];
                    
                    [self refrenshUI];
                }
            } else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
            
            
        } else {
            [self.tableView.mj_header endRefreshing];
            [self showSVProgressHUDErrorWithStatus:@"网络请求异常!"];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}

/**
 刷新ui
 */
- (void)refrenshUI{
    //判断是否下方展示操作按钮view 及其frame调整
    if ([JudgeOrderType returnYunDianDetailTableViewFooter:self.detailModel]) {
        self.tableView.frame =  CGRectMake(0, 0, ScreenW, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50);
        self.detailBottomView.hidden = NO;
        [self.detailBottomView yunDianDetailBottomViewBtnShow:self.detailModel];
    } else {
        self.tableView.frame =  CGRectMake(0, 0, ScreenW, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_122);
        self.detailBottomView.hidden = YES;
    }
    [self.tableView reloadData];
}
//物流信息
- (void)requestViewLogistics{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic1 = @{
                           @"id":self.detailModel.wl_id
                           };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/m/retail/order/view/logistics"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl, sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 &&
            Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
            Is_Kind_Of_NSDictionary_Class([[dic objectForKey:@"data"] objectForKey:@"orderDeliverGoods"]) &&
            Is_Kind_Of_NSString_Class([[[dic objectForKey:@"data"] objectForKey:@"orderDeliverGoods"] objectForKey:@"logisticsData"])) {
            
            NSDictionary*dicV = [self dictionaryWithJsonString:[[[dic objectForKey:@"data"] objectForKey:@"orderDeliverGoods"] objectForKey:@"logisticsData"]];
            if (Is_Kind_Of_NSDictionary_Class([dicV objectForKey:@"showapi_res_body"]) &&
                Is_Kind_Of_NSArray_Class([[dicV objectForKey:@"showapi_res_body"]objectForKey:@"data"])) {
                NSArray *arr = [NSArray arrayWithArray:[[dicV objectForKey:@"showapi_res_body"]objectForKey:@"data"]];
                if (arr.count) {
                    self.dic_wl = arr[0];
                }
            }
            
            
            NSLog(@"%@", dicV);
            
        } else if ([[dic objectForKey:@"state"] integerValue] == 2) {
            
            //没有物流信息
            NSLog(@"%@", [dic objectForKey:@"msg"]);
            
            
        } else {
            NSLog(@"%@", [dic objectForKey:@"msg"]);
            
        }
        [self refrenshUI];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self refrenshUI];
        [self.tableView.mj_header endRefreshing];
        
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
        
    }];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil || CHECK_STRING_ISNULL(jsonString)) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 查看物流
 */
- (void)yunDianOrderDetailHeaderViewClickDelegateViewLogistics{
    NSLog(@"查看物流");
    
    ManageLogisticsViewController * logistVC = [[ManageLogisticsViewController alloc]init];
    logistVC.logisticsID = self.detailModel.wl_id;
    [self.navigationController pushViewController:logistVC animated:YES];
}

/**
 最下放操作按钮方法
 
 @param ClickType 点击类型
 */
- (void)yunDianDetailBottomViewBtnClickType:(YunDianDetailBottomViewClickType)ClickType{
    switch (ClickType) {
            
        case YunDianDetailBottomViewClickTypeWriteOff://核销
            
        {
            UCEScanViewController *vc = [[UCEScanViewController alloc] init];
            vc.autoGoBack = YES;
            vc.scanCodeType = ScanCodeTypeAll;
            vc.hidesBottomBarWhenPushed=YES;
            vc.orderNo = self.detailModel.orderNo;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            vc.complete = ^(NSString *str) {
                
                
            };
        }
            break;
        case YunDianDetailBottomViewClickTypeDeliverGoods://发货
        {
            NSString *url = [NSString stringWithFormat:@"/html/mall/tobeshipped.html?orderNo=%@",self.detailModel.orderNo];
            [self pushYunDianOrderDetailHtml:url];
        }
            break;
        case YunDianDetailBottomViewClickTypeViewLogistics://查看物流
        {
            ManageLogisticsViewController * logistVC = [[ManageLogisticsViewController alloc]init];
            logistVC.logisticsID = self.detailModel.wl_id;
            [self.navigationController pushViewController:logistVC animated:YES];
        }
            break;
        case YunDianDetailBottomViewClickTypeViewOther://其他
        {
            
        }
            break;
            
        default:
            break;
    }
}

/**
 订单商品详情跳转
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    YunDianorderDetailProductListModel *productModel = (YunDianorderDetailProductListModel *)self.detailModel.orderProductList[indexPath.row];
//    
//    
//    if(![productModel.productState isEqual:@(5)]) {
//        [self showSVProgressHUDErrorWithStatus:@"商品已下架！"];
//        return;
//    }
//    if ([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_DIRECT_SUPPLY_ORDER"]) {
//        //直供
//        NSString *url = [NSString stringWithFormat:@"/html/home/#/goods/details?productId=%@&active=5",productModel.productId];
//        [self pushYunDianOrderDetailHtml:url];
//        
//    } else if([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_CATEGORY_MDD"] || [self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MALL"] || [self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_SEC_KILL_ORDER"]) {
//        //商城
//        
//        NSString *url = [NSString stringWithFormat:@"/html/home/#/goods/details?productId=%@&active=%@",productModel.productId,productModel.activeId];
//        [self pushYunDianOrderDetailHtml:url];
//        
//    } else if([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_ORDER"] || [self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"] || [self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_CLOUD_WAREHOUSE_ORDER"]) {
//        //云店
//        
//        NSString *url = [NSString stringWithFormat:@"/html/home/#/cloudShop/goodsDetails?productId=%@",productModel.productId];
//        [self pushYunDianOrderDetailHtml:url];
//        
//    } else if([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_WELFARE_ORDER"]) {
//        //福利
//        
//        NSString *url = [NSString stringWithFormat:@"html/goods/main/details_r.html?productId=%@&active=2",productModel.productId];
//        [self pushYunDianOrderDetailHtml:url];
//        
//    } else {
//        //其他去商城(（旧的代理，注册，代注册，升级，新的代理（P_BIZ_AGENT_ORDER）)
//        NSString *url = [NSString stringWithFormat:@"/html/home/#/goods/details?productId=%@&purchaseDisable=1&active=%@",productModel.productId,productModel.activeId];
//        [self pushYunDianOrderDetailHtml:url];
//        
//    }
}
- (void)pushYunDianOrderDetailHtml:(NSString *)webUrl{
    MyJumpHTML5ViewController *HtmlVC = [[MyJumpHTML5ViewController alloc] init];
    HtmlVC.webUrl = webUrl;
    HtmlVC.hidesBottomBarWhenPushed=YES;
    HtmlVC.navigationController.navigationBar.hidden=YES;
    [self.navigationController pushViewController:HtmlVC animated:YES];
}
#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailModel ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [JudgeOrderType returnYunDianDetailTableViewHeaderHeight:self.detailModel];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 426 + 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YunDianOrderDetailHeaderView *header = [[YunDianOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    header.delegate = self;
    header.commented = self.commented;
    header.dic_wl = self.dic_wl;
    header.detailHeaderModel = self.detailModel;
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YunDianOrderDetailFooterView *footer = [[YunDianOrderDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    footer.detailFooterModel = self.detailModel;
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        return 1;
    }
    return self.detailModel.orderProductList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YunDianOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YunDianOrderDetailTableViewCell"];
    if (!cell) {
        cell = [[YunDianOrderDetailTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"YunDianOrderDetailTableViewCell"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productModel = (YunDianorderDetailProductListModel *)self.detailModel.orderProductList[indexPath.row];
    if ([self.detailModel.orderBizCategory isEqualToString:@"P_BIZ_OTO_MCH_SCAN_ORDER"]) {
        cell.detailModel = self.detailModel;
    }
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_122) style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.tableView.mj_footer.state = MJRefreshStateIdle;
            [self requestYDOrderDetail];
        }];
    }
    return _tableView;
}
- (YunDianDetailBottomView *)detailBottomView{
    if (!_detailBottomView) {
        _detailBottomView = [[YunDianDetailBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_122 - 50, ScreenWidth, 50)];
        _detailBottomView.hidden = YES;
        _detailBottomView.delegate = self;
    }
    return _detailBottomView;
}
@end
