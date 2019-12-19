//
//  collectProductController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectProductController.h"
#import "CollectViewModel.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "CollectProductTableViewCell.h"
#import "CollectViewModel+loadData.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
@interface CollectProductController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * productTabView;
@property (nonatomic, strong) CollectViewModel * viewModel;
@end

@implementation CollectProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.productTabView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    [self.view addSubview:self.productTabView];
    
    @weakify(self);
    [self.viewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.productTabView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel jx_numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel jx_numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel jx_heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.viewModel jx_modelAtIndexPath:indexPath];
    
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [noRecordCell reloadString:@"您还没有我的商品收藏!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.productTabView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    [cell customViewWithData:model indexPath:indexPath];
    
    /** 删除数据源和刷新*/
    @weakify(self);
    if([cell isKindOfClass:[CollectProductTableViewCell class]]) {
      __weak CollectProductTableViewCell* newCell = (CollectProductTableViewCell *)cell;
        newCell.deleteAction = ^(NSIndexPath * _Nonnull path, NSDictionary * _Nonnull userDic) {
            [newCell.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            @strongify(self);
            /** 调用删除接口*/
            [[self.viewModel deleteProductCollectWithProuctID:objectOrEmptyStr([userDic objectForKey:@"productId"]) projectId:objectOrEmptyStr([userDic objectForKey:@"projectId"])] subscribeNext:^(NSNumber * x) {
                if ([x isEqual:@1]) {
                    NSLog(@"删除成功");
                    @strongify(self);
                    if (self.viewModel.mutableSource.count > path.row) {
                        [self.viewModel.mutableSource removeObjectAtIndex:path.row];
                        [self.productTabView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:path]
                                                   withRowAnimation:UITableViewRowAnimationFade];
                        [self.productTabView reloadData];
                    }  
                }else {
                    newCell.lastIndexPath = nil;
                    NSLog(@"删除失败");
                }
            }];
        };
        
        newCell.sliderAction = ^{
            @strongify(self);
            for (CollectProductTableViewCell *tableViewCell in self.productTabView.visibleCells) {
                /// 当屏幕滑动时，关闭不是当前滑动的cell
                if (tableViewCell.isOpen == YES && tableViewCell != cell) {
                    [tableViewCell.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
        };
    }
    return (UITableViewCell *)cell;
}

#pragma mark -- 路由传参
- (void)rounterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:MineProductCollect]) {
        NSString * type = [userInfo objectForKey:@"active"];
        if ([type isEqualToString:@"1"]) {
            AssembleGoodDetailViewController *goodsVC = [[AssembleGoodDetailViewController alloc] init];
            goodsVC.productId=objectOrEmptyStr([userInfo objectForKey:@"productId"]);
            goodsVC.assembleStyle=AssembleDetailStyle;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }else {
            SpGoodsDetailViewController *SpGoodsDetailVC=[[SpGoodsDetailViewController alloc]init];
            SpGoodsDetailVC.productId=objectOrEmptyStr([userInfo objectForKey:@"productId"]);
            SpGoodsDetailVC.goodsType=OrdinaryGoodsDetailStyle;
            [self.navigationController pushViewController:SpGoodsDetailVC animated:YES];
        }
    }
}

#pragma mark -- lazy load
- (UITableView *)productTabView {
    if (!_productTabView) {
        _productTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT - 40) style:UITableViewStylePlain];
        _productTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _productTabView.delegate = self;
        _productTabView.dataSource = self;
        _productTabView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _productTabView;
}

- (CollectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CollectViewModel alloc]init];
    }
    return _viewModel;
}


@end
