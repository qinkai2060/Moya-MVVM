//
//  SpGoodCommentDetailViewController.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpGoodCommentDetailViewController.h"
#import "SpCommentListDetailMainView.h"
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"

@interface SpGoodCommentDetailViewController ()<SpCommentListDetailMainViewDelegate>

@property (nonatomic, strong) SpCommentListDetailMainView *mainView;

@property (nonatomic, strong) NSMutableArray *selectImageTap;

@property (nonatomic, assign) NSInteger currrentPage;

@property (nonatomic, strong) NSMutableArray *commentDataSourceArr;

@end

@implementation SpGoodCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentDataSourceArr = [NSMutableArray arrayWithCapacity:1];

    [self HMH_createNav];
    [self createView];
    
    [self refreshData];
}

- (void)createView{
    self.mainView = [[SpCommentListDetailMainView alloc] initWithFrame:CGRectMake(0, self.statusHeghit + 44, ScreenW, ScreenH - self.statusHeghit - 44) WithModel:self.listModel]; //  - self.buttomBarHeghit
    self.mainView.commentListModel = self.listModel;
    self.mainView.detailModel = self.detailModel;
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

    // 如果是评论按钮进入的  就默认到地下的评论
    if (self.isCommentIn) {
        [self.mainView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
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
                          @"pid":self.listModel.commentId,
                          @"pageNum":[NSNumber numberWithInteger:_currrentPage],
                          @"pageSize":@20,
                          @"sid":sidStr,
                          @"terminal":@"P_TERMINAL_MOBILE"
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./comment/getCommentReplyList"];
    [self requestDataWithUrl:utrl requestDic:dic];
}

/**
 回复评论 发送内容
 */
- (void)sendReplyContentWithText:(NSString *)replyText{
    /**
     if (self.isLogin) {
     if (isSendComment) { // 发送评论
     [self HMH_sendCommentRequestWithCommentText:sendText];
     } else { // 点赞
     if (_HMH_dataSourceArr.count > index) {
     HMHVideoCommentModel *model = arr[index];
     [self commentDianZanRequestWithModel:model tabelViewCell:cell];
     }
     }
     return;
     }
     __weak typeof(self)weakSelf = self;
     self.login.judgeIsLoginBack = ^(NSString *sidStr) {
     if (isSendComment) { // 发送评论
     [weakSelf HMH_sendCommentRequestWithCommentText:sendText];
     } else { // 点赞
     weakSelf.HMH_dianZanSelectIndex = index;
     
     weakSelf.HMH_judgeIsLogin = 10;
     [weakSelf refreshData];
     }
     };
     */
    if (![self isLogin]) {
        [self sendCommentReplyRequestWithText:replyText];
        return;
    }
    
    [self sendCommentReplyRequestWithText:replyText];
}

- (void)sendCommentReplyRequestWithText:(NSString *)replyText{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{
                          @"id":self.listModel.commentId, // 回复评论的id
                          @"commentContent":replyText,
                          @"productId":[NSNumber numberWithInteger:self.detailModel.data.product.productId], // 商品的id
                          @"sid":sidStr,
                          @"terminal":@"P_TERMINAL_MOBILE"
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/comment/saveCommentReply"];
    [self saveCommentReplyRequestWithUrl:utrl requestDic:dic];
}

/**
 点赞按钮的点击事件
 index 点赞当前的cell
 zanNum 判断当前是点赞还是取消点赞
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index zanNum:(NSString *)zanNum model:(nonnull GetCommentListModel *)model{
    if (![self isLogin]) {
        [self zanBtnClickWithCommentId:model.commentId zanNum:zanNum];
        return;
    }
    [self zanBtnClickWithCommentId:model.commentId zanNum:zanNum];
}

- (void)zanBtnClickWithCommentId:(NSString *)CommentId zanNum:(NSString *)zanNum{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{
                          @"commentId":[NSString stringWithFormat:@"%@",CommentId],
                          @"terminal":@"P_TERMINAL_MOBILE",
                          @"count":[NSString stringWithFormat:@"%@",zanNum],
                          @"sid":sidStr,
                          };
    [self requestZanDataWithUrl:@"/user/comment/commentLike" requestDic:dic];
}

/**
 点击图片预览
 @param imageIndex cell中图片下标
 */
-(void)CommentListMainUserTapImageViewWithCellImageViewsIndex:(NSInteger)imageIndex commentListModel:(GetCommentListModel *)listModel{
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < listModel.commentPictureList.count; i++) {
        NSDictionary *imageDic = listModel.commentPictureList[i];
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


- (void)replyConentErrorInfoWithAlert:(UIAlertController *)alertVC{
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)HMH_createNav{
      UIView * _HMH_navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44 + self.statusHeghit)];

    _HMH_navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_navView];
    
    //
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, self.statusHeghit, 60, 44);
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    backImageView.image=[UIImage imageNamed:@"back_light"];
    [backButton addSubview:backImageView];
    [_HMH_navView addSubview:backButton];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, self.statusHeghit, _HMH_navView.frame.size.width - 60, _HMH_navView.frame.size.height - self.statusHeghit)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:17.0];
    lab.text = @"评价详情";
    [_HMH_navView addSubview:lab];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _HMH_navView.frame.size.height - 1, _HMH_navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [_HMH_navView addSubview:bottomLab];
}
// 返回按钮的点击事件
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}


// 评论回复列表数据请求
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
            if (_currrentPage == 1) {
                if (self.commentDataSourceArr.count > 0) {
                    [self.commentDataSourceArr removeAllObjects];
                }
            }
            NSDictionary *dataDic = resDic[@"data"];
            NSDictionary *commentDic = dataDic[@"commentReplyList"];
            NSInteger replyTotalNum = [resDic[@"total"] integerValue];
            
            for (NSDictionary *listDic in dataDic[@"commentReplyList"][@"list"]) {
                GetCommentListModel *model = [[GetCommentListModel alloc] init];
                [model setValuesForKeysWithDictionary:listDic];
                model.likesNum = model.commentLikeCount;
                [self.commentDataSourceArr addObject:model];
            }
            
            [self.mainView refreshViewWithData:self.commentDataSourceArr replyTotalNum:replyTotalNum];
        }
    }
}


// 回复评论数据请求
- (void)saveCommentReplyRequestWithUrl:(NSString *)urlStr requestDic:(NSDictionary *)dic{
    [HFCarShoppingRequest requestURL:urlStr baseHeaderParams:nil requstType:YTKRequestMethodPOST params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self.mainView.commentToolBar.inputTextView resignFirstResponder];
        [self.mainView.commentToolBar.inputTextView setText:nil];
        
        NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
        [self saveReplyData:dict];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
// 回复评论
- (void)saveReplyData:(id)resDic{
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        [self refreshData];
    }else if(state == 3){ // 等于3 说明sid过期了 重新登录
        [self gotoLogin];
    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
    }
}

// 点赞和取消点赞数据请求
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


@end
