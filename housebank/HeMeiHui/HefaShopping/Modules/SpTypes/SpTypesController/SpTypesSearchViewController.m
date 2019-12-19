//
//  SpTypesSearchViewController.m
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchViewController.h"
#import "SpTypesSearchMainView.h"
#import "SpeakTextField.h"
#import "SpeakPopView.h"
@interface SpTypesSearchViewController ()<CateorySearchViewDelegate,UITextFieldDelegate,SearchTextViewDelegate>

@property (nonatomic, strong) SpTypesSearchMainView *searchView;
@property (nonatomic, strong) NSMutableArray *dataHistoryArray;

@end
@implementation SpTypesSearchViewController
- (instancetype)init {
    if(self = [super init]){
//        for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
//            if ([v isKindOfClass:[SpeakPopView class]]) {
//                [v removeFromSuperview];
//            }
//        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    self.searchView.searchView.searchTextField.text = self.txt;
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
    self.searchView = [[SpTypesSearchMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit - [self statusChangedWithStatusBarH])];
    if (self.searchTypes==GlobalHomeSearchType) {
        self.searchView.searchViewType=GlobalHomeSearchViewType;
    }else
    {
        self.searchView.searchViewType=OrdinarySearchViewType;
    }
    [self.view addSubview:self.searchView];
    self.searchView.delegate = self;
    self.searchView.searchView.delegate = self;
    self.searchView.searchView.searchTextField.delegate = self;
    @weakify(self);
    self.searchView.searchView.searchTextField.speakPopView.callBackBlock = ^(NSString * _Nonnull string) {
        @strongify(self)
        self.searchView.searchView.searchTextField.text = string;
        if (self.searchView.searchView.searchTextField.text >0) {
            if (self.searchTypes==GlobalHomeSearchType) {//全球家首页
                [self.delegate BringBackSearchText:self.searchView.searchView.searchTextField.text];
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                [self searchVideoResult];
            }
        }
 
    };
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
    
    [self.navigationController popViewControllerAnimated:NO];

//    [self.searchView refreshViewWithArr:_dataHistoryArray];
}

// 历史搜索列表 点击
- (void)tableViewDidSelectedWithIndexRow:(NSInteger)indexRow searchText:(NSString *)searchText{
     self.searchView.searchView.searchTextField.text = searchText;
    if (self.searchTypes==GlobalHomeSearchType) {//全球家首页
         [self.delegate BringBackSearchText:searchText];
         [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self searchVideoResult];
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[SpTypesSearchListViewController class]]) {
                SpTypesSearchListViewController *vc = (SpTypesSearchListViewController *)temp;
                vc.searchStr = searchText;
                vc.classId = @" ";
                vc.level = @" ";
                vc.isFristIn = YES;
                [self.navigationController popToViewController:temp animated:NO];
                return;
            }
        }
        
        SpTypesSearchListViewController *listVC = [[SpTypesSearchListViewController alloc] init];
        @weakify(self)
        listVC.textFiledTextBlock = ^(NSString * _Nonnull str) {
            @strongify(self)
            self.searchView.searchView.searchTextField.text = str;
        };
        listVC.searchStr = searchText;
        listVC.classId = @" ";
        listVC.level = @" ";
        listVC.isFristIn = YES;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
   
  
}

#pragma textfieldDelegate =======
// textField 右侧清除按钮的点击事件
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.searchView.searchView.searchTextField resignFirstResponder];
    self.searchView.searchView.searchTextField.text = @"";
    
    [self.searchView refreshViewWithArr:_dataHistoryArray];
    return YES;
}
//区分全球家首页搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self.searchView.searchView.searchTextField resignFirstResponder];
    if (textField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    if (self.searchTypes==GlobalHomeSearchType) {//全球家首页
         [self.delegate BringBackSearchText:textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
       [self searchVideoResult];
    }
   
    return YES;
}
- (void)setTx:(NSString *)text {
    
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
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SpTypesSearchListViewController class]]) {
            SpTypesSearchListViewController *vc = (SpTypesSearchListViewController *)temp;
            vc.searchStr = searchStr;
            vc.classId = @" ";
            vc.level = @" ";
            vc.isFristIn = YES;
            [self.navigationController popToViewController:temp animated:NO];
            return;
        }
    }
    
    SpTypesSearchListViewController *listVC = [[SpTypesSearchListViewController alloc] init];
    @weakify(self)
    listVC.textFiledTextBlock = ^(NSString * _Nonnull str) {
        @strongify(self)
        self.searchView.searchView.searchTextField.text = str;
    };
    listVC.searchStr = searchStr;
    listVC.classId = @" ";
    listVC.level = @" ";
    listVC.isFristIn = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    
    [self.searchView refreshViewWithArr:_dataHistoryArray];
}

// 调联想的接口请求
- (void)laterExecuteWithText:(NSString *)searchText{
    NSDictionary *dic = @{
                          @"keyword":searchText
                          };
//    NSString *encodUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (self.searchView.searchView.searchTextField.text.length > 0) {
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"search.mall/goods/match"];
        if (getUrlStr) {
            getUrlStr =getUrlStr;
        }

        [self requestDataWithUrl:getUrlStr requestDic:dic];
    }
}

// 数据请求
- (void)requestDataWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    @weakify(self);
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:@{} requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
            @strongify(self);
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

//- (void)dealloc {
//    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
//        if ([v isKindOfClass:[SpeakPopView class]]) {
//            [v removeFromSuperview];
//        }
//    }
//}


@end
