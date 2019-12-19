//
//  ManageWeiDownController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageWeiDownController.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "ManageDownTableViewCell.h"
#import "ManageOwnViewModel.h"
#import "EmptyModel.h"
#import "HandleEventDefine.h"
#import "ManageOwnModel.h"
#import "CloudManageViewModel.h"
#import "CloudCodeView.h"
#import "HFYDWeiDDetialViewController.h"
@interface ManageWeiDownController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton * allSelectBtn;
@property (nonatomic, strong) UIButton * downAllBtn;
@property (nonatomic, strong) UITableView * downTableView;
@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, strong) ManageOwnViewModel * viewModel;
@property (nonatomic, strong) CloudManageViewModel * manageViewModel;
@property (nonatomic, assign) NSInteger soldIndex;
@property (nonatomic, strong) CloudCodeView    * cloudCodeView; // 二维码
@end

@implementation ManageWeiDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.downTableView];
    [self.downTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    [self.downTableView registerNib:[UINib nibWithNibName:@"ManageDownTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManageDownTableViewCell"];
    [self.downTableView reloadData];
    self.select = NO;
    [self setUpUI];
    [self bindRAC];
    
    @weakify(self);
    self.downTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.soldIndex = 1;
        [[self.viewModel loadRequest_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:@"1" pageNo:self.soldIndex]subscribeNext:^(NSMutableArray * x) {
            @strongify(self);
            if (x.count == 0) {
                self.dataSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
            }
            self.dataSource = x;
            [self.downTableView.mj_footer resetNoMoreData];
            [self.downTableView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self changeAllSelect:self.dataSource];
                [self.downTableView reloadData];
            });
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.downTableView.mj_header endRefreshing];
        }];
    }];
    
    /** 上拉加载*/
    self.downTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.soldIndex ++;
        [[self.viewModel loadMore_sellDataWithShopID:objectOrEmptyStr(self.shopID) Type:@"1" pageNo:self.soldIndex] subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.downTableView.mj_footer endRefreshing];
                [self.downTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }else {
                [self changSelectAllBtn:NO];
                [self changeAllSelect:addSource];
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            self.dataSource = dataSource;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.downTableView.mj_footer endRefreshing];
                    [self.downTableView reloadData];
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
    [[self.allSelectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.select = !self.select;
        [self changSelectAllBtn:self.select];
        [self changeAllSelect:self.dataSource];
        [self.downTableView reloadData];
    }];
    
    [[self.downAllBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self loadRequest];
    }];
}

- (void)changeAllSelect:(NSArray *)array {
    @weakify(self);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        ManageOwnModel * itemModel = self.dataSource[idx];
        itemModel.isSelect = self.select;
        if (self.select == YES) {
            [self.selectArray addObject:itemModel.id];
        }else {
            [self.selectArray removeAllObjects];
        }
    }];
}

- (void)changSelectAllBtn:(BOOL)select {
    if (select) {
        [self.allSelectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else {
        [self.allSelectBtn setImage:[UIImage imageNamed:@"cloude_NoSelect"] forState:UIControlStateNormal];
    }
}

- (void)loadRequest {
    if (self.selectArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还未选择下架商品"];
        return;
    }
    
    @weakify(self);
    [[self.viewModel down_selectShop:objectOrEmptyStr(self.shopID) productArray:self.selectArray]subscribeNext:^(id  _Nullable x) {
        if (x) {
            @strongify(self);
            [SVProgressHUD showSuccessWithStatus:@"商品下架成功"];
            [self.downTableView.mj_header beginRefreshing];
            [self.selectArray removeAllObjects];
        }
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"商品下架失败"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"微店管理";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
    
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item1];
    item1.frame = CGRectMake(kWidth-30-50, 0, 40, 40);
    item1.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item1 setImage:[UIImage imageNamed:@"cloud_tui"] forState:UIControlStateNormal];
    
    UIButton * item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item2];
    item2.frame = CGRectMake(kWidth-30-15, 0, 40, 40);
    item2.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item2 setImage:[UIImage imageNamed:@"cloudCord"] forState:UIControlStateNormal];
    
    @weakify(self);
    [[item1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [HFYDWeiDDetialViewController showTuiG:objectOrEmptyStr(self.shopID) vc:self itemModel:self.itemModel];
    }];
    
    [[item2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [HFYDWeiDDetialViewController showQRCode:objectOrEmptyStr(self.shopID) vc:self itemModel:self.itemModel];
    }];
    
    [self.downTableView.mj_header beginRefreshing];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:DownSelectShop]) {
        NSString * microProductId = objectOrEmptyStr([userInfo objectForKey:@"microProductId"]);
        if ([self.selectArray containsObject:microProductId]) {
            [self.selectArray removeObject:microProductId];
        }else {
             [self.selectArray addObject:microProductId];
        }
        if (self.selectArray.count == self.dataSource.count) {
            [self changSelectAllBtn:YES];
        }else {
            [self changSelectAllBtn:NO];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManageDownTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ManageDownTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > 0) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)setUpUI {
    UIView * headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBAR_NAVBAR_HEIGHT);
        make.height.equalTo(@40);
    }];
    
    [headView addSubview:self.allSelectBtn];
    [self.allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.height.width.equalTo(@20);
        make.centerY.equalTo(headView);
    }];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.text = @"全选";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = kFONT(15);
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(self.allSelectBtn.mas_right).offset(8);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    UIView * bottom = [UIView new];
    bottom.backgroundColor = [UIColor whiteColor];
    bottom.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottom.layer.shadowOpacity = 1;
    bottom.layer.shadowOffset = CGSizeMake(0, 5);
    bottom.layer.shadowRadius = 5;
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [bottom addSubview:self.downAllBtn];
    [self.downAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

#pragma mark -- lazy load
- (UIButton *)allSelectBtn {
    if (!_allSelectBtn) {
        _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectBtn setImage:[UIImage imageNamed:@"cloude_NoSelect"] forState:UIControlStateNormal];
    }
    return _allSelectBtn;
}

- (UIButton *)downAllBtn {
    if (!_downAllBtn) {
        _downAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downAllBtn setTitle:@"下架" forState:UIControlStateNormal];
        _downAllBtn.titleLabel.font = kFONT_BOLD(15);
        [_downAllBtn setTitleColor:[UIColor colorWithHexString:@"#ED0505"] forState:UIControlStateNormal];
    }
    return _downAllBtn;
}

- (UITableView *)downTableView {
    if (!_downTableView) {
        _downTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40+STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-40-50) style:UITableViewStylePlain];
        _downTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _downTableView.delegate = self;
        _downTableView.dataSource = self;
        _downTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _downTableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (ManageOwnViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[ManageOwnViewModel alloc]init];
    }
    return _viewModel;
}

- (CloudManageViewModel *)manageViewModel {
    if (!_manageViewModel) {
        _manageViewModel = [[CloudManageViewModel alloc]init];
    }
    return _manageViewModel;
}

- (CloudCodeView *)cloudCodeView {
    if (!_cloudCodeView) {
        _cloudCodeView = [[CloudCodeView alloc]init];
        _cloudCodeView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_cloudCodeView];
    }
    return _cloudCodeView;
}
@end
