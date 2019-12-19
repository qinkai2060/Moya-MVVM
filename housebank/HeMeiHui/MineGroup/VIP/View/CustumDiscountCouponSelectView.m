//
//  CustumDiscountCouponSelectView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CustumDiscountCouponSelectView.h"
#import "CustumDiscountCouponTableViewCell.h"
#import "DiscountCouponModel.h"
@interface CustumDiscountCouponSelectView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *bgViewt;
@end
@implementation CustumDiscountCouponSelectView
+(instancetype)CustumDiscountCouponSelectViewIn:(UIView *)view closeblock:(void(^)(void))closeblock isNoLoginBlock:(void(^)(void))isNoLoginBlock{
    CustumDiscountCouponSelectView *cus = [[CustumDiscountCouponSelectView alloc] initWithFrame:view.bounds];
    cus.closeblock = closeblock;
    cus.isNoLoginBlock = isNoLoginBlock;
    [view addSubview:cus];
    return cus;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}
- (void)requestCouponList{
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./m/mall/coupon/list_by"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@/2?sid=%@&pageNum=%@&pageSize=%@",utrl,sid,@(_currentPage),@(10)] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:nil success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"领券中心:%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 ) {
            if (Is_Kind_Of_NSDictionary_Class([dic objectForKey:@"data"]) &&
                Is_Kind_Of_NSArray_Class([[dic objectForKey:@"data"] objectForKey:@"list"])) {
                NSArray *arrInfo = [NSMutableArray arrayWithArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];
                                
                NSArray * arr = [NSArray modelArrayWithClass:[DiscountCouponModel class] json:arrInfo];
                
                if (arr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (self.currentPage == 1) {
                    //下拉刷新
                    self.arrData = [NSMutableArray arrayWithArray:arr];
                    
                } else {
                    //上啦加载
                    if (!arr.count) {
                        return ;
                    }
                    for (DiscountCouponModel *model in arr) {
                        [self.arrData addObject:model];
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
- (void)requestReceivingCoupon:(NSString*)couponNo{
    if (CHECK_STRING_ISNULL(couponNo)) {
        [self showSVProgressHUDErrorWithStatus:@"couponNo为空!"];
        return;
    }
    
    NSString *sid = USERDEFAULT(@"sid") ?: @"";
    [SVProgressHUD show];
      NSString * utrl = [[NetWorkManager shareManager] getForKey:@"mall./user/m/mall/coupon/receiving"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@/%@?sid=%@",utrl,couponNo,sid] withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:nil success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:request.responseObject];
        if ([[dic objectForKey:@"state"] integerValue] == 1 ) {
            [self showSVProgressHUDSuccessWithStatus:@"领取成功!"];
            [self.tableView.mj_header beginRefreshing];
        }  else if ([[dic objectForKey:@"state"] integerValue] == 2){
            
            if ([[dic objectForKey:@"code"] isEqual:@(-1)]) {
               [self showSVProgressHUDErrorWithStatus:@"该优惠券不在发放时间!"];
            } else if ([[dic objectForKey:@"code"] isEqual:@(-2)]) {
                [self showSVProgressHUDErrorWithStatus:@"vip等级不够不可领取!"];
            } else if ([[dic objectForKey:@"code"] isEqual:@(-3)]) {
                [self showSVProgressHUDErrorWithStatus:@"发放数量限制!"];
            }else {
                [self showSVProgressHUDErrorWithStatus:CHECK_STRING([dic objectForKey:@"msg"])];
            }
        } else {
                [self showSVProgressHUDErrorWithStatus:CHECK_STRING([dic objectForKey:@"msg"])];
            }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
    }];
}
- (void)showSVProgressHUDSuccessWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}

- (void)createView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    self.bgViewt = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, self.width, self.height)];
    self.bgViewt.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgViewt];
    
    [self.bgViewt addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgViewt);
        make.left.equalTo(self.bgViewt);
        make.right.equalTo(self.bgViewt);
        make.height.mas_equalTo(418);
    }];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = [UIFont systemFontOfSize:16];
    self.title.textColor = HEXCOLOR(0x333333);
    self.title.backgroundColor = [UIColor whiteColor];
    self.title.text = @"优惠券";
    [self.bgViewt addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgViewt).offset(-418);
        make.left.equalTo(self.bgViewt);
        make.right.equalTo(self.bgViewt);
        make.height.mas_equalTo(50);
        
    }];
    
    
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setImage:[UIImage imageNamed:@"icon_vipclose"] forState:(UIControlStateNormal)];
    [btnClose addTarget:self action:@selector(touchAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bgViewt addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title);
        make.bottom.equalTo(self.title);
        make.right.equalTo(self.bgViewt);
        make.width.mas_equalTo(50);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgViewt.frame = self.bounds;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返利
    static NSString *cellIdentifier = @"CustumDiscountCouponTableViewCell";
    
    CustumDiscountCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CustumDiscountCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
       
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    DiscountCouponModel *model = (DiscountCouponModel *)self.arrData[indexPath.row];
    cell.couponModel = model;
    cell.tag = 1000 + indexPath.row;
    WEAKSELF
    cell.getBtnActionBlock = ^(NSInteger tag) {
        [weakSelf custumDiscountCouponTableViewCellGetBtnActionBlock:tag];
    };
    return cell;
}
- (void)custumDiscountCouponTableViewCellGetBtnActionBlock:(NSInteger)index{
    if (![HFUserDataTools isLogin]) {
        if (self.isNoLoginBlock) {
            self.isNoLoginBlock();
          [self removeViewAnimate];
        }
        return;
    }
    DiscountCouponModel *model = (DiscountCouponModel *)self.arrData[index];

    [self requestReceivingCoupon:model.couponNo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.currentPage = 1;
            self.tableView.mj_footer.state = MJRefreshStateIdle;
            [self requestCouponList];
        }];
        // 上拉刷新
        _tableView.mj_footer =
        [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            self.currentPage++;
            [self requestCouponList];
        }];
        //解决tableview上啦加载的问题tableview上移的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
    
    }
    return _tableView;
}
- (void)touchAction{
    [self removeViewAnimate];
}

- (void)removeViewAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgViewt.frame = CGRectMake(0, ScreenH, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
