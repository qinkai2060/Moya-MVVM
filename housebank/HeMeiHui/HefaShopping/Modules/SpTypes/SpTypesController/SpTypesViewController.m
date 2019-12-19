//
//  SpTypesViewController.m
//  HefaGlobal
//
//  Created by zhuchaoji on 2018/9/6.
//  Copyright © 2018年 合发全球. All rights reserved.
//

#import "SpTypesViewController.h"
#import "SpTypesMainView.h"
#import "SpTypesSearchViewController.h"



@interface SpTypesViewController ()<CateorySearchViewDelegate,RightCollectionViewDelegate>

@property (nonatomic, strong) SpTypesMainView *mainView;

@property (nonatomic, assign) NSInteger type;//1 一级界面 2 二级界面

@end

@implementation SpTypesViewController
- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self createView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden=NO;
     self.hidesBottomBarWhenPushed=NO;
    // 防止中途断网 分类页面无刷新的情况
    if (self.mainView) {
        [self.mainView refreshMainUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createView{
    //
    if (self.type ==1) {
            self.mainView = [[SpTypesMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH - self.statusHeghit - self.buttomBarHeghit - 44)withType:self.type];
    }else {
            self.mainView = [[SpTypesMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit, ScreenW, ScreenH  - 44)withType:self.type];
    }

    self.mainView.delegate = self;
    [self.view addSubview:self.mainView];
    
    self.mainView.searchView.delegate = self;
}

#pragma mark searchViewDelegate  返回按钮
- (void)backBtnClick{
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    MainTabBarViewController *VC=(MainTabBarViewController *)app.window.rootViewController;
//    VC.selectedIndex=0;
//    VC.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
   
}
// 搜索按钮的点击事件
- (void)searchBtnClick{
    SpTypesSearchViewController *searchVC = [[SpTypesSearchViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
// 右侧按钮的点击事件
- (void)searchRightBtnClick:(UIButton *)btn {
    NSLog(@"右侧按钮的点击事件");
}


#pragma mark collectionViewDelegate
// 更多按钮的点击事件
- (void)collectionViewSectionMoreBtnClickWithSection:(NSInteger)section dataSourceModel:(nonnull SpTypeFirstLevelModel *)model{
//    NSLog(@"更多 %ld",section);
    
    SpTypesSearchListViewController *searchVC = [[SpTypesSearchListViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    searchVC.classId = model.levelId;
    searchVC.level = model.classifyGrade;
//    searchVC.searchStr = model.classifyName;
    searchVC.isFristIn = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
// collectioncell的点击事件
- (void)collectionViewCellSelectedWithIndexSection:(NSInteger)section indexRow:(NSInteger)indexRow dataSourceArr:(nonnull NSArray *)modelArr{
    
    SpTypesSearchListViewController *searchVC = [[SpTypesSearchListViewController alloc] init];
    self.tabBarController.tabBar.hidden = YES;
    if (modelArr.count > indexRow) {
        NSDictionary *dic = modelArr[indexRow];
        searchVC.classId = dic[@"id"];
        searchVC.level = dic[@"classifyGrade"];
//        searchVC.searchStr = dic[@"classifyName"];
        searchVC.isFristIn = YES;
    }

    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
