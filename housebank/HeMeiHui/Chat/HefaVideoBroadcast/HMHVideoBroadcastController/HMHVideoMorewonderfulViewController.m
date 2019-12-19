//
//  HMHVideoMorewonderfulViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoMorewonderfulViewController.h"
#import "HMHVideoMoreCollectionViewCell.h"
#import "HMHHomepageVideoCollectionViewCell.h"
#import "HMHVideoMoreDetailInfoViewController.h" // 更多精彩跳转回放页面
#import "HMHVideoMoreDetailLiveViewController.h" // 更多精彩跳转直播页面

@interface HMHVideoMorewonderfulViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,VideoMoreCollectionViewCellDelegate>

@property(nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;
@property (nonatomic, assign) NSInteger HMH_currrentPage;

@end

@implementation HMHVideoMorewonderfulViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    [self HMH_createCollectionView];
    [self refreshData];
}

- (void)HMH_createCollectionView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 10;
    //最小两行之间的间距
    layout.minimumLineSpacing = 10;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,ScreenW,ScreenH - 44 - self.view.frame.size.width*9/16 - 30 -self.HMH_statusHeghit - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [self.view addSubview:_collectionView];
    
    //这种是自定义cell不带xib的注册
//    [_collectionView registerClass:[HMHVideoMoreCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"]; // 带有下载 和  百分比
    [_collectionView registerClass:[HMHHomepageVideoCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)refreshData {
    _HMH_currrentPage = 1;
    [self loadData];
}

- (void)loadMoreData {
    _HMH_currrentPage ++;
    [self loadData];
}
- (void)loadData{
    NSString *urlStr = [NSString stringWithFormat:@"/video/search/%@/%@/%ld",@"similar",self.videoNum,(long)_HMH_currrentPage];
    [self requestData:nil withUrl:urlStr];
}


#pragma mark collectionView delegate
//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _HMH_dataSourceArr.count;
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HMHHomepageVideoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        [cell moreWonderfullWithModel:model];
    }
//    cell.delegate = self;
    
    return cell;
}


//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((ScreenW-30) / 2, 160);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击后移动的动画
    //    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];

//    NSLog(@"row == %ld,section == %ld",indexPath.row,indexPath.section);
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        if ([model.videoStatus isEqual:@2]) { // 直播
            HMHVideoMoreDetailLiveViewController *liveVC = [[HMHVideoMoreDetailLiveViewController alloc] init];
            liveVC.videoNum = model.vno;
            liveVC.indexSelected = @0;
            if (self.myBlock) {
                self.myBlock(liveVC);
            }
        } else {
            //
            HMHVideoMoreDetailInfoViewController *vc = [[HMHVideoMoreDetailInfoViewController alloc] init];
            //
            vc.videoNum = model.vno;
            vc.indexSelected = @0;
            
            if (self.myBlock) {
                self.myBlock(vc);
            }
        }
    }
}

#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url{

    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    
    __weak typeof(self)weakSelf = self;
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];

    [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf HMH_getPrcessdata:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
// 更多精彩
- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (_HMH_currrentPage == 1) {
            [_HMH_dataSourceArr removeAllObjects];
        }
        NSDictionary *dataDic = resDic[@"data"];
        
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *listDic in dataDic[@"list"]) {
                HMHVideoListModel *model = [[HMHVideoListModel alloc] init];
                [model setValuesForKeysWithDictionary:listDic];
                [_HMH_dataSourceArr addObject:model];
            }
        }
        if (_HMH_dataSourceArr.count > 0) {
            [self hideNoContentView];
        } else {
            [self showNoContentView];
        }
        [_collectionView reloadData];
    }
}

@end
