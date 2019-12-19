//
//  AssembleSearchViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleSearchViewController.h"
#import "AssembleSearchMainView.h"


@interface AssembleSearchViewController ()<AssembleCateorySearchViewDelegate,UITextFieldDelegate,SearchTextViewDelegate>

@property (nonatomic, strong) AssembleSearchMainView *searchView;
@property (nonatomic, strong) NSMutableArray *dataHistoryArray;

@end
@implementation AssembleSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createView{
    _dataHistoryArray = [NSMutableArray arrayWithCapacity:1];
    //
    self.searchView = [[AssembleSearchMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit - [self statusChangedWithStatusBarH])];
    [self.view addSubview:self.searchView];
    self.searchView.delegate = self;
    self.searchView.searchView.delegate = self;
    self.searchView.searchView.searchTextField.delegate = self;
    self.searchView.searchView.searchTextField.tintColor = [UIColor colorWithHexString:@"#F3344A"];
    //    textField.tintColor = [UIColor redColor];
    
    // 实现搜索联想的功能 搜索停顿1秒后 调接口进行请求
    //    __block SpTypesSearchViewController *selfBlcok = self;
    //    [[[self.searchView.searchView.searchTextField rac_textSignal] throttle:1] subscribeNext:^(NSString * _Nullable x) {
    //        if (x.length > 0) {
    //            [selfBlcok laterExecuteWithText:x];
    //        }
    //    }];
}

//- (void)

/**
 返回按钮的点击事件
 */
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 搜索按钮的点击事件 此处是跳转
 */
- (void)searchBtnClick{
}

/**
 左右侧按钮的点击事件
 */
- (void)searchRightBtnClick:(UIButton *)btn{
    [self.searchView.searchView.searchTextField resignFirstResponder];
    self.searchView.searchView.searchTextField.text = @"";
}
// 取消按钮的点击事件
- (void)lianXiangSearchCancelBtnClick:(UIButton *)btn{
    [self.searchView.searchView.searchTextField resignFirstResponder];
    self.searchView.searchView.searchTextField.text = @"";
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.searchView refreshViewWithArr:_dataHistoryArray];
}

// 历史搜索列表 点击
- (void)tableViewDidSelectedWithIndexRow:(NSInteger)indexRow searchText:(NSString *)searchText{
    
    self.searchView.searchView.searchTextField.text = searchText;
    [self searchVideoResult];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[AssembleSearchListViewController class]]) {
            AssembleSearchListViewController *vc = (AssembleSearchListViewController *)temp;
            vc.searchStr = searchText;
            vc.classId = @" ";
            vc.level = @" ";
            vc.isFristIn = YES;
            [self.navigationController popToViewController:temp animated:NO];
            return;
        }
    }
    
    AssembleSearchListViewController *listVC = [[AssembleSearchListViewController alloc] init];
    listVC.searchStr = searchText;
    listVC.classId = @" ";
    listVC.level = @" ";
    listVC.isFristIn = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma textfieldDelegate =======
// textField 右侧清除按钮的点击事件
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.searchView.searchView.searchTextField resignFirstResponder];
    self.searchView.searchView.searchTextField.text = @"";
    
    [self.searchView refreshViewWithArr:_dataHistoryArray];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    [self searchVideoResult];
    return YES;
}

// 搜索具体方法的实现
- (void)searchVideoResult{
    [self.searchView.searchView.searchTextField resignFirstResponder];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *searchArray = [ud objectForKey:@"SpTypesSearchText"];
    if (self.dataHistoryArray.count > 0) {
        [self.dataHistoryArray removeAllObjects];
    }
    if (searchArray.count){
        _dataHistoryArray = [NSMutableArray arrayWithArray:searchArray];
    }
    
    NSString *searchStr = [self.searchView.searchView.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchStr.length==0) {
        searchStr = nil;
    }
    if (searchStr.length>0) {
        for (NSString *key in _dataHistoryArray) {
            if ([key isEqualToString:searchStr]) {
                [_dataHistoryArray removeObject:key];
                break ;
            }
        }
        [_dataHistoryArray insertObject:searchStr atIndex:0];
        if (_dataHistoryArray.count >7) {
            [_dataHistoryArray removeObjectAtIndex:7];
        }
    }
    [ud setObject:_dataHistoryArray forKey:@"SpTypesSearchText"];
    [ud synchronize];
    
    self.searchView.searchView.searchTextField.text = @"";
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[AssembleSearchListViewController class]]) {
            AssembleSearchListViewController *vc = (AssembleSearchListViewController *)temp;
            vc.searchStr = searchStr;
            vc.classId = @" ";
            vc.level = @" ";
            vc.isFristIn = YES;
            [self.navigationController popToViewController:temp animated:NO];
            return;
        }
    }
    
    AssembleSearchListViewController *listVC = [[AssembleSearchListViewController alloc] init];
    listVC.searchStr = searchStr;
    listVC.classId = @" ";
    listVC.level = @" ";
    listVC.isFristIn = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    
    [self.searchView refreshViewWithArr:_dataHistoryArray];
}

// 调联想的接口请求
- (void)laterExecuteWithText:(NSString *)searchText{
//    拼团搜索
    NSDictionary *dic = @{
                             @"pageNo":@"1",
                             @"pageSize":@"20",
                             @"keyword":searchText,
                             @"promotionType":@"2",
                             @"promotionStatus":@"",
                             @"classId":@"",
                             };
   
    //    NSString *encodUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (self.searchView.searchView.searchTextField.text.length > 0) {
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.mall/promotion/search"];
        if (getUrlStr) {
            getUrlStr =getUrlStr;
        }
        [self requestDataWithUrl:getUrlStr requestDic:dic];
    }
}

// 数据请求
- (void)requestDataWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:nil requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
            [self getSeconddata:dict];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
// 联想搜索 数据返回
- (void)getSeconddata:(id)resDic{
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *dic in resDic[@"data"]) {
            NSString *suggWord = dic[@"suggWord"];
            [arr addObject:suggWord];
        }
        [self.searchView refreshTableViewWithDataSource:arr];
    } else {
        NSLog(@"搜索为空了");
    }
}


@end
