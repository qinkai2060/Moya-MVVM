//
//  HMHLiveVideoHomeBaseViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeBaseViewController.h"

@interface HMHLiveVideoHomeBaseViewController ()

@end

@implementation HMHLiveVideoHomeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.HMH_buttomBarHeghit = 20;
    
    __weak HMHLiveVideoHomeBaseViewController *weakSelf = self;
    
//    [[HMHLiveCommendClassTools shareManager].currentScrollView.mj_header endRefreshing];
//    [[HMHLiveCommendClassTools shareManager].currentScrollView.mj_footer endRefreshing];
    
    
    [HMHLiveCommendClassTools shareManager].currentScrollView = self.tableView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
            [weakSelf loadData];
    }];
    
    [self addFooterRefresh];
    
    [self setSubviews];
    
    [self initNotification];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)addFooterRefresh {
    
  //  self.tableView.mj_footer = [MJRefreshBackNormalFooter];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

-(UITableView *)tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle ? self.tableViewStyle : UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
      //  _tableView.contentInset = UIEdgeInsetsMake(0, 0, self.HMH_buttomBarHeghit + 20, 0);
      //  _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 44 + self.HMH_buttomBarHeghit, 0);
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 80;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)loadData {
    [HMHLiveCommendClassTools shareManager].currentScrollView = self.tableView;
    
}

- (void)loadMoreData {
   
    
    
}



- (void)setSubviews {
    
    
}

- (void)initNotification {
    
}

- (void)removeNotification {
    
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark 

/**
 如果列表是VC，就返回VC.view
 如果列表是View，就返回View自己
 
 @return 返回列表视图
 */
- (UIView *)listView {
    return self.view;
}


/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear {
    
}

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear {
    
    
}

///**
// 可选实现，返回列表持有的滚动视图
// */
//- (UIScrollView *)listScrollView {
//    
//    
//}

//#pragma mark 生命周期方法
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self initNotification];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    [self removeNotification];
//}

- (void)dealloc {
    [self removeNotification];
    NSLog(@"销毁的控制器:%@",NSStringFromClass([self class]));
}


@end
