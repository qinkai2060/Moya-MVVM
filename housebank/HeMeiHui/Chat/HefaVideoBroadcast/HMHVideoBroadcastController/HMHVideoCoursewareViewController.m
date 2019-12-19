//
//  HMHVideoCategoryViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/6.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoCoursewareViewController.h"
#import "HMHVideoCoursewareCollectionViewCell.h"


@interface HMHVideoCoursewareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *HMH_blackView;
@property (nonatomic, strong) UIView *HMH_whiteView;

@property(nonatomic,strong)UICollectionView *HMH_collectionView;

@end

@implementation HMHVideoCoursewareViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        _HMH_blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        _HMH_whiteView.frame =CGRectMake(0,self.view.frame.size.width*9/16 + self.HMH_statusHeghit + 30, ScreenW, ScreenH-self.view.frame.size.width*9/16 - self.HMH_statusHeghit - self.HMH_buttomBarHeghit - 44);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self HMH_createUI];
    [self HMH_createCollectionView];
}

- (void)HMH_createUI{
    // HMH_blackView
    self.view.backgroundColor = [UIColor clearColor];
    _HMH_blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _HMH_blackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_HMH_blackView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_HMH_blackView addGestureRecognizer:tap];
    
    // HMH_whiteView
    _HMH_whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW,ScreenH - self.view.frame.size.width*9/16 - 44)];
    _HMH_whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_whiteView];
    
}

- (void)HMH_createCollectionView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 15;
    //最小两行之间的间距
    layout.minimumLineSpacing = 15;
    
    _HMH_collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,ScreenW,_HMH_whiteView.frame.size.height) collectionViewLayout:layout];
    _HMH_collectionView.backgroundColor=[UIColor whiteColor];
    
    _HMH_collectionView.delegate=self;
    _HMH_collectionView.dataSource=self;
    
    [_HMH_whiteView addSubview:_HMH_collectionView];
    
    //这种是自定义cell不带xib的注册
    //    [_HMH_collectionView registerClass:[VideoMoreCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"]; // 带有下载 和  百分比
    [_HMH_collectionView registerClass:[HMHVideoCoursewareCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
//    __weak typeof(self)weakSelf = self;
//    // 下拉刷新
//    _HMH_collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf refreshData];
//    }];
//    // 上拉刷新
//    _HMH_collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
//    }];
}

#pragma mark collectionView delegate
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _urlArr.count;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMHVideoCoursewareCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (self.urlArr.count > indexPath.row && self.titleArr.count > indexPath.row) {
        
        [cell refreshTableViewCellWithUrl:self.urlArr[indexPath.row] title:self.titleArr[indexPath.row]];
    }
    
    return cell;
}


//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW-45) / 2, (ScreenW-45) / 2 + 30);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.urlArr.count > indexPath.row) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",CurrentEnvironment,self.urlArr[indexPath.row]];
        NSString *encodUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",encodUrlString]];
        [[UIApplication sharedApplication] openURL:cleanURL];
    }
}


- (void)dismiss{
    self.view.backgroundColor = [UIColor clearColor];
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            _HMH_blackView.backgroundColor = [UIColor clearColor];
            _HMH_whiteView.frame =CGRectMake(0, ScreenH, ScreenW,ScreenH-self.view.frame.size.width*9/16 - 44);
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    });
}

@end
