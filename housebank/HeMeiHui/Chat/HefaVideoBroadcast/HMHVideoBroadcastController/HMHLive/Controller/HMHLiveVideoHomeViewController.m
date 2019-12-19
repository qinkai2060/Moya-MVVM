//
//  HMHLiveVideoHomeViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeViewController.h"
#import "HMHLiveVideoHomeViewRecommendController.h"
#import "HMLiveVideoHomeViewAttentionViewController.h"
#import "HMLiveVideoHomeClassifyViewController.h"
#import "HMHLiveVideoHomeViewXLSController.h"
#import "HFLoginViewController.h"
#import "HMHLiveVideoHomeSearchView.h"
#import "HMHVideoSearchViewController.h"
#import "HMHVideoHistoryViewController.h"
@interface HMHLiveVideoHomeViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,HFLoginViewControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)JXCategoryTitleView *categoryView;

@property (nonatomic,strong)JXCategoryListContainerView *listContainerView;

@property (nonatomic,assign)NSUInteger lastIndex;

@property (nonatomic,strong)HMHLiveVideoHomeSearchView *serachView;



@end

@implementation HMHLiveVideoHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航View
    [self createNVView];
    
    //创建内容View
    [self createContentView];
    
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
//    if(self.navigationController.viewControllers.count > 1) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }

}
- (void)createNVView {
    
    UIView *nvView = [[UIView alloc] init];
    [self.view addSubview:nvView];
    nvView.frame = CGRectMake(0, 0,self.view.bounds.size.width, self.HMH_statusHeghit_wd + 44 + 40);
    nvView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    //返回
    UIButton *backBtn = [UIButton buttonWithType:0];
    [nvView addSubview:backBtn];
    backBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    backBtn.frame = CGRectMake(0, self.HMH_statusHeghit_wd, WScale(45), 44);
    [backBtn setImage:[UIImage imageNamed:@"back_light"] forState:UIControlStateNormal];
    @weakify(self)
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
    
    //分类
    UIButton *btnClassly = [UIButton buttonWithType:0];
    [nvView addSubview:btnClassly];
    btnClassly.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    btnClassly.frame = CGRectMake(ScreenW - WScale(40), self.HMH_statusHeghit_wd, WScale(40), 44);
    [btnClassly setImage:[UIImage imageNamed:@"icon_classly"] forState:UIControlStateNormal];
    [[btnClassly rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
     
        HMLiveVideoHomeClassifyViewController * vc = [[HMLiveVideoHomeClassifyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }];

    //历史
    UIButton *btnHistory = [UIButton buttonWithType:0];
    [nvView addSubview:btnHistory];
    btnHistory.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    btnHistory.frame = CGRectMake(ScreenW - WScale(80), self.HMH_statusHeghit_wd, WScale(40), 44);
    [btnHistory setImage:[UIImage imageNamed:@"icon_history"] forState:UIControlStateNormal];
    [[btnHistory rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        if (self.isJudgeLogin) {
        
            HMHVideoHistoryViewController* vc = [[HMHVideoHistoryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            //这里是没有登录
            
            [HFLoginViewController showViewController:self];
        }
    }];
    
    HMHLiveVideoHomeSearchView *searchView = [[HMHLiveVideoHomeSearchView alloc] initWithFrame:CGRectZero];
    self.serachView = searchView;
    [self.view addSubview:searchView];
    self.serachView.radius = WScale(15);
    self.serachView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [[self.serachView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }];
    
    [self.serachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(self.HMH_statusHeghit_wd + 7);
        make.leading.mas_equalTo(self.view.mas_leading).mas_offset(WScale(45));
        make.trailing.mas_equalTo(self.view.mas_trailing).mas_offset(-WScale(80));
        make.height.mas_equalTo(WScale(30));
    }];
    
    
    //第一步，创建头部View
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, self.HMH_statusHeghit_wd + 44,self.view.bounds.size.width,  40)];
    self.categoryView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.categoryView.delegate = self;
    [nvView addSubview:self.categoryView];
    self.categoryView.titles = @[@"关注", @"推荐", @"合美惠", @"涨知识", @"新零售"];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
    self.categoryView.contentEdgeInsetLeft = 20;
    self.categoryView.contentEdgeInsetRight = 20;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithRed:77/255.0 green:136/255.0 blue:255/255.0 alpha:1.0];
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    self.categoryView.defaultSelectedIndex = 1;
}

- (void)createContentView {
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithParentVC:self delegate:self];
    [self.view addSubview:self.listContainerView];
    self.listContainerView.defaultSelectedIndex = 1;
    self.lastIndex = self.listContainerView.defaultSelectedIndex;
 
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.categoryView.mas_bottom);
        
    }];
    [self.view layoutIfNeeded];
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
    
    [self.categoryView reloadData];
    [self.listContainerView reloadData];
    
}

//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    return self.navigationController.viewControllers.count > 1;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return self.navigationController.viewControllers.count > 1;
//}

#pragma mark <JXCategoryViewDelegate>

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    if (index == 0) {
        
        if (self.isJudgeLogin) {
            self.lastIndex = index;
            [self.listContainerView didClickSelectedItemAtIndex:self.lastIndex];
        } else {
            //这里是没有登录
            
            [HFLoginViewController showViewController:self];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.listContainerView.defaultSelectedIndex = self.lastIndex;
                self.categoryView.defaultSelectedIndex = self.lastIndex;
                [self.categoryView reloadData];
                [self.listContainerView reloadData];
            });
        }
        
        
    } else {
        
        self.lastIndex = index;
       [self.listContainerView didClickSelectedItemAtIndex:self.lastIndex];
    }
    
    
}


//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    if (leftIndex == 0) {
        
        if (self.isJudgeLogin) {
            self.lastIndex = rightIndex;
            [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
        } else {
            //这里是没有登录
            
            [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:1 ratio:ratio selectedIndex:categoryView.selectedIndex];
            
               
                [self.categoryView selectItemAtIndex:1];
                [self.categoryView reloadCellAtIndex:1];
                [self.categoryView reloadData];
                [self.listContainerView reloadData];
                
            [HFLoginViewController showViewController:self];
        }
        
        
    } else {
        
        self.lastIndex = rightIndex;
        [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
    }
    
//    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}


#pragma mark <JXCategoryListContainerViewDelegate>

//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}
//返回遵从`JXCategoryListContentViewDelegate`协议的实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    id vc = nil;
    
    switch (index) {
        case 0:
        {
            vc = [HMLiveVideoHomeViewAttentionViewController new];
            ((HMLiveVideoHomeViewAttentionViewController *)vc).isShowSearch = false;
            
            break;
            
        }
        case 2:
        case 3:
        case 4:
        {
            HMHLiveVideoHomeViewXLSController *listVc = [HMHLiveVideoHomeViewXLSController new];
            
            if (index == 2) {
                listVc.searchType = @"module";
                listVc.searchValue = @"mall";
            } else if (index == 3) {
                listVc.searchType = @"scene";
                listVc.searchValue = @"wellchosen";
            } else {
                listVc.searchType = @"module";
                listVc.searchValue = @"oto";
            }
            
            return listVc;
            
            break;
        }
            
        case 1:
        {
            vc = [[HMHLiveVideoHomeViewRecommendController alloc] init];
            break;
        }

        case 5:
        {
            vc = [HMLiveVideoHomeClassifyViewController new];
            break;
        }

        default:
            break;
    }
    
    ((HMHLiveVideoHomeBaseViewController *) vc).nvController = self.navigationController;
    
    return vc;
    
}

#pragma mark <HFLoginViewControllerDelegate>

- (void)loginViewController:(HFLoginViewController *)viewcontroller loginFinsh:(NSDictionary *)loginData {
    self.lastIndex = 0;
        [self.listContainerView didClickSelectedItemAtIndex:self.lastIndex];
        [self.categoryView selectItemAtIndex:self.lastIndex];
        [self.categoryView reloadCellAtIndex:self.lastIndex];
        [self.categoryView reloadData];
        [self.listContainerView reloadData];
    //[self.listContainerView didClickSelectedItemAtIndex:0];
}

@end
