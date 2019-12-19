//
//  VipGoodsPlayViewController.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGoodsPlayViewController.h"
#import "VipPlayCollectionViewCell.h"
#import "VipGoodsPlayDetailController.h"
#import "VipGiftPlayListViewModel.h"
#import "EmptyModel.h"
#import "VipGiftListModel.h"
#import "WRNavigationBar.h"
@interface VipGoodsPlayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *playCollectionView;
@property (nonatomic, strong)VipGiftPlayListViewModel * listViewModel;
@end

@implementation VipGoodsPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.playCollectionView];
    @weakify(self);
    self.playCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.listViewModel loadVIP_PlayListRequestShow]subscribeNext:^(RACTuple * x) {
            @strongify(self);
            NSDictionary * firstDic = x.first;
            BOOL hidden = [self updateUIWtihDic:firstDic];
            if (!hidden) {
                NSMutableArray * secondArray = x.last;
                if (secondArray.count == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showNoDataView];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.playCollectionView reloadData];
                    });
                }
                
                [self.playCollectionView.mj_footer resetNoMoreData];
                [self.playCollectionView.mj_header endRefreshing];
            }
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
            [self.playCollectionView.mj_header endRefreshing];
        }];
    }];
    
    /** 上拉加载*/
    self.playCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.listViewModel loadMoreVIP_PlayListRequestShow] subscribeNext:^(RACTuple * x) {
            /** 取加载增加的数据*/
            NSArray * addSource = x.first;
            if (addSource.count == 0) {
                [self.playCollectionView.mj_footer endRefreshing];
                [self.playCollectionView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
            /** 总数据*/
            NSMutableArray * dataSource = x.last;
            if (dataSource.count > 0 && dataSource) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.playCollectionView reloadData];
                    [self.playCollectionView.mj_footer endRefreshing];
                });
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorAlert = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:objectOrEmptyStr(errorAlert)];
        }];
    }];
    
    [self.playCollectionView.mj_header beginRefreshing];
    
}

- (void)showNoDataView {
    self.noContentImageName = @"SpType_search_noContent";
    self.noContentText = @"抱歉，这个星球找不到呢！";
    [self showNoContentView];
    [self.playCollectionView.mj_header endRefreshing];
    [self.playCollectionView.mj_footer endRefreshing];
    [self.playCollectionView.mj_footer endRefreshingWithNoMoreData];
}

- (BOOL)updateUIWtihDic:(NSDictionary *)dic {
    NSNumber * moduleStatus = [dic objectForKey:@"moduleStatus"];
    if ([moduleStatus integerValue] == 1) {
        [self showNoDataView];
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.navigationController.navigationBar setHidden:YES];
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"icon_vipback"]];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_vipback"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = btn;
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"Vip_playBG"];
    UIImageView * center = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Vip_center_image"]];
    [self.customNavBar addSubview:center];
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.customNavBar).offset(-12);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.customNavBar);
    }];
    
    UIButton * item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customNavBar addSubview:item1];
    item1.frame = CGRectMake(kWidth-60, 0, 50, 50);
    item1.centerY=self.customNavBar.centerY+StatusBarHeight/2;
    [item1 setImage:[UIImage imageNamed:@"forward111"] forState:UIControlStateNormal];
    @weakify(self);
    [[item1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[self.listViewModel load_shareVideoRequest]subscribeNext:^(NSDictionary * x) {
            if (x) {
                NSDictionary *dic = @{
                                      @"shareDesc":@"",
                                      @"shareImageUrl":[NSURL URLWithString:objectOrEmptyStr([x objectForKey:@"shareImageUrl"])],
                                      @"shareTitle":objectOrEmptyStr([x objectForKey:@"shareTitle"]),
                                      @"shareUrl":objectOrEmptyStr([x objectForKey:@"shareUrl"]),
                                      @"longUrl":@"",
                                      @"shareWeixinUrl":objectOrEmptyStr([x objectForKey:@"shareUrl"]),
                                      @"justUrl":@(YES)
                                      };
                [ShareTools  shareWithContent:dic];
            }
        } error:^(NSError * _Nullable error) {
            NSString * errorString = [error.userInfo objectForKey:@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        }];
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----------- collectionView  Delegate . dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listViewModel.dataSource.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"UICollectionCell";
    VipPlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.listViewModel.dataSource.count > indexPath.row) {
        cell.listModel = self.listViewModel.dataSource[indexPath.row];
    }
    return cell;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VipGoodsPlayDetailController * detailVC = [[VipGoodsPlayDetailController alloc]init];
    if (self.listViewModel.dataSource.count > indexPath.row) {
        VipGiftListModel *listModel = self.listViewModel.dataSource[indexPath.row];
        detailVC.listModel = listModel;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- lazy load
- (UICollectionView *)playCollectionView {
    if (!_playCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((kWidth-45)/2,120);
        _playCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, STATUSBAR_NAVBAR_HEIGHT-3, ScreenW, kHeight-STATUSBAR_NAVBAR_HEIGHT) collectionViewLayout:flowLayout];
        _playCollectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _playCollectionView.dataSource = self;
        _playCollectionView.delegate = self;
        _playCollectionView.showsHorizontalScrollIndicator = NO;
        _playCollectionView.showsVerticalScrollIndicator = NO;
        _playCollectionView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
        [_playCollectionView registerNib:[UINib nibWithNibName:@"VipPlayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UICollectionCell"];
        _playCollectionView.pagingEnabled = NO;
    }
    return _playCollectionView;
}

- (VipGiftPlayListViewModel *)listViewModel {
    if(!_listViewModel) {
        _listViewModel = [[VipGiftPlayListViewModel alloc]init];
    }
    return _listViewModel;
}

@end
