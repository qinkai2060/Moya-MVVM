//
//  HMHVideoInteractionViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoInteractionViewController.h"
#import "HMHVideoCardTableViewCell.h"
#import "VideoCommentToolBarView.h"
#import "HFLoginViewController.h"
@interface HMHVideoInteractionViewController ()<UITableViewDataSource,UITableViewDelegate,CommentToolBarDelegate,VideoCardTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VideoCommentToolBarView *HMH_commentToolBar;

@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;
@property (nonatomic, assign) NSInteger HMH_currrentPage;

@property (nonatomic, strong) HMHPopAppointViewController *login;

@property (nonatomic, assign) NSInteger HMH_dianZanSelectIndex;

@property (nonatomic, assign) NSInteger judgeIsLogin;

@end

@implementation HMHVideoInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    _judgeIsLogin = 0;
    [self HMH_createUI];
    [self refreshData];
}

- (void)HMH_createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenW, ScreenH -self.view.frame.size.width*9/16 - [VideoCommentToolBarView defaultHeight] - self.HMH_statusHeghit - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    
    //_HMH_commentToolBar
    _HMH_commentToolBar = [[VideoCommentToolBarView alloc] initWithFrame:CGRectMake(0,ScreenH - [VideoCommentToolBarView defaultHeight] - self.HMH_buttomBarHeghit, ScreenW, [VideoCommentToolBarView defaultHeight])];
    _HMH_commentToolBar.isFromDetail = YES;
    _HMH_commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _HMH_commentToolBar.delegate = self;
    _HMH_commentToolBar.maxTextInputViewHeight = 40.0;
    
    _HMH_commentToolBar.commentBtnClick = ^(NSInteger btnTag,NSString *sendStr) {
        [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
        if ([sendStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"评论不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        // 发送评论请求
        [weakSelf HMH_judgeLoginSendCommentWithText:sendStr];
    };
    [self.view addSubview:_HMH_commentToolBar];
    
}

- (void)refreshData {
    _HMH_currrentPage = 1;
    [self loadData];
}

- (void)loadMoreData {
    _HMH_currrentPage ++;
    [self loadData];
}

-(void)loadData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (self.videoNum.length > 0) {

        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-vno/get"];
        if (getUrlStr) {
            getUrlStr =  [NSString stringWithFormat:@"%@/%@/%@?sid=%@",getUrlStr,self.videoNum,[NSNumber numberWithInteger:_HMH_currrentPage],sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestType:@"get" requestName:@""];
    }
}

-(void)HMH_judgeLoginSendCommentWithText:(NSString *)sendText{
    
    if (!self.isJudgeLogin) {
        
        [HFLoginViewController showViewController:self];
        return;
    }
    [self HMH_sendCommentRequestWithText:sendText];
//    if (self.isLogin) {
//        [self HMH_sendCommentRequestWithText:sendText];
//        return;
//    }
//    __weak typeof (self)weakSelf = self;
//    _login.judgeIsLoginBack = ^(NSString *sidStr) {
//        [weakSelf HMH_sendCommentRequestWithText:sendText];
//    };
}

// 发送评论数据请求
- (void)HMH_sendCommentRequestWithText:(NSString *)sendText{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{@"pid":@0,@"content":sendText,@"vno":self.videoNum};
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment/add"];
       if (getUrlStr) {
           getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
       }
    [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@"sendComment"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HMH_dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHVideoCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHVideoCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
        model.cellIndex = indexPath.row;
        [cell refreshCellWithModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
        return [HMHVideoCardTableViewCell cellHeightWithModel:model];
    }
    return 0.0;
}

#pragma mark 赞按钮的点击事件
- (void)videoCardCommentZanBtbClickWithIndex:(NSInteger)index withTableViewCell:(HMHVideoCardTableViewCell *)cell{
    
    //哈哈
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    if (_HMH_dataSourceArr.count > index) {
        _HMH_dianZanSelectIndex = index;
        HMHVideoCommentModel *model = _HMH_dataSourceArr[index];
            
        [self isJudgeLoginDianZanWithModel:model tableviewCell:cell];
    }
}

//点赞时 判断登录
- (void)isJudgeLoginDianZanWithModel:(HMHVideoCommentModel *)model tableviewCell:(HMHVideoCardTableViewCell *)cell{
    if (self.isLogin) {
        [self HMH_dianZanRequestDataWithModel:model tableViewCell:cell];
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.login.judgeIsLoginBack = ^(NSString *sidStr) {
        weakSelf.judgeIsLogin = 10;
        if (weakSelf.HMH_currrentPage == 0) {
            [weakSelf refreshData];
        } else {
            [weakSelf loadData];
        }
//        [weakSelf HMH_dianZanRequestDataWithModel:model tableViewCell:cell];
    };
}
// 点赞数据请求
- (void)HMH_dianZanRequestDataWithModel:(HMHVideoCommentModel *)model tableViewCell:(HMHVideoCardTableViewCell *)cell{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (model.id) {
        // 评论点赞数据请求
        NSArray *arr;
        NSDictionary *dic;
        NSString *likeState;
        if (model.myLike) { // 点赞状态 则取消
            likeState = @"0";
        } else {
            likeState = @"1";
        }
//        if (model.myLike) { // 点赞状态 则取消
//            NSString *urlStr = [NSString stringWithFormat:@"/user/video/comment/like/%@?sid=%@",model.id,sidStr];
//            [self requestData:nil withUrl:urlStr withRequestType:@"delete" requestName:@"deleteLike"];
//        } else {
//            NSString *urlStr = [NSString stringWithFormat:@"/user/video/comment/like/%@?sid=%@",model.id,sidStr];
//            [self requestData:nil withUrl:urlStr withRequestType:@"put" requestName:@"like"];
//        }
        
        arr = @[@{@"vcId":model.id,@"vcLike":likeState}];
        
        dic = @{@"data":arr};
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-like/update"];
        if(getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        [self requestData:dic withUrl:getUrlStr withRequestType:@"delete" requestName:@""];
    }
    
    NSString *zanNum ;
    if (!model.myLike) {
        zanNum = @"1";
        
        [cell.zanBtn setImage:[UIImage imageNamed:@"Video_zanSelectImage"] forState:UIControlStateSelected];
        long zanCount = [model.likeCount longLongValue];
        
        if (zanCount > 99) {
            model.likesNum = @" 99+";
        } else {
            if (zanCount + 1 > 99) {
                model.likesNum = @" 99+";
            } else {
                model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] + 1];
            }
        }
        
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateSelected];
        cell.zanBtn.selected = YES;

        model.myLike = YES;
    } else if (model.myLike){
        zanNum = @"0";
        [cell.zanBtn setImage:[UIImage imageNamed:@"Video_unZanSelectImage"] forState:UIControlStateNormal];
        long zanCount = [model.likeCount longLongValue];
        if (zanCount > 99) {
            model.likesNum = @" 99+";
        } else {
            if (zanCount - 1 > 99){
                model.likesNum = @" 99+";
            } else {
                model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] - 1];
            }
        }
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateNormal];
        
        cell.zanBtn.selected = NO;
        model.myLike = NO;
    }
}

// 判登录
- (BOOL)isLogin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    if (sidStr.length > 0 && ![sidStr isEqualToString:@"(null)"]) { //已经登录
        return YES;
    }
    [self gotoLogin];
    return NO;
}

- (void)gotoLogin{
    PopAppointViewControllerToos *tools =   [PopAppointViewControllerToos sharePopAppointViewControllerToos];
    if (tools.popWindowUrlsArrary.count) {
        
        for (PageUrlConfigModel *model in tools.pageUrlConfigArrary) {
            
            if([model.pageTag isEqualToString:@"fy_login"]) {
                _login = [[HMHPopAppointViewController alloc]init];
                _login.urlStr = model.url;
                _login.isNavigationBarshow = NO;
                _login.hidesBottomBarWhenPushed = YES;
               
                if (self.myBlock) {
                    self.myBlock(_login);
                }
            }
        }
    }
}

#pragma mark - HMH_commentToolBar  delegate------------

- (void)inputEndEditing{
//    [_HMH_commentToolBar.inputTextView setText:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        //        CGRect rect = self.tableView.frame;
        //        rect.origin.y = 0;
        //        rect.size.height = self.view.frame.size.height - toHeight;
        //        self.tableView.frame = rect;
    }];
    //    [self scrollViewToBottom:NO];
}


#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestType:(NSString *)requestType requestName:(NSString *)requestName{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestTypeMethod;
    if ([requestType isEqualToString:@"get"]){
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
    }
    
    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([requestType isEqualToString:@"get"]) {
            [weakSelf getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            if ([requestName isEqualToString:@"sendComment"]) { // 发送评论
                NSLog(@"发送评论成功");
                [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
                [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
                [weakSelf HMH_getSendComentData:request.responseObject];
            }
        }else {
            [weakSelf getLikeOrCancelLikeData:request.responseObject];
        }
        //        [weakSelf getPrcessdata:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
        
    }];
}

// 评论列表数据返回
- (void)getPrcessdata:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        NSDictionary *dataDic = resDic[@"data"];
        if (_HMH_currrentPage == 1) {
            [_HMH_dataSourceArr removeAllObjects];
        }
        if ([dataDic[@"list"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in dataDic[@"list"]) {
                HMHVideoCommentModel *model = [[HMHVideoCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.likesNum = model.likeCount;
                [_HMH_dataSourceArr addObject:model];
            }
        }
        if (_HMH_dataSourceArr.count > 0) {
            [self hideNoContentView];
        } else {
            [self showNoContentView];
        }
        [_tableView reloadData];
        
        if (self.judgeIsLogin == 10) {
            if (_HMH_dataSourceArr.count > _HMH_dianZanSelectIndex) {
                NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:_HMH_dianZanSelectIndex inSection:0];
                
                HMHVideoCardTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                HMHVideoCommentModel *model = _HMH_dataSourceArr[_HMH_dianZanSelectIndex];
                [self HMH_dianZanRequestDataWithModel:model tableViewCell:cell];
                
                self.judgeIsLogin = 0;
            }
        }
    }
}
// 发送评论数据返回
- (void)HMH_getSendComentData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state == 1) {
        [self refreshData];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

// 点赞数据返回
- (void)getLikeOrCancelLikeData:(id)data{
//    NSDictionary *resDic = data;
//    NSInteger state = [resDic[@"state"] integerValue];
//    if (state != 1) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
}


@end
