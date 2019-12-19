//
//  HMHVideosListViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideosListViewController.h"
#import "HMHVideosListTableViewCell.h"
#import "HMHVideoSearchViewController.h"
#import "HMHAliyunTimeShiftLiveViewController.h" // 直播
#import "HMHAliYunVodPlayerViewController.h" // 点播
#import "HMHVideoPreviewViewController.h" // 预告
#import "HMHShortVideoViewController.h" // 短视频

#import "HMLiveVideoHomeClassifyViewController.h"//分类
#import "HMHVideoHistoryViewController.h"//历史

#import "HFLoginViewController.h"

@interface HMHVideosListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *HMH_navView;
@property (nonatomic, strong) UITextField *HMH_searchTextField;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;

@property (nonatomic, assign) NSInteger HMH_currrentPage;

@end

@implementation HMHVideosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    
    [self HMH_createNav];
    
    [self HMH_createTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)HMH_createNav{
    self.navigationController.navigationBarHidden = YES;
    
    _HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit_wd, ScreenW, 44)];
    _HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_navView];
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 7, ScreenW - 40 - 90, 30)];
    bgView.backgroundColor = RGBACOLOR(233, 234, 235, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    [_HMH_navView addSubview:bgView];
    //    [self.serachView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.view.mas_top).mas_offset(self.HMH_statusHeghit_wd + 7);
    //        make.leading.mas_equalTo(self.view.mas_leading).mas_offset(WScale(45));
    //        make.trailing.mas_equalTo(self.view.mas_trailing).mas_offset(-WScale(80));
    //        make.height.mas_equalTo(WScale(30));
    //    }];

    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 7.5, 15, 15)];
    img.image = [UIImage imageNamed:@"VH_videoSearch"];
    [bgView addSubview:img];

    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, 60, 44);
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backImageView.image=[UIImage imageNamed:@"VH_blackBack"];
    [backButton addSubview:backImageView];
    [_HMH_navView addSubview:backButton];
    
    _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
    //    HMH_searchTextField.delegate = self;
    _HMH_searchTextField.enabled = NO;
    _HMH_searchTextField.returnKeyType = UIReturnKeySearch;
    _HMH_searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _HMH_searchTextField.text = self.searchKeyStr;
    _HMH_searchTextField.placeholder = @"请输入搜索内容";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    [bgView addSubview:_HMH_searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:searchBtn];
    
    
    
    //分类
    UIButton *btnClassly = [UIButton buttonWithType:0];
    [_HMH_navView addSubview:btnClassly];
    btnClassly.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    btnClassly.frame = CGRectMake(ScreenW - WScale(40), 0, WScale(40), 44);
    [btnClassly setImage:[UIImage imageNamed:@"icon_classly"] forState:UIControlStateNormal];
    [[btnClassly rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
        HMLiveVideoHomeClassifyViewController * vc = [[HMLiveVideoHomeClassifyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //历史
    UIButton *btnHistory = [UIButton buttonWithType:0];
    [_HMH_navView addSubview:btnHistory];
    btnHistory.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    btnHistory.frame = CGRectMake(ScreenW - WScale(80), 0, WScale(40), 44);
    [btnHistory setImage:[UIImage imageNamed:@"icon_history"] forState:UIControlStateNormal];
    [[btnHistory rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if (self.isJudgeLogin) {
            
            HMHVideoHistoryViewController* vc = [[HMHVideoHistoryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //这里是没有登录
            [HFLoginViewController showViewController:self];
        }
    }];
    
    
    
   
   
    
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_navView.frame.size.height - 1, _HMH_navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [_HMH_navView addSubview:bottomLab];
}

- (void)HMH_createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit_wd + 44, ScreenW, ScreenH - self.HMH_statusHeghit_wd - 44 - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

}

- (void)refreshData {
    _HMH_currrentPage = 1;
    [self loadData];
}

- (void)loadMoreData {
    _HMH_currrentPage ++;
    [self loadData];
}

- (void)loadData{
    if (self.searchType.length > 0  && self.searchValue.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"/video/search/%@/%@/%ld",self.searchType,self.searchValue,(long)_HMH_currrentPage];

        if ([self.searchType isEqualToString:@"keyword"]) { // 搜索
            NSString *encodUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self requestData:nil withUrl:encodUrlString];
            self.HMH_searchTextField.text = self.searchValue;

        } else {
            [self requestData:nil withUrl:urlStr];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HMH_dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHVideosListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHVideosListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        [cell refreshCellWithModel:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        if ([model.sceneType isEqualToNumber:@1]) { // 短视频
            HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
            shortVC.videoNo = model.vno;
            [self.navigationController pushViewController:shortVC animated:YES];
        } else {  // 普通视频
            // 视频播放状态（1预告、2直播中、3已结束、 4:回放）
            if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                // 如果预告中 当前剩余时间小于0 就跳转直播 反之 跳转预告
                if ([model.liveLeftTime longLongValue] < 0) { // 直播
                    HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                    liveVC.indexSelected = @0;
                    liveVC.videoNum = model.vno;
                    [self.navigationController pushViewController:liveVC animated:YES];
                } else { // 预告
                    HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
                    preview.videoNum = model.vno;
                    preview.indexSelected = @0;
                    [self.navigationController pushViewController:preview animated:YES];
                }
            }  else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.navigationController pushViewController:liveVC animated:YES];
            }  else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.navigationController pushViewController:liveVC animated:YES];
            } else { // 已结束
                
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (ScreenW - 20) / 5 * 2 * 0.618 + 10;
}

// 返回按钮
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
// 搜索按钮
- (void)searchBtnClick:(UIButton *)btn{
    // 防止循环push
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HMHVideoSearchViewController class]]) {
//            HMHVideoSearchViewController *vc = (HMHVideoSearchViewController *)temp;
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf HMH_getPrcessdata:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (_HMH_currrentPage == 1) {
            [_HMH_dataSourceArr removeAllObjects];
        }
        
        id temp = resDic[@"data"];
        
        if ([temp isKindOfClass:[NSNull class]]) {
            
            return;
        }
        
        NSDictionary *dataDic = resDic[@"data"];
        
        
        
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *listDic in dataDic[@"list"]) {
                HMHVideoListModel *model = [[HMHVideoListModel alloc] init];
                [model setValuesForKeysWithDictionary:listDic];
                model.searchStr = _HMH_searchTextField.text;
                [_HMH_dataSourceArr addObject:model];
            }
            if (_HMH_dataSourceArr.count > 0) {
                [self hideNoContentView];
            } else {
                [self showNoContentView];
            }
            [_tableView reloadData];
        }
    }
}


-(BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
