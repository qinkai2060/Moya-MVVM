//
//  collectShopViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CollectShopViewController.h"
#import "CollectShopViewModel.h"
#import "JXEventProtocol.h"
#import "JXViewProtocol.h"
#import "CollectShopTableViewCell.h"
#import "HandleEventDefine.h"
#import "MyEmplyDataTableViewCell.h"
#import "MyJumpHTML5ViewController.h"
@interface CollectShopViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * shopTableView;
@property (nonatomic, strong) CollectShopViewModel * shopViewModel;
@end

@implementation CollectShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.shopTableView];
    [self.shopTableView registerClass:[MyEmplyDataTableViewCell class] forCellReuseIdentifier:@"MyEmplyDataTableViewCell"];
    
    @weakify(self);
    [self.shopViewModel.refreshUISubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.shopTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark -- TableView delegate # dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.shopViewModel jx_numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shopViewModel jx_numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.shopViewModel jx_heightAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JXModelProtocol> model = [self.shopViewModel jx_modelAtIndexPath:indexPath];
    
    /** 加载空数据页面*/
    if ([model.identifier isEqualToString:@"MyEmplyDataTableViewCell"]) {
        MyEmplyDataTableViewCell *noRecordCell = [tableView dequeueReusableCellWithIdentifier:@"MyEmplyDataTableViewCell"];
        noRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [noRecordCell reloadString:@"您还没有我的店铺收藏!"];
        return noRecordCell;
    }
    
    UITableViewCell<JXViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:objectOrEmptyStr(model.identifier)];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:model.identifier bundle:nil];
        [self.shopTableView registerNib:nib forCellReuseIdentifier:model.identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    }
    [cell customViewWithData:model indexPath:indexPath];
    
    /** 删除数据源和刷新*/
    @weakify(self);
    if([cell isKindOfClass:[CollectShopTableViewCell class]]) {
        __weak CollectShopTableViewCell* newCell = (CollectShopTableViewCell *)cell;
        newCell.deleteAction = ^(NSIndexPath * _Nonnull path, NSDictionary * _Nonnull userDic) {
            [newCell.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            @strongify(self);
            /** 调用删除接口*/
            [[self.shopViewModel deleteProductCollectWithProuctID:objectOrEmptyStr([userDic objectForKey:@"productId"]) projectId:objectOrEmptyStr([userDic objectForKey:@"projectId"])]subscribeNext:^(NSNumber * x) {
                  if ([x isEqual:@1]) {
                    if (self.shopViewModel.mutableSource.count > path.row) {
                          [self.shopViewModel.mutableSource removeObjectAtIndex:path.row];
                          [self.shopTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:path]
                                                    withRowAnimation:UITableViewRowAnimationFade];
                          [self.shopTableView reloadData];
                      }
                    
                  }else {
                      newCell.lastIndexPath = nil;
                      [SVProgressHUD showErrorWithStatus:@"删除收藏店铺失败!"];
                  }
            }];
        };
        
        newCell.sliderAction = ^{
            @strongify(self);
            for (CollectShopTableViewCell *tableViewCell in self.shopTableView.visibleCells) {
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

    if ([eventName isEqualToString:MineProductShop]) {
        NSString * type = [userInfo objectForKey:@"shopsType"];
        if ([type isEqualToString:@"2"] || [type isEqualToString:@"3"]) {
           
            NSString * url ;
            NSString * shopId = objectOrEmptyStr([userInfo objectForKey:@"productId"]);
            if ([type isEqualToString:@"3"]) {
                 // 微店
               url = [NSString stringWithFormat:@"/html/home/#/cloudShop/wMallShop??shopId=%@",shopId];
            }else if ([type isEqualToString:@"2"]){
                // 云店
               url = [NSString stringWithFormat:@"/html/home/#/cloudShop/yMallShop?shopId=%@",shopId];
            }
            NSString *strUrl = url;
            MyJumpHTML5ViewController * htmlVC = [[MyJumpHTML5ViewController alloc]init];
            htmlVC.webUrl = strUrl;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }else {
            ShopListViewController *shopVC = [[ShopListViewController alloc] init];
            shopVC.detailModel = [[GoodsDetailModel alloc] init];
            shopVC.detailModel.data = [[ProductDetail alloc] init];
            shopVC.detailModel.data.product = [[Product alloc] init];
            shopVC.detailModel.data.product.shopId = [objectOrEmptyStr([userInfo objectForKey:@"productId"]) integerValue];
            [self.navigationController pushViewController:shopVC animated:YES];
        }
    }
}

#pragma mark -- lazy load
- (CollectShopViewModel *)shopViewModel {
    if (!_shopViewModel) {
        _shopViewModel = [[CollectShopViewModel alloc]init];
    }
    return _shopViewModel;
}

- (UITableView *)shopTableView {
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-STATUSBAR_NAVBAR_HEIGHT - 40) style:UITableViewStylePlain];
        _shopTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        _shopTableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _shopTableView;
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
