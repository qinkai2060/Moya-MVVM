//
//  SpGoodCommentViewController.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpGoodCommentViewController.h"
#import "SpProductCommentListMainView.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
#import "SpGoodCommentDetailViewController.h"

@interface SpGoodCommentViewController ()<SpProductCommentListMainViewDelegate>

@property (nonatomic, strong) SpProductCommentListMainView *mainView;
@property (nonatomic, assign) NSInteger currrentPage;

@property (nonatomic, strong) NSMutableArray *dataSurceArr;

@property (nonatomic, strong) NSMutableArray *selectImageTap;

@end

@implementation SpGoodCommentViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    self.navigationController.navigationBar.hidden=YES;
    self.customNavBar.hidden = NO;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back_light"]];
    self.customNavBar.title = @"所有评价";
    self.customNavBar.titleLabelColor = [UIColor blackColor];
}
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.customNavBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
     self.dataSurceArr = [NSMutableArray arrayWithCapacity:1];
    [self createView];
    [self refreshData];
}

- (void)createView{
    self.mainView = [[SpProductCommentListMainView alloc] initWithFrame:CGRectMake(0, IPHONEX_SAFE_AREA_TOP_HEIGHT_88, ScreenW,ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_88)];
    self.mainView.delegate = self;
    [self.view addSubview:self.mainView];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    self.mainView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    self.mainView.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)refreshData {
    _currrentPage = 1;
    [self getListRequest];
}

- (void)loadMoreData {
    _currrentPage ++;
    [self getListRequest];
}

- (void)getListRequest{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{
                          @"productId":self.productId,
//                        @"productId":@6, // 此处测试
                          @"pageNum":[NSNumber numberWithInteger:_currrentPage],
                          @"pageSize":@20,
                          @"sid":sidStr,
                          @"terminal":@"P_TERMINAL_MOBILE"
                              };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./comment/getCommentList"];
    [self requestDataWithUrl:utrl requestDic:dic];
}

#pragma mainView delegate
//tableview的点击事件
- (void)commentListMainTabelViewDidSelectedWithIndexRow:(NSInteger)indexRow{
    // 判登录
    if (![self isLogin]) {
        return;
    }
    
    if (_dataSurceArr.count > indexRow) {
        GetCommentListModel *model = _dataSurceArr[indexRow];
        SpGoodCommentDetailViewController *detailVC = [[SpGoodCommentDetailViewController alloc] init];
        detailVC.listModel = model;
        
        if (self.myBlock) {
            self.myBlock(detailVC);
        }
    }
}

/**
 点击图片预览
 @param indexRow   cell下标
 @param imageIndex cell中图片下标
 */
-(void)CommentListMainUserTapImageViewWithIndex:(NSInteger)indexRow withCellImageViewsIndex:(NSInteger)imageIndex{
    if (_dataSurceArr.count > indexRow) {
        GetCommentListModel *model = _dataSurceArr[indexRow];
        
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < model.commentPictureList.count; i++) {
            NSDictionary *imageDic = model.commentPictureList[i];
            NSString *imageUrl = [imageDic[@"picPath"] get_sharImage];
            [imgArr addObject:imageUrl];
        }        
        if (imgArr.count > imageIndex) {
            self.selectImageTap = [NSMutableArray arrayWithCapacity:1];
            /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
             如果有 则取出  存到数组中*/
            for (int i = 0; i < imgArr.count; i++) {
                [_selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
            }
            if (_selectImageTap.count > 0) {
                CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
                // 传入图片数组
                pictureVC.picArray = _selectImageTap;
                pictureVC.picUrlArray = imgArr;
                // 标记点击的是哪一张图片
                pictureVC.touchIndex = imageIndex;
                //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
                CLPresent *present = [CLPresent sharedCLPresent];
                pictureVC.modalPresentationStyle = UIModalPresentationCustom;
                pictureVC.transitioningDelegate = present;
                [self presentViewController:pictureVC animated:YES completion:nil];
            }
        }
    }
}



/**
 评论
 @param index 点击行数
 */
- (void)CommentListMainCommentBtnClickWithIndex:(NSInteger)index{
//    NSLog(@"评论按钮的点击事件 %ld",index);
    // 判登录
    if (![self isLogin]) {
        return;
    }

    if (_dataSurceArr.count > index) {
        GetCommentListModel *model = _dataSurceArr[index];
        SpGoodCommentDetailViewController *detailVC = [[SpGoodCommentDetailViewController alloc] init];
        detailVC.listModel = model;
        detailVC.isCommentIn = YES;
        
        if (self.myBlock) {
            self.myBlock(detailVC);
        }
    }
}

/**
 点赞评论
 zanNum 当前点赞的状态
 model  当前评价的model
 */
- (void)commentListZanBtnClickWithIndex:(NSInteger)index zanNum:(NSString *)zanNum model:(GetCommentListModel *)model{
    // 判登录
    if (![self isLogin]) {
        return;
    }

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{
                          @"commentId":[NSString stringWithFormat:@"%@",model.commentId],
                          @"terminal":@"P_TERMINAL_MOBILE",
                          @"count":[NSString stringWithFormat:@"%@",zanNum],
                          @"sid":sidStr,
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/comment/commentLike"];
    [self requestZanDataWithUrl:utrl requestDic:dic];

}

// 数据请求
- (void)requestZanDataWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:nil requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
            [self getZandata:dict];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
// 点赞数据返回
- (void)getZandata:(id)resDic{
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([[resDic valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = resDic[@"data"];
            NSString *zanState = dataDic[@"commentLike"];
        }
    } else if(state == 3){ // 等于3 说明sid过期了 重新登录
        [self gotoLogin];
    }
}




// 数据请求
- (void)requestDataWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    [self.mainView.tableView.mj_header endRefreshing];
    [self.mainView.tableView.mj_footer endRefreshing];
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:nil requstType:YTKRequestMethodGET params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
            [self getSeconddata:dict];
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)getSeconddata:(id)resDic{
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        if ([[resDic valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = resDic[@"data"];
            if (_currrentPage == 1) {
                if (self.dataSurceArr.count > 0) {
                    [self.dataSurceArr removeAllObjects];
                }
            }
            for (NSDictionary *listDic in dataDic[@"commentList"][@"list"]) {
                GetCommentListModel *model = [[GetCommentListModel alloc] init];
                [model setValuesForKeysWithDictionary:listDic];
                model.likesNum = model.commentLikeCount;
                [self.dataSurceArr addObject:model];
            }
            
            if (self.dataSurceArr.count > 0) {
                [self hideNoContentView];
                [self.mainView refreshViewWithData:self.dataSurceArr];
            } else {
                self.noContentImageName = @"SpType_search_noContent";
                self.noContentText = @"抱歉，暂无评价！";
                [self showNoContentView];
                [self.mainView refreshViewWithData:self.dataSurceArr];
            }
        }
    } else {
        if (self.dataSurceArr.count > 0) {
            [self.dataSurceArr removeAllObjects];
        }
        [self.mainView.tableView reloadData];
        
        self.noContentImageName = @"SpType_search_noContent";
        self.noContentText = @"抱歉，暂无评价！";
        [self showNoContentView];
    }
}
@end
