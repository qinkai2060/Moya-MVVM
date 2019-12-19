//
//  STShoppingAddressViewController.m
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STShoppingAddressViewController.h"
#import "STShoppingAddressMainView.h"

@interface STShoppingAddressViewController ()<CateorySearchViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) STShoppingAddressMainView *mainView;

@property (nonatomic, strong) NSMutableArray *dataHistoryArray;

@end

@implementation STShoppingAddressViewController

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
    self.dataHistoryArray = [NSMutableArray arrayWithCapacity:1];
    //
    self.mainView = [[STShoppingAddressMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit - [self statusChangedWithStatusBarH])];
    [self.view addSubview:self.mainView];
    
    self.mainView.searchView.delegate = self;
    self.mainView.searchView.searchTextField.delegate = self;
}

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
    [self.mainView.searchView.searchTextField resignFirstResponder];
    self.mainView.searchView.searchTextField.text = @"";
}

#pragma textfieldDelegate =======
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    [self searchVideoResult];
    //    [self searchRequestDataWithSearchType:@"keyword" searchValue:_searchTextField.text searchName:nil];
    
    return YES;
}

// 搜索具体方法的实现
- (void)searchVideoResult{
    [self.mainView.searchView.searchTextField resignFirstResponder];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSArray *searchArray = [ud objectForKey:@"SpAddressSearchText"];
    if (searchArray.count){
        _dataHistoryArray = [NSMutableArray arrayWithArray:searchArray];
    }
    
    
    NSString *searchStr = [self.mainView.searchView.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
        if (_dataHistoryArray.count >3) {
            [_dataHistoryArray removeObjectAtIndex:3];
        }
    }
    [ud setObject:_dataHistoryArray forKey:@"SpAddressSearchText"];
    [ud synchronize];
    
    [self.mainView.topView refreshCollectionHistoryCity];
//    [self.searchView refreshViewWithArr:_dataHistoryArray];
}


@end
