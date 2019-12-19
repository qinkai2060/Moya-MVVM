//
//  HMHLiveVideoHomeViewXLSController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/29.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeViewXLSController.h"
#import "HMHLiveVideoHomeSearchView.h"
#import "HMLiveRecommendAttentionCell.h"
#import "HMHVideoSearchViewController.h"

@interface HMHLiveVideoHomeViewXLSController ()


@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;

@property (nonatomic, assign) NSInteger HMH_currrentPage;

@property (nonatomic,strong)NSMutableArray<HMHVideoListNewModel *> *modelArray;

@end

@implementation HMHLiveVideoHomeViewXLSController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.modelArray = [NSMutableArray array];
    [self refreshData];

}

- (void)setSubviews {
    
    self.nvController = [HMHLiveCommendClassTools shareManager].nvController;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(WScale(10));
    }];
    
    //注册cell
    [self.tableView registerClass:[HMLiveRecommendAttentionCell class] forCellReuseIdentifier:@"HMLiveRecommendAttentionCell"];
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)refreshData {
    self.currentPage = 1;
    [self loadData];
}

- (void)loadMoreData {
    self.currentPage++ ;
    [self loadData];
}

- (void)loadData{
    [super loadData];
    
    if (self.searchType.length > 0  && self.searchValue.length > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"/video/search/%@/%@/%ld",self.searchType,self.searchValue,(long)self.currentPage];
        
        if ([self.searchType isEqualToString:@"keyword"]) { // 搜索
//            NSString *encodUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [self requestData:nil withUrl:encodUrlString];
            
        } else {
            [self requestData:nil withUrl:urlStr];
        }
    }
}

#pragma mark <UITableViewDelegate,UITableViewDatasource>
#pragma mark <UITableViewDelegate,UITableViewDatasource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.modelArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HMLiveRecommendAttentionCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HMLiveRecommendAttentionCell" forIndexPath:indexPath];
    cell.listNewModel = self.modelArray[indexPath.section];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = 0.0;
    if (section == 0) {
        height = 0.1;
    } else {
        height = WScale(15);
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [UIView new];
    headView.alpha = 0.02;
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [UIView new];
    footView.alpha = 0.02;
    return footView;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _HMH_dataSourceArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    HMHVideosListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[HMHVideosListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (_HMH_dataSourceArr.count > indexPath.row) {
//        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
//        [cell refreshCellWithModel:model];
//    }
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (_HMH_dataSourceArr.count > indexPath.row) {
//        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
//        if ([model.sceneType isEqualToNumber:@1]) { // 短视频
//            HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
//            shortVC.videoNo = model.vno;
//            [self.navigationController pushViewController:shortVC         animated:YES];
//        } else {  // 普通视频
//            // 视频播放状态（1预告、2直播中、3已结束、 4:回放）
//            if ([model.videoStatus isEqualToNumber:@1]) { // 预告
//                // 如果预告中 当前剩余时间小于0 就跳转直播 反之 跳转预告
//                if ([model.liveLeftTime longLongValue] < 0) { // 直播
//                    HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
//                    liveVC.indexSelected = @0;
//                    liveVC.videoNum = model.vno;
//                    [self.navigationController pushViewController:liveVC animated:YES];
//                } else { // 预告
//                    HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
//                    preview.videoNum = model.vno;
//                    preview.indexSelected = @0;
//                    [self.navigationController pushViewController:preview animated:YES];
//                }
//            }  else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
//                HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
//                liveVC.indexSelected = @0;
//                liveVC.videoNum = model.vno;
//                [self.navigationController pushViewController:liveVC animated:YES];
//            }  else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
//                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
//                liveVC.indexSelected = @0;
//                liveVC.videoNum = model.vno;
//                [self.navigationController pushViewController:liveVC animated:YES];
//            } else { // 已结束
//
//            }
//        }
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return (ScreenW - 20) / 5 * 2 * 0.618 + 10;
//}
//
//// 返回按钮
//- (void)gotoBack{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//// 搜索按钮
//- (void)searchBtnClick:(UIButton *)btn{
//    // 防止循环push
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[HMHVideoSearchViewController class]]) {
//            //            HMHVideoSearchViewController *vc = (HMHVideoSearchViewController *)temp;
//            [self.navigationController popToViewController:temp animated:YES];
//            return;
//        }
//    }
//
//    HMHVideoSearchViewController *searchVC = [[HMHVideoSearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [weakSelf HMH_getPrcessdata:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        if (self.modelArray.count == 0) {
        [weakSelf showNoContentView:YES];
        }
    }];
}

- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (self.currentPage == 1) {
            [self.modelArray removeAllObjects];
        }
        
        id temp = resDic[@"data"];
        
        if ([temp isKindOfClass:[NSNull class]]) {
            
            return;
        }
        
        if (self.modelArray.count > 0) {
            [self hideNoContentView];
        } else {
            self.noContentImageName = @"SpType_search_noContent";

            [self showNoContentView:YES];
        }
        
        NSDictionary *dataDic = resDic[@"data"];
        
        if ([dataDic isKindOfClass:[NSNull class]]) {
            return;
        }
        
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            
            NSArray *tempModelArray = [NSArray modelArrayWithClass:[HMHVideoListNewModel class] json:dataDic[@"list"]];
           
            
            if (tempModelArray.count > 0) {
                [self.modelArray addObjectsFromArray:tempModelArray];
            } else {
                self.currentPage--;
            }
            
            if (self.modelArray.count > 0) {
                [self hideNoContentView];
            } else {
                self.noContentImageName = @"SpType_search_noContent";

                [self showNoContentView:YES];
            }
            [self.tableView reloadData];
            
            if (self.modelArray.count <= 5) {
                self.tableView.mj_footer.hidden = YES;
               // self.tableView.mj_footer.automaticallyHidden = YES;;
            } else {
                self.tableView.mj_footer.hidden = NO;
                //self.tableView.mj_footer.automaticallyHidden = NO;;
            }
        }
    } else {
        self.noContentImageName = @"SpType_search_noContent";

        [self showNoContentView:YES];
    }
}


-(BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
