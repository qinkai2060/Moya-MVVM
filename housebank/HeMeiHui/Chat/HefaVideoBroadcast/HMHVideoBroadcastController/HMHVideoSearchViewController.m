//
//  HMHVideoSearchViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoSearchViewController.h"
#import "HMHSearchHistoryListTableViewCell.h"
#import "HMHVideoHotSearchListTableViewCell.h"
#import "HMHSearchHotLabView.h"


@interface HMHVideoSearchViewController ()<UITableViewDelegate,UITableViewDataSource,SearchHotLabViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *HMH_navView;
@property (nonatomic, strong) UITextField *HMH_searchTextField;
@property (nonatomic, strong) NSMutableArray *HMH_dataHistoryArray;

@property (nonatomic, strong) UITableView *HMH_tableview;
@property (nonatomic, strong) NSMutableArray *HMH_hotTagArr;
@property (nonatomic, strong) NSMutableArray *HMH_hotKeywordArr;

@end

@implementation HMHVideoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _HMH_dataHistoryArray = [[NSMutableArray alloc] initWithCapacity:1];
    _HMH_hotTagArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_hotKeywordArr = [NSMutableArray arrayWithCapacity:1];
    
    [self HMH_requestHotTagData];
    [self HMH_createNav];
    [self HMH_createUI];
    
    [self reloadHistoryData];
    [self HMH_requestHotSearchData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)HMH_createUI{
    _HMH_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit_wd + 44, ScreenW, ScreenH - self.HMH_statusHeghit_wd - 44) style:UITableViewStylePlain];
    _HMH_tableview.backgroundColor = RGBACOLOR(240, 241, 242, 1);

    _HMH_tableview.dataSource = self;
    _HMH_tableview.delegate = self;
    _HMH_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_HMH_tableview];
}
// 热门标签数据请求
- (void)HMH_requestHotTagData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-tag/tag-hot/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }
    [self requestData:nil withUrl:getUrlStr requestType:@"get" requestName:@"tag"];
}
//热门搜索
- (void)HMH_requestHotSearchData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-topsearchword/topsearchword/get"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }

//    [self requestData:nil withUrl:@"/video/top/search/word/" requestType:@"get" requestName:@"keyword"];
    [self requestData:nil withUrl:getUrlStr requestType:@"get" requestName:@"keyword"];
}


-(void)HMH_createNav{
    self.navigationController.navigationBarHidden = YES;
    
    _HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit_wd, ScreenW, 44)];
    _HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_navView];
    //
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 27, ScreenW - 40 - 60, 30)];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(40, 7, ScreenW - 40 - 60, 30)];
    bgView.backgroundColor = RGBACOLOR(233, 234, 235, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    [_HMH_navView addSubview:bgView];
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 7.5, 15, 15)];
    img.image = [UIImage imageNamed:@"VH_videoSearch"];
    [bgView addSubview:img];

    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=CGRectMake(0,20, 60, 44);
    backButton.frame=CGRectMake(0,0, 60, 44 -1);
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 44, 44 - 1)];
    backImageView.image=[UIImage imageNamed:@"VH_blackBack"];
    [backButton addSubview:backImageView];
    [_HMH_navView addSubview:backButton];

    _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
    _HMH_searchTextField.delegate = self;
    _HMH_searchTextField.returnKeyType = UIReturnKeySearch;
    _HMH_searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _HMH_searchTextField.text = self.searchKeyStr;
    _HMH_searchTextField.placeholder = @"请输入搜索内容";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    [bgView addSubview:_HMH_searchTextField];
    
    //
    UIButton *rightButton1=[UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton1.frame=CGRectMake(_HMH_navView.frame.size.width-54, 20, 44, 44);
    rightButton1.frame=CGRectMake(_HMH_navView.frame.size.width-54, 0, 44, 44 - 1);
    [rightButton1 setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton1 setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
    rightButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightButton1 addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_HMH_navView addSubview:rightButton1];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_navView.frame.size.height - 1, _HMH_navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [_HMH_navView addSubview:bottomLab];

}

// 返回上一页
- (void)gotoBack{

    [self.navigationController popViewControllerAnimated:YES];
}
// 搜索按钮的点击事件
- (void)searchBtnClick:(UIButton *)btn{
    if (_HMH_searchTextField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }

    [self searchVideoResult];
    
    [self searchRequestDataWithSearchType:@"keyword" searchValue:_HMH_searchTextField.text searchName:nil];
}
#pragma mark 搜索数据 跳转
- (void)searchRequestDataWithSearchType:(NSString *)searchType searchValue:(NSString *)searchValue searchName:(NSString *)searchName{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HMHVideosListViewController class]]) {
            HMHVideosListViewController *vc = (HMHVideosListViewController *)temp;
            vc.searchType = searchType;
            vc.searchValue = searchValue;
            vc.tagOrCategoryNameStr = searchName;
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    
    HMHVideosListViewController *listVC = [[HMHVideosListViewController alloc] init];
    listVC.searchType = searchType;
    listVC.searchValue = searchValue;
    listVC.tagOrCategoryNameStr = searchName;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)reloadHistoryData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *searchArray = [ud objectForKey:@"historySearchText"];
    if (searchArray.count){
        _HMH_dataHistoryArray = [NSMutableArray arrayWithArray:searchArray];
    }
    
    [_HMH_tableview reloadData];
}


#pragma mark 底部标签的点击事件
- (void)hotLabClickWithLabIndex:(NSInteger)labIndex{
    NSLog(@"labIndex === %ld",labIndex);
    // searchValue为 视频标签id
    if (_HMH_hotTagArr.count > labIndex) {
        HMHVideoTagsModel *model = _HMH_hotTagArr[labIndex];
        NSString *tagIDStr = [NSString stringWithFormat:@"%@",model.id];
        [self searchRequestDataWithSearchType:@"tag" searchValue:tagIDStr searchName:model.tagName];
    }
}

#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _HMH_dataHistoryArray.count;
    } else if (section == 1){
        return _HMH_hotKeywordArr.count;
    } else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HMHSearchHistoryListTableViewCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"history"];
        if (historyCell == nil) {
            historyCell = [[HMHSearchHistoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history"];
        }
        historyCell.backgroundColor = [UIColor whiteColor];
        historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_HMH_dataHistoryArray.count > indexPath.row) {
            [historyCell refreshCellWithSearchStr:_HMH_dataHistoryArray[indexPath.row]];
        }
        __weak typeof(self) weakSelf = self;
        historyCell.cancelBtnClickBlock = ^(HMHSearchHistoryListTableViewCell *cell) {
            [weakSelf deleteHistoryWithIndexPathRow:indexPath.row];
        };
        return historyCell;
        
    } else { // if (indexPath.section == 1)
        HMHVideoHotSearchListTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCell"];
        if (hotCell == nil) {
            hotCell = [[HMHVideoHotSearchListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCell"];
        }
        hotCell.backgroundColor = [UIColor whiteColor];
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_HMH_hotKeywordArr.count > indexPath.row) {
            HMHVideoTagsModel *model = _HMH_hotKeywordArr[indexPath.row];
            [hotCell refreshCellWithModel:model];

        }
        return hotCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_HMH_dataHistoryArray.count > indexPath.row) {
            NSString *selectStr = _HMH_dataHistoryArray[indexPath.row];
            
            [self searchRequestDataWithSearchType:@"keyword" searchValue:selectStr searchName:selectStr];
        }
    } else if (indexPath.section == 1){ // 热门搜索
        if (_HMH_hotKeywordArr.count > indexPath.row) {
            HMHVideoTagsModel *model = _HMH_hotKeywordArr[indexPath.row];
            [self searchRequestDataWithSearchType:@"keyword" searchValue:model.searchWord searchName:model.searchWord];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        headerView.backgroundColor =[UIColor whiteColor];
        //
        UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, headerView.frame.size.height - 1)];
        hotLab.font = [UIFont systemFontOfSize:16.0];
        hotLab.text = @"热门搜索";
        [headerView addSubview:hotLab];
        //
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, ScreenW, 1)];
        lineLab.backgroundColor = RGBACOLOR(239, 240, 241, 1);
        [headerView addSubview:lineLab];
        
        return headerView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        bgView.backgroundColor = RGBACOLOR(241, 242, 244, 1);
        
        //
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, ScreenW, bgView.frame.size.height - 5);
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitleColor:RGBACOLOR(73, 73, 75, 1) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancelBtn addTarget:self action:@selector(cancelHistoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        return bgView;
    }
    return [[UIView alloc] init];
}

#pragma mark 历史记录删除按钮的点击事件
- (void)deleteHistoryWithIndexPathRow:(NSInteger)indexPathRow{
    if (_HMH_dataHistoryArray.count > indexPathRow) {
        [_HMH_dataHistoryArray removeObjectAtIndex:indexPathRow];
        [_HMH_tableview reloadData];
    }
}


#pragma mark // 清空历史记录
- (void)cancelHistoryBtnClick:(UIButton *)btn{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"historySearchText"];

    [_HMH_dataHistoryArray removeAllObjects];
    [_HMH_tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45.0;
    } else {
        return 35.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (_HMH_hotKeywordArr.count > 0) {
            return 40.0;
        } else{
            return 0.0;
        }
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_HMH_dataHistoryArray.count == 0) {
        return 0.0;
    }
    
    if (section == 0) {
        return 40.0;
    }
    return 0.0;
}

#pragma textfieldDelegate =======
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_HMH_searchTextField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    [self searchVideoResult];
    [self searchRequestDataWithSearchType:@"keyword" searchValue:_HMH_searchTextField.text searchName:nil];
    
    return YES;
}

// 搜索具体方法的实现
- (void)searchVideoResult{
    [_HMH_searchTextField resignFirstResponder];
    
    NSString *searchStr = [_HMH_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchStr.length==0) {
        searchStr = nil;
    }
    //    if (self.searchStrBlock) {
    //        self.searchStrBlock(searchStr);
    //        if (self.navigationController.viewControllers.count>1) {
    //            [self.navigationController popViewControllerAnimated:YES];
    //        }
    //        else
    //        {
    //            [self dismissViewControllerAnimated:YES completion:nil];
    //        }
    //    }
    if (searchStr.length>0) {
        for (NSString *key in _HMH_dataHistoryArray) {
            if ([key isEqualToString:searchStr]) {
                [_HMH_dataHistoryArray removeObject:key];
                break ;
            }
        }
        
        [_HMH_dataHistoryArray insertObject:searchStr atIndex:0];
        if (_HMH_dataHistoryArray.count >3) {
            [_HMH_dataHistoryArray removeObjectAtIndex:3];
        }
    }
    [_HMH_tableview reloadData];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_HMH_dataHistoryArray forKey:@"historySearchText"];
    [ud synchronize];

}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 数据请求
#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url requestType:(NSString *)requestType requestName:(NSString *)requestName{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestMethod;
    if ([requestType isEqualToString:@"get"]) {
        requestMethod = YTKRequestMethodGET;
    }else if ([requestType isEqualToString:@"put"]) {
        requestMethod = YTKRequestMethodPUT;
    }else {
        requestMethod = YTKRequestMethodPOST;
    }
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.requestMethod == YTKRequestMethodGET ) {
            NSLog(@"成功");
            if ([requestName isEqualToString:@"tag"]) { // 热门标签
                [weakSelf HMH_getPrcessdata:request.responseObject];
            } else { // 热门搜索
                [self HMH_getKeywordData:request.responseObject];
            }
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}
// 热门标签
- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in resDic[@"data"]) {
                HMHVideoTagsModel *model =[[HMHVideoTagsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_HMH_hotTagArr addObject:model];
            }
        }
        
        HMHSearchHotLabView *searchV = [[HMHSearchHotLabView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200) withDataSource:_HMH_hotTagArr];
        searchV.delegate = self;
        CGFloat H = [HMHSearchHotLabView getLabsHeightWithModel:_HMH_hotTagArr];
        searchV.frame = CGRectMake(0, 0, ScreenW, H);
        
        _HMH_tableview.tableFooterView = searchV;
    }
}

//热门搜索
-(void)HMH_getKeywordData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([resDic[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in resDic[@"data"]) {
                HMHVideoTagsModel *model =[[HMHVideoTagsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_HMH_hotKeywordArr addObject:model];
            }
        }
        [_HMH_tableview reloadData];
    }
}
@end
