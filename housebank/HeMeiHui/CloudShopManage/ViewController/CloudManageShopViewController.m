//
//  CloudManageShopViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/8/7.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudManageShopViewController.h"
#import "HFYDWeiDDetialViewController.h"
#import "CloudVipAlertView.h"
#import "CloudAlertView.h"
#import "CreateWeiShopViewController.h"
#import "CloudWeiShopMainController.h"
#import "MyJumpHTML5ViewController.h"
@interface CloudManageShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView * headImageView;  // 头部图片
@property (nonatomic, strong) UILabel * shopNameLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UITableView * rowTableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSNumber * state;       // 状态（1:待审核，2:审核未通过，3:审核通过））
@property (nonatomic, strong) NSNumber * limitNumber; // 限制的次数，默认2
@property (nonatomic, strong) NSNumber * editNumber;  // 第几次更改
@property (nonatomic, strong) UILabel * showLabel;

@property (nonatomic, strong) CloudVipAlertView *alertView;
@end

@implementation CloudManageShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self setUpUI];
    [self initWithData];
    @weakify(self);
    [[self getRequest]subscribeNext:^(NSDictionary * x) {
        if (x) {
            @strongify(self);
            NSNumber * mark = [x objectForKey:@"mark"];
            self.state = [x objectForKey:@"state"];
            self.limitNumber = [x objectForKey:@"limitNumber"];
            self.editNumber = [x objectForKey:@"editNumber"];
            if([mark isEqualToNumber:@0]){
                [self.dataSource addObject:@"微店管理"];

            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rowTableView reloadData];
            });
        }
    }error:^(NSError * _Nullable error) {
        NSString * errorString = [error.userInfo objectForKey:@"error"];
        [SVProgressHUD showErrorWithStatus:errorString];
    }];
}

- (RACSignal *)getRequest {

    RACSubject * subject = [RACSubject subject];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary * params = @{
                              @"shopId": self.itemModel.shopId
                              };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"retail.m/shop/micro-shop/valid-shop"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@%@?sid=%@",CloudeEnvironment,objectOrEmptyStr(utrl),sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:params success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseObject;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if (![dataDic isEqual:[NSNull null]] && dataDic.allKeys.count > 0 && [dataDic.allKeys containsObject:@"result"]) {
                    NSDictionary * dataSource = [dataDic objectForKey:@"result"];
                    [subject sendNext:dataSource];
                    [subject sendCompleted];
                }
            }else {
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"商铺管理";
    self.customNavBar.titleLabelColor=HEXCOLOR(0X333333);
    self.customNavBar.titleLabelFont=PFR17Font;
    
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item1];
    item1.frame = CGRectMake(kWidth-60, 0, 40, 40);
    item1.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item1 setImage:[UIImage imageNamed:@"cloud_tui"] forState:UIControlStateNormal];
    
    @weakify(self);
    [[item1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [HFYDWeiDDetialViewController showTuiG:objectOrEmptyStr(self.itemModel.shopId) vc:self itemModel:self.itemModel];
    }];
}

- (void)initWithData {
    
    if ([self.itemModel.logoImg isNotNil]) {
         [self.headImageView sd_setImageWithURL:[self.itemModel.shopImg  get_BannerImage] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];

    }
    if ([self.itemModel.shopName isNotNil]) {
        self.shopNameLabel.text = self.itemModel.shopName;
    }
    if ([self.itemModel.fullAddress isNotNil]) {
        self.addressLabel.text = self.itemModel.fullAddress;

    }
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell).offset(-1);
        make.left.right.equalTo(cell);
        make.height.equalTo(@1);
    }];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_light666"]];
    [cell addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-15);
        make.width.height.equalTo(@15);
    }];
    
    cell.textLabel.font = kFONT_BOLD(14);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        // 商铺信息
        if ([self.state isEqualToNumber:@1]) {
            NSString *strUrl = [NSString stringWithFormat:@"/html/house/oto/reg-progress.html?shopType=3&stealAge=0&shopsId=%@",self.itemModel.shopId];
                         MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
                         htmlVC.webUrl = strUrl;
                       [self.navigationController pushViewController:htmlVC animated:YES];
        }else if ([self.state isEqualToNumber:@3] ||[self.state isEqualToNumber:@2] ) {
            if([self.limitNumber isEqualToNumber:@-1]){
                // 隐藏弹框需求，去编辑微店
                [self pushToEditVC:YES showBottom:YES];
            }else{
                 [self judgeShopTypes];
            }
        }
    }else if (indexPath.row == 1){
        // 店铺详情
        CloudWeiShopMainController * mainVC = [[CloudWeiShopMainController alloc]init];
        mainVC.shopID = objectOrEmptyStr(self.itemModel.shopId);
        mainVC.itemModel = self.itemModel;
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

- (void)judgeShopTypes {
    
    static  NSString * alertString;
    @weakify(self);
    // 根据 编辑次数和最大次数判定  可以修改
    if ([self.editNumber integerValue] > 0 ) {
        if ([self.editNumber integerValue] >=  [self.limitNumber integerValue]) {
            alertString = [NSString stringWithFormat:@"您对店铺信息已经做过%@次更改，无法再次编辑，请知晓，谢谢",self.limitNumber];
    
            [self.alertView showAlertString:alertString isSure:NO changeBlock:^{
                @strongify(self);
                [self.alertView removeFromSuperview];
                
                [self pushToEditVC:NO showBottom:YES];
            }];
        }else {
            NSNumber * surplusNum = [NSNumber numberWithInteger:[self.limitNumber integerValue] - [self.editNumber integerValue]];
            alertString = [NSString stringWithFormat:@"您对店铺信息已经做过%@次更改， 还有%@次更改机会，请知晓，谢谢",self.editNumber,surplusNum];
            [self.alertView showAlertString:alertString isSure:NO changeBlock:^{
                @strongify(self);
                [self.alertView removeFromSuperview];
                [self pushToEditVC:YES showBottom:YES];
            }];
        }
    }else if([self.state isEqualToNumber:@3] && [self.editNumber integerValue] ==  0){
        [self.alertView showAlertString:[NSString stringWithFormat:@"您对店铺信息的更改只有%@次机会， 请您谨慎修改店铺信息",self.limitNumber] isSure:NO changeBlock:^{
            @strongify(self);
            [self.alertView removeFromSuperview];
            [self pushToEditVC:YES showBottom:YES];
        }];
    }else if ([self.state isEqualToNumber:@2] && [self.editNumber integerValue] ==  0) {
            [self pushToEditVC:YES showBottom:NO];
    }
}

- (void)pushToEditVC:(BOOL)canEdit  showBottom:(BOOL)show{
    // 1.店铺审核成功，点击商铺信息进入编辑微店店铺信息
    // 2.店铺审核失败，点击商铺信息进入微店审核进度页面
    CreateWeiShopViewController * weiVC = [[CreateWeiShopViewController alloc]init];
    weiVC.reason = objectOrEmptyStr(self.reason);
    weiVC.itemModel = self.itemModel;
    weiVC.createType = ChangeShop;
    weiVC.canEdit = canEdit;
    weiVC.showBottom = show;
    NSString * alertString = [NSString stringWithFormat:@"备注:\n编辑店铺后，此店铺状态变为待审核状态，原来店铺以及店铺商品仍然处于上架状态，并不影响用户下单；店铺审核成功后，店铺信息自动替换掉原来的店铺信息，但是微店编号不变"];
    weiVC.bottomString = alertString;
    [self.navigationController pushViewController:weiVC animated:YES];

}

- (void)setUpUI {
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(STATUSBAR_NAVBAR_HEIGHT);
        make.height.equalTo(@120);
    }];
    
    
    [self.headImageView addSubview:self.showLabel];
    if([self.itemModel.shopName isNotNil]){
        self.showLabel.text = objectOrEmptyStr(self.itemModel.shopName);
    }
    
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.headImageView).offset(30);
          make.right.equalTo(self.headImageView).offset(-10);
          make.width.equalTo(@150);
          make.height.equalTo(@20);
    }];
    
    UIView * headView = [UIView new];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@83);
    }];
    
    [headView addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.top.equalTo(headView).offset(15);
        make.height.equalTo(@28);
    }];
    
    [headView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopNameLabel);
        make.top.equalTo(self.shopNameLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.view addSubview:self.rowTableView];
}

#pragma mark -- lazy load
- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.clipsToBounds = YES;

    }
    return _headImageView;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel new];
        _shopNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _shopNameLabel.font = kFONT_BOLD(20);
    }
    return _shopNameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _addressLabel.font = kFONT(16);
    }
    return _addressLabel;
}

- (UITableView *)rowTableView {
    if (!_rowTableView) {
        _rowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 213+STATUSBAR_NAVBAR_HEIGHT, kWidth, kHeight-213-STATUSBAR_NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _rowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rowTableView.delegate = self;
        _rowTableView.dataSource = self;
        _rowTableView.scrollEnabled = NO;
        _rowTableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _rowTableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObject:@"商铺信息"];

    }
    return _dataSource;
}

- (CloudVipAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CloudVipAlertView alloc]init];
        _alertView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    }
    return _alertView;
}

- (UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [UILabel new];
        _showLabel.text = @"店铺名称";
        _showLabel.font = kFONT(15);
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.textAlignment = NSTextAlignmentLeft;
    }
    return  _showLabel;
}
@end
