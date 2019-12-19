
//
//  HMHCollectViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHCollectViewController.h"
#import "HMHCollectTableViewCell.h"
#import "HMHShortVideoViewController.h"
#import "HMHVideoPreviewViewController.h"
#import "HMHAliyunTimeShiftLiveViewController.h"
#import "HMHAliYunVodPlayerViewController.h"

@interface HMHCollectViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *HMH_tableView;
@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;

@property (nonatomic, assign) NSInteger HMH_currentPage;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation HMHCollectViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收藏";
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    [self HMH_createTableView];
    [self loadData];
}
- (void)HMH_createTableView{
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - self.HMH_buttomBarHeghit-self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    _HMH_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_HMH_tableView];
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _HMH_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _HMH_tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)refreshData {
    _HMH_currentPage = 1;
    [self loadData];
}

- (void)loadMoreData {
    _HMH_currentPage ++;
    [self loadData];
}
- (void)loadData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    //
   NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/get"];
   if (getUrlStr) {
       getUrlStr = [NSString stringWithFormat:@"%@/%ld?sid=%@",getUrlStr,(long)_HMH_currentPage,sidStr];
   }

    [self requestData:nil withUrl:getUrlStr requestType:@"get"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HMH_dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHCollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.rightButtons = [self createRightButtons:2 shieldTitles:@"取消收藏"];
    cell.rightButtons = [self createRightButtons:1 shieldTitles:@"删除"];
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        [cell refreshCellWithModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (ScreenW - 20) / 5 * 2 * 0.618 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
        if ([model.sceneType isEqualToNumber:@1]) { // 短视频
            HMHShortVideoViewController *shortVC = [[HMHShortVideoViewController alloc] init];
            shortVC.videoNo = model.vno;
            [self.navigationController pushViewController:shortVC         animated:YES];
        } else {  // 普通视频
            // 视频播放状态（1预告、2直播中、3回放、4:已结束）
            if ([model.videoStatus isEqualToNumber:@1]) { // 预告
                HMHVideoPreviewViewController *preview = [[HMHVideoPreviewViewController alloc] init];
                preview.videoNum = model.vno;
                preview.indexSelected = @0;
                [self.navigationController pushViewController:preview animated:YES];
                
            }  else if ([model.videoStatus isEqualToNumber:@2]){ // 直播中
                HMHAliyunTimeShiftLiveViewController *liveVC = [[HMHAliyunTimeShiftLiveViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.navigationController pushViewController:liveVC animated:YES];
            }  else if ([model.videoStatus isEqualToNumber:@3]){ // 回放
                HMHAliYunVodPlayerViewController *liveVC = [[HMHAliYunVodPlayerViewController alloc] init];
                liveVC.indexSelected = @0;
                liveVC.videoNum = model.vno;
                [self.navigationController pushViewController:liveVC animated:YES];
            } else { //  已结束
                _indexPath = indexPath;
                // 弹框
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"视频已下架，是否删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_HMH_dataSourceArr.count > _indexPath.row) {
            HMHVideoListModel *model = _HMH_dataSourceArr[_indexPath.row];
            [self deleteCellRequestWithModel:model indexPath:_indexPath];
        }
    }
}

-(NSArray *)createRightButtons:(int)number shieldTitles:(NSString*)shieldStr{
    NSMutableArray * result = [NSMutableArray array];
    
//    NSArray* titles = @[@"删除",shieldStr];
    NSArray* titles = @[shieldStr];
    NSArray * colors = @[[UIColor redColor], [UIColor lightGrayColor]];
    for (int i = 0; i < number; ++i)
    {
        if (titles.count>i && colors.count>i) {
            MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i]];
            CGRect btnFrame =  button.frame;
            btnFrame.size.width = 63;
            button.frame = btnFrame;
            [result addObject:button];
        }
    }
    return result;
}
#pragma mark - MGSwipeTableCellDelegate
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES":@"NO");
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button
        NSIndexPath * indexPath = [self.HMH_tableView indexPathForCell:cell];
        if (_HMH_dataSourceArr.count > indexPath.row) {
            HMHVideoListModel *model = _HMH_dataSourceArr[indexPath.row];
            
            [self deleteCellRequestWithModel:model indexPath:indexPath];
        }
    }else if (direction == MGSwipeDirectionRightToLeft && index == 1){
        
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
    }
    return YES;
}

- (void)deleteCellRequestWithModel:(HMHVideoListModel *)model indexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-favorite/favorite/delete"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@/%@?sid=%@",getUrlStr,model.vno,sidStr];
    }

    [self requestData:nil withUrl:getUrlStr requestType:@"delete"];
    
    // 删除
    [self.HMH_dataSourceArr removeObjectAtIndex:indexPath.row];
    [self.HMH_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 数据请求
#pragma mark 数据请求 =====get=====
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url requestType:(NSString *)requestType{
       __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        [_HMH_tableView.mj_header endRefreshing];
        [_HMH_tableView.mj_footer endRefreshing];
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([requestType isEqualToString:@"get"]) {
            [weakSelf HMH_getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            
        }else if([requestType isEqualToString:@"delete"]) {
            [weakSelf getDeleteFavoriteData:request.responseObject];
        }else {
            
        }
        
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

- (void)HMH_getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if (_HMH_currentPage == 1) {
            [_HMH_dataSourceArr removeAllObjects];
        }
        NSDictionary *dataDic = resDic[@"data"];
        if ( [dataDic[@"list"] isKindOfClass:[NSArray class]]) {
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
        [_HMH_tableView reloadData];
    }
}

// 删除数据返回
- (void)getDeleteFavoriteData:(id)data{
//    NSDictionary *resDic = data;
//    NSInteger state = [resDic[@"state"] integerValue];
//    if (state != 1) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
}

@end
