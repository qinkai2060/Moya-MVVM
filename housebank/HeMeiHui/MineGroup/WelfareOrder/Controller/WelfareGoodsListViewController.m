//
//  WelfareGoodsListViewController.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WelfareGoodsListViewController.h"
#import "MyOrderTableViewEmptyView.h"
#import "WelfareGoodsListTableViewCell.h"
#import "WelfareGoodsListModel.h"
#import "MyJumpHTML5ViewController.h"
@interface WelfareGoodsListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) MyOrderTableViewEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *arrDate;//数据源
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *tips;

@end

@implementation WelfareGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self requestSelectUserWelfare];
    [self.tableView.mj_header beginRefreshing];
}
//福利商品上面的字
- (void)requestSelectUserWelfare{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic1 = @{
                           @"sid":sid
                           };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/product/selectUserWelfare"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSString_Class([[dic objectForKey:@"data"] objectForKey:@"tips"])) {
                self.tips = [[dic objectForKey:@"data"] objectForKey:@"tips"];
                [self.tableView reloadData];
            } else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
            
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
 福利订单
 */
- (void)requestWelfareGoodsList{
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic1 = @{
                           @"sid":sid,
                           @"pageNo":@(_currentPage),
                           @"pageSize":@"10",
                           };
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/m/product-welfare/list"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic1 success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 ) {
            if (
                Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"list"])) {
                
                NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];
                
                NSArray * arr = [NSArray modelArrayWithClass:[WelfareGoodsListModel class] json:arrInfo];
                
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
                    for (WelfareGoodsListModel *model in arr) {
                        [self.arrDate addObject:model];
                    }
                }
                [self.tableView reloadData];
                NSLog(@"%@", arr);
                
            }else {
                [self showSVProgressHUDErrorWithStatus:@"数据格式错误!"];
            }
            
        } else {
            [self showSVProgressHUDErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WelfareGoodsListModel *model = (WelfareGoodsListModel *)self.arrDate[indexPath.row];
    MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
    HtmlVC.webUrl = [NSString stringWithFormat:@"/html/home/#/goods/details?productId=%@&active=2", model.productId];
    [self.nvController pushViewController:HtmlVC animated:YES];
}
#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    self.emptyView.hidden = self.arrDate.count ? YES : NO;
    return 1;
}
- (MyOrderTableViewEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [MyOrderTableViewEmptyView showMyOrderTableViewEmptyViewInSuperView:_tableView];
    }
    return _emptyView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = HEXCOLOR(0xFFFBD3);
    
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 40)];
    labelHeader.numberOfLines = 2;
    labelHeader.font = [UIFont systemFontOfSize:12];
    labelHeader.text = self.tips;
    [header addSubview:labelHeader];
    return header;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WelfareGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WelfareGoodsListTableViewCell"];
    if (!cell) {
        cell = [[WelfareGoodsListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"WelfareGoodsListTableViewCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 4000 + indexPath.row;
    cell.model = (WelfareGoodsListModel *)self.arrDate[indexPath.row];
    return cell;
}



- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenHeight - IPHONEX_SAFE_AREA_TOP_HEIGHT_122) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 1;
            self.tableView.mj_footer.state = MJRefreshStateIdle;
            [self requestWelfareGoodsList];

        }];
         //上拉刷新
        _tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            _currentPage++;
            [self requestWelfareGoodsList];
        }];
        //解决tableview上啦加载的问题tableview上移的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (UIView *)listView {
    return self.view;
}
@end
