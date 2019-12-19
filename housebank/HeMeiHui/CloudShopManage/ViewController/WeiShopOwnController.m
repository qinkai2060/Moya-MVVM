//
//  WeiShopOwnController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "WeiShopOwnController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageOwnViewModel.h"
#import "ManageSortViewController.h"
#import "ManageWeiDownController.h"
#import "EmptyModel.h"
#import "HandleEventDefine.h"
#import "ManageOrderViewModel.h"
#import "ManageOwnModel.h"
#import "MyJumpHTML5ViewController.h"
@interface WeiShopOwnController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * ownTableView;
@property (nonatomic, strong) ManageOwnViewModel * viewModel;
@property (nonatomic, strong) UIButton * sellBtn;
@property (nonatomic, strong) UIButton * soldOutBtn;
@property (nonatomic, strong) UIView   * bottom;
@property (nonatomic, assign) NSInteger  sellIndex;
@property (nonatomic, assign) NSInteger  soldIndex;
@property (nonatomic, strong) ManageOrderViewModel * orderViewModel;
@end

@implementation WeiShopOwnController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ownTableView];
    [self.ownTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    self.ownSelectIndex = OwnSellIndex;
    [self setUpUI];
    [self bindRAC];
    
    @weakify(self);
    self.ownTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.sellIndex = 1;
        self.soldIndex = 1;
        [[self.viewModel loadRequest_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:(self.ownSelectIndex == OwnSellIndex?@"1":@"0") pageNo:(self.ownSelectIndex == OwnSellIndex?self.sellIndex:self.soldIndex)]subscribeNext:^(NSMutableArray * x) {
            @strongify(self);
            if (x.count == 0) {
                self.viewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.ownTableView reloadData];
            });
            [self.ownTableView.mj_footer resetNoMoreData];
            [self.ownTableView.mj_header endRefreshing];
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.ownTableView.mj_header endRefreshing];
        }];
    }];
    
    /** 上拉加载*/
    self.ownTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.ownSelectIndex == OwnSellIndex) {
            self.sellIndex ++;
        }else {
            self.soldIndex ++;
        }
        [[self.viewModel loadMore_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:(self.ownSelectIndex == OwnSellIndex?@"1":@"0") pageNo:(self.ownSelectIndex == OwnSellIndex?self.sellIndex:self.soldIndex)] subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.ownTableView.mj_footer endRefreshing];
                [self.ownTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.ownTableView reloadData];
                    [self.ownTableView.mj_footer endRefreshing];
                });
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
    
    self.viewModel.shopID = self.shopID;
}

- (void)bindRAC {
    @weakify(self);
    [[self.sellBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.ownSelectIndex = OwnSellIndex;
    }];
    
    [[self.soldOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
         self.ownSelectIndex = OwnSoldIndex;
    }];
    
    [[RACObserve(self, ownSelectIndex) distinctUntilChanged]subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.ownSelectIndex == OwnSellIndex) {
            [self changColor:YES];
            self.bottom.hidden = NO;
            self.ownTableView.frame = CGRectMake(0, 45, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-45-50-45);
        }else {
            [self changColor:NO];
            self.bottom.hidden = YES;
            self.ownTableView.frame = CGRectMake(0, 45, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-45-45);
        }
        [self.ownTableView.mj_header beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.ownTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel jx_numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel jx_numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel jx_heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.viewModel jx_modelAtIndexPath:indexPath];
    
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.ownSelectIndex == OwnSoldIndex){
          [noRecordCell reloadString:@"您还没有已下架的商品!"];
        }else {
          [noRecordCell reloadString:@"您还没有出售中的商品!"];
        }
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.ownTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell customViewWithData:model indexPath:indexPath];
    
    return (UITableViewCell *)cell;
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    /** 下架*/
    if ([eventName isEqualToString:DownAwayShop]) {
        @weakify(self);
        [[self.viewModel down_selectShop:objectOrEmptyStr(self.shopID) productArray:@[[userInfo objectForKey:@"microProductId"]]]subscribeNext:^(NSString * x) {
            if (x) {
                @strongify(self);
                [SVProgressHUD showSuccessWithStatus:@"商品下架成功"];
                [self.ownTableView.mj_header beginRefreshing];
            }
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD showErrorWithStatus:@"商品下架失败"];
        }];
        
    }else if([eventName isEqualToString:PutAwayShop]) {
         @weakify(self);
    /** 上架*/
        NSArray * productArray = @[[userInfo objectForKey:@"microProductId"]];
        [[self.viewModel putAway_selectShop:objectOrEmptyStr(self.shopID) productArray:productArray]subscribeNext:^(NSString * x) {
            if (x) {
                @strongify(self);
                [SVProgressHUD showSuccessWithStatus:@"商品上架成功"];
                [self.ownTableView.mj_header beginRefreshing];
            }
        } error:^(NSError * _Nullable error) {
             [SVProgressHUD showErrorWithStatus:@"商品上架失败"];
        }];
    }else if ([eventName isEqualToString: ManageShare]) {
        ManageOwnModel *item = [userInfo objectForKey:@"itemModel"];
        /** 推广*/
        [[self.viewModel loadRequest_shareTheOrederWithProductID:objectOrEmptyStr(item.productId)]subscribeNext:^(NSDictionary * x) {
            if (x) {
                NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
                NSString * url = [NSString stringWithFormat:@"%@?shareId=%@&mocriShopId=%@&productId=%@",[x objectForKey:@"shareUrl"],uid,self.shopID,objectOrEmptyStr(item.productId)];
                NSDictionary *dic = @{
                                      @"shareDesc":@"",
                                      @"shareImageUrl":[item.imgUrl get_Image],
                                      @"shareTitle":objectOrEmptyStr(item.productName),
                                      @"shareUrl":objectOrEmptyStr(url),
                                      @"longUrl":@"",
                                      @"shareWeixinUrl":objectOrEmptyStr(url),
                                      @"justUrl":@(YES)
                                      };
                [ShareTools  shareWithContent:dic];
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        
        }];
    }else if ([eventName isEqualToString:ManageShopDetail]) {
        NSString * strUrl;
        if (self.ownSelectIndex == OwnSellIndex) {
            strUrl =[NSString stringWithFormat:@"/html/home/#/cloudShop/goodsDetails?productId=%@&mocriShopId=%@&shopId=%@",[userInfo objectForKey:@"productID"],self.shopID,self.shopID];
        }else {
            strUrl =[NSString stringWithFormat:@"/html/home/#/cloudShop/goodsDetails?productId=%@&mocriShopId=%@&noBuy=1",[userInfo objectForKey:@"productID"],self.shopID];
        }
        MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
        htmlVC.webUrl = strUrl;
        [[UIViewController visibleViewController].navigationController pushViewController:htmlVC animated:YES];
    }
}

- (void)setUpUI {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@45);
    }];
    
    [bgView addSubview:self.sellBtn];
    [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(8);
        make.left.equalTo(bgView).offset(15);
        make.width.equalTo(@56);
        make.height.equalTo(@30);
    }];
    
    [bgView addSubview:self.soldOutBtn];
    [self.soldOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.sellBtn);
        make.left.equalTo(self.sellBtn.mas_right).offset(15);
    }];
    
    UIView * line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-1);
        make.height.equalTo(@1);
    }];
    
    UIView * line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bgView);
        make.top.equalTo(bgView);
        make.height.equalTo(@1);
    }];

    
    self.bottom = [UIView new];
    self.bottom.frame = CGRectMake(0,kHeight-IPHONEX_SAFE_AREA_TOP_HEIGHT_88-45-50, kWidth, 50);
    self.bottom.backgroundColor = [UIColor whiteColor];
    self.bottom.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bottom.layer.shadowOpacity = 1;
    self.bottom.layer.shadowOffset = CGSizeMake(0, 5);
    self.bottom.layer.shadowRadius = 5;
    [self.view addSubview:self.bottom];

    
    UIView * verticalLine = [UIView new];
    verticalLine.backgroundColor= [UIColor colorWithHexString:@"#DDDDDD"];
    [self.bottom addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@14);
    }];
    
    UIButton * batchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [batchBtn setTitle:@"批量下架" forState:UIControlStateNormal];
    batchBtn.backgroundColor = [UIColor whiteColor];
    [batchBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    batchBtn.titleLabel.font = kFONT_BOLD(14);
    [self.bottom addSubview:batchBtn];
    [batchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottom);
        make.right.equalTo(verticalLine.mas_left);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(@50);
    }];
    @weakify(self);
    [[batchBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ManageWeiDownController * downVC = [[ManageWeiDownController alloc]init];
        downVC.shopID = self.shopID;
        downVC.itemModel = self.itemModel;
        [self.navigationController pushViewController:downVC animated:YES];
    }];

    UIButton * sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortBtn setTitle:@"商品排序" forState:UIControlStateNormal];
    sortBtn.backgroundColor = [UIColor whiteColor];
    [sortBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    sortBtn.titleLabel.font = kFONT_BOLD(14);
    [self.bottom addSubview:sortBtn];
    [sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottom);
        make.left.equalTo(verticalLine.mas_right);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(@50);
    }];
    
    [[sortBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ManageSortViewController * sortVC = [[ManageSortViewController alloc]init];
        sortVC.itemModel = self.itemModel;
        sortVC.shopID = self.shopID;
        [self.navigationController pushViewController:sortVC animated:YES];
    }];
}

- (void)changColor:(BOOL)isSelect {
    if (isSelect == YES) {
        [self.sellBtn setTitleColor:[UIColor colorWithHexString:@"#ED0505"] forState:UIControlStateNormal];
        self.sellBtn.layer.borderColor = [UIColor colorWithHexString:@"#ED0505"].CGColor;
        self.sellBtn.backgroundColor = [UIColor whiteColor];
        [self.soldOutBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.soldOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
        self.soldOutBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }else {
        [self.sellBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        self.sellBtn.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
        self.sellBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.soldOutBtn setTitleColor:[UIColor colorWithHexString:@"#ED0505"] forState:UIControlStateNormal];
        self.soldOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#ED0505"].CGColor;
        self.soldOutBtn.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark -- lazy load
- (ManageOwnViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ManageOwnViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)ownTableView {
    if (!_ownTableView) {
        _ownTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, kWidth, kHeight-IPHONEX_SAFE_AREA_TOP_HEIGHT_88-45-50) style:UITableViewStylePlain];
        _ownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ownTableView.delegate = self;
        _ownTableView.dataSource = self;
        _ownTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _ownTableView;
}

- (UIButton *)sellBtn {
    if (!_sellBtn) {
        _sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sellBtn setTitle:@"出售中" forState:UIControlStateNormal];
        _sellBtn.titleLabel.font = kFONT(12);
        _sellBtn.layer.masksToBounds = YES;
        _sellBtn.layer.cornerRadius = 2;
        _sellBtn.layer.borderWidth = 1;
        [_sellBtn setTitleColor:[UIColor colorWithHexString:@"#ED0505"] forState:UIControlStateNormal];
        _sellBtn.layer.borderColor = [UIColor colorWithHexString:@"#ED0505"].CGColor;
        _sellBtn.backgroundColor = [UIColor whiteColor];
    }
    return _sellBtn;
}

- (UIButton *)soldOutBtn {
    if (!_soldOutBtn) {
        _soldOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soldOutBtn setTitle:@"已下架" forState:UIControlStateNormal];
        _soldOutBtn.titleLabel.font = kFONT(12);
        _soldOutBtn.layer.masksToBounds = YES;
        _soldOutBtn.layer.cornerRadius = 2;
        _soldOutBtn.layer.borderWidth = 1;
        [_soldOutBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _soldOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#F5F5F5"].CGColor;
        _soldOutBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _soldOutBtn;
}

- (ManageOrderViewModel *)orderViewModel {
    if (!_orderViewModel) {
        _orderViewModel = [[ManageOrderViewModel alloc]init];
    }
    return _orderViewModel;
}
@end
