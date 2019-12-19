//
//  collectGlobalHomeViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectGlobalHomeViewController.h"
#import "CollectGlobalViewModel.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "CollectGlobalHomeViewCell.h"
#import "HandleEventDefine.h"
#import "HFShouYinViewController.h"
#import "MyEmplyDataTableViewCell.h"
#import "EmptyModel.h"
@interface CollectGlobalHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * globalTableView;
@property (nonatomic, strong) CollectGlobalViewModel * globalViewModel;

@end

@implementation CollectGlobalHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.globalTableView];
    [self.globalTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    @weakify(self);
    [self.globalViewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.globalTableView reloadData];
    }];
    
    // 下拉刷新
    self.globalTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[self.globalViewModel loadRequest_GlobalHome]subscribeNext:^(NSMutableArray * x) {
        if (x.count == 0) {
           self.globalViewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
        }else {
            [self.globalTableView.mj_footer resetNoMoreData];
        }
        [self.globalTableView.mj_header endRefreshing];
        [self.globalTableView reloadData];
        }];
    }];
    
    // 上拉刷新
    self.globalTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [[self.globalViewModel loadMoreRequest_GlobalHome]subscribeNext:^(RACTuple * x) {
            NSArray * lastArray = x.last;
            if (lastArray.count == 0) {
                [self.globalTableView.mj_footer endRefreshing];
                [self.globalTableView.mj_footer endRefreshingWithNoMoreData];
                return ;
          }
            /** 总数据*/
            NSMutableArray * dataSource = x.first;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.globalTableView.mj_footer endRefreshing];
                    [self.globalTableView reloadData];
                });
            }
        }];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.globalViewModel jx_numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.globalViewModel jx_numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.globalViewModel jx_heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.globalViewModel jx_modelAtIndexPath:indexPath];
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [noRecordCell reloadString:@"您还没有我的全球家收藏!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.globalTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    [cell customViewWithData:model indexPath:indexPath];
    
    /** 删除数据源和刷新*/
    @weakify(self);
    if([cell isKindOfClass:[CollectGlobalHomeViewCell class]]) {
        __weak CollectGlobalHomeViewCell* newCell = (CollectGlobalHomeViewCell *)cell;
        newCell.deleteAction = ^(NSIndexPath * _Nonnull path, NSDictionary * _Nonnull userDic) {
            [newCell.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            @strongify(self);
            /** 调用删除接口*/
            [[self.globalViewModel deleteProductCollectWithHotelld:objectOrEmptyStr([userDic objectForKey:@"hotelId"])]subscribeNext:^(NSNumber * x) {
                if ([x isEqual:@1]) {
                    if (self.globalViewModel.mutableSource.count > path.row) {
                        [self.globalViewModel.mutableSource removeObjectAtIndex:path.row];
                        [self.globalTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:path]
                                                    withRowAnimation:UITableViewRowAnimationFade];
                        if (self.globalViewModel.mutableSource.count == 0) {
                            self.globalViewModel.mutableSource = [NSMutableArray arrayWithObject:[EmptyModel new]];
                        }
                        [self.globalTableView reloadData];                     }
                   
                }else {
                    newCell.lastIndexPath = nil;
                    [SVProgressHUD showErrorWithStatus:@"删除收藏全球家失败!"];
                }
            }];
        };
        
        newCell.sliderAction = ^{
            @strongify(self);
            for (CollectGlobalHomeViewCell *tableViewCell in self.globalTableView.visibleCells) {
                /// 当屏幕滑动时，关闭不是当前滑动的cell
                if (tableViewCell.isOpen == YES && tableViewCell != cell) {
                    [tableViewCell.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
        };
    }
    return (UITableViewCell *)cell;
}

/** 路由及跳转*/
- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:MineGlobalHome]) {
        HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
        newsView.isMore=YES;
        [newsView setShareUrl:[NSString stringWithFormat:@"%@/html/home/#/global/hotelDetails?sid=%@&hotelId=%@",fyMainHomeUrl,[HFCarShoppingRequest sid],objectOrEmptyStr([userInfo objectForKey:@"hotelId"])]];
        newsView.fromeSource=@"globleNewsVC";
        [self.navigationController pushViewController:newsView animated:YES];
    }
}

#pragma mark -- lazy load
- (CollectGlobalViewModel *)globalViewModel {
    if (!_globalViewModel) {
        _globalViewModel = [[CollectGlobalViewModel alloc]init];
    }
    return _globalViewModel;
}

- (UITableView *)globalTableView {
    if (!_globalTableView) {
        _globalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT-40) style:UITableViewStylePlain];
        _globalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _globalTableView.delegate = self;
        _globalTableView.dataSource = self;
        _globalTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _globalTableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
