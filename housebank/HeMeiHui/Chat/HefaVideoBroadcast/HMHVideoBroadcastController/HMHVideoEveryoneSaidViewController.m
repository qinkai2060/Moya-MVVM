//
//  HMHVideoDescribeViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoEveryoneSaidViewController.h"
#import "HMHVideoCommentTableViewCell.h"
#import "VideoCommentToolBarView.h"
#import "TZImagePickerController.h"
#import <MJRefresh.h>
#import "HMHVideoCommentModel.h"
#import "HMHPopAppointViewController.h"
#import "LocalLoginViewController.h"
#import "View+MASAdditions.h"
#import "HFLoginViewController.h"

@interface HMHVideoEveryoneSaidViewController () <UITableViewDelegate,UITableViewDataSource,CommentToolBarDelegate,VideoCommentTableViewCellDelegate,HFLoginViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;

@property (nonatomic, strong) VideoCommentToolBarView *HMH_commentToolBar;

@property (nonatomic, strong) UIView *HMH_customToolBarView;
@property (nonatomic, strong) NSMutableArray *HMH_selectImageArrary;
@property (nonatomic, strong) NSMutableArray *HMH_selectedAssets;

//@property (nonatomic, strong) HMHMCSelectImageView *HMH_selectView;

@property (nonatomic, assign) NSInteger HMH_currrentPage;

@property (nonatomic, strong) HMHPopAppointViewController *login;

@property (nonatomic, assign) NSInteger HMH_dianZanSelectIndex;

@property (nonatomic, assign) NSInteger HMH_judgeIsLogin;

@property (nonatomic,assign) BOOL isLike;//是否是点赞

@end

@implementation HMHVideoEveryoneSaidViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEveryWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (!_HMH_selectImageArrary.count) {
        _HMH_selectImageArrary = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (!_HMH_selectedAssets.count) {
        _HMH_selectedAssets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    _HMH_judgeIsLogin = 0;
    [self refreshData];
    
    [self HMH_createTableView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark 进入前台
// 此处是为了解决当导航或者语音 电话时 顶部状态栏显示 导致app被顶下去 的问题
// 其实就是状态栏的变化 当出现上中情况是 状态栏为40   反之为20
- (void)appEveryWillEnterForeground:(NSNotification*)note{
    if (_HMH_commentToolBar) {
        CGRect rect = _HMH_commentToolBar.frame;
        rect.origin.y = self.view.frame.size.height - [VideoCommentToolBarView defaultHeight] - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH;
        _HMH_commentToolBar.frame = rect;
    }
    if (_tableView) {
        CGRect tableRect = _tableView.frame;
        tableRect.size.height = ScreenH - 44 - self.view.frame.size.width*9/16 - [VideoCommentToolBarView defaultHeight] - 30 - self.HMH_statusHeghit - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH;
        _tableView.frame = tableRect;
    }
}

- (void)HMH_createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenW , ScreenH - 44 - self.view.frame.size.width*9/16 - [VideoCommentToolBarView defaultHeight] - 30 - self.HMH_statusHeghit - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH)];
//    _tableView.backgroundColor=[UIColor redColor];
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
    _HMH_commentToolBar = [[VideoCommentToolBarView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [VideoCommentToolBarView defaultHeight] - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH, ScreenW, [VideoCommentToolBarView defaultHeight])];
    _HMH_commentToolBar.maxTextInputViewHeight = 40;
    _HMH_commentToolBar.isFromDetail = YES;
    _HMH_commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _HMH_commentToolBar.delegate = self;
    
    _HMH_commentToolBar.commentBtnClick = ^(NSInteger btnTag,NSString *sendStr) {
        if ([sendStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"评论不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        // 发送评论请求
        [weakSelf isJudgeLoginFavoriteWithState:YES sendText:sendStr withVideoDataSource:nil clickIndex:0 tableViewCell:nil];
    };
    [self.view addSubview:_HMH_commentToolBar];
    _HMH_commentToolBar.backgroundColor=[UIColor redColor];
}


// 点击发送评论 和 评论点赞 判断登录
- (void)isJudgeLoginFavoriteWithState:(BOOL)isSendComment sendText:(NSString *)sendText withVideoDataSource:(NSMutableArray *)arr clickIndex:(NSInteger)index tableViewCell:(HMHVideoCommentTableViewCell *)cell{
    
    if (self.isJudgeLogin) {
        if (isSendComment) { // 发送评论
            self.isLike = NO;
            [self HMH_sendCommentRequestWithCommentText:sendText];
        } else { // 点赞
            self.isLike = YES;
            if (_HMH_dataSourceArr.count > index) {
                HMHVideoCommentModel *model = arr[index];
                [self commentDianZanRequestWithModel:model tabelViewCell:cell];
            }
        }
        return;
    }
    
    //这里需要登录
    [HFLoginViewController showViewController:self];
    
//    if (self.isLogin) {
//        if (isSendComment) { // 发送评论
//            [self HMH_sendCommentRequestWithCommentText:sendText];
//        } else { // 点赞
//            if (_HMH_dataSourceArr.count > index) {
//                HMHVideoCommentModel *model = arr[index];
//                [self commentDianZanRequestWithModel:model tabelViewCell:cell];
//            }
//        }
//        return;
//    }
//    __weak typeof(self)weakSelf = self;
//    self.login.judgeIsLoginBack = ^(NSString *sidStr) {
//        if (isSendComment) { // 发送评论
//            [weakSelf HMH_sendCommentRequestWithCommentText:sendText];
//        } else { // 点赞
//            weakSelf.HMH_dianZanSelectIndex = index;
//
//            weakSelf.HMH_judgeIsLogin = 10;
//            [weakSelf refreshData];
//        }
//    };
}

#pragma mark <HFLoginViewControllerDelegate>

- (void)loginViewController:(HFLoginViewController *)viewcontroller loginFinsh:(NSDictionary *)loginData {
    
//    if (self.isLike) {//点赞
//       // self.HMH_dianZanSelectIndex = index;
//        
//       // weakSelf.HMH_judgeIsLogin = 10;
//        [self refreshData];
//        
//    } else {//评论
//        
//    }
}
// 发送评论数据请求
- (void)HMH_sendCommentRequestWithCommentText:(NSString *)commentText{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    NSDictionary *dic = @{@"pid":@0,@"content":commentText,@"vno":self.videoNum};
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment/add"];
       if (getUrlStr) {
           getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
       }
    [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@"comment"];
}

- (void)commentDianZanRequestWithModel:(HMHVideoCommentModel *)model tabelViewCell:(HMHVideoCommentTableViewCell *)cell{
    
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
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateNormal];

        cell.zanBtn.selected = YES;

        model.myLike = YES;
    } else if (model.myLike){ // 1
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
        [cell.zanBtn setTitle:model.likesNum forState:UIControlStateSelected];
        cell.zanBtn.selected = NO;

        model.myLike = NO;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (model.id) {
        // 评论点赞数据请求
        NSArray *arr;
        NSDictionary *dic;
        arr = @[@{@"vcId":model.id,@"vcLike":zanNum}];
        
        dic = @{@"data":arr};
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-like/update"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }

        [self requestData:dic withUrl:getUrlStr withRequestType:@"like" requestName:@""];
    }
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

- (void)refreshImageUI{
    [_HMH_commentToolBar.inputTextView becomeFirstResponder];
    if (_HMH_selectedAssets.count > 0 && _HMH_selectImageArrary.count > 0) {
//        _HMH_selectView.selectImageArrary = _HMH_selectImageArrary;
        
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.tableView.frame.size.height - 40;
        self.tableView.frame = rect;
        //
        self.HMH_customToolBarView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenW, [VideoCommentToolBarView defaultHeight] + 40);
        //
        CGRect rect1 = self.HMH_commentToolBar.frame;
        rect1.origin.y = 0;
        rect1.size.height = self.HMH_commentToolBar.frame.size.height;
        self.HMH_commentToolBar.frame = rect1;

//        _HMH_selectView.height = 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HMH_dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMHVideoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[HMHVideoCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
        model.cellIndex = indexPath.row;
        [cell refreshTableViewCellWithModel:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_HMH_dataSourceArr.count > indexPath.row) {
        HMHVideoCommentModel *model = _HMH_dataSourceArr[indexPath.row];
        return [HMHVideoCommentTableViewCell cellHeightWithModel:model];
    }
    return 0.0;
}
#pragma mark 显示全部按钮的点击事件
-(void)showAllConentBtnClickWithIndex:(NSInteger)index{
    //    if (_dataSource.count > index) {
    //        CircleCommentListModel *model = _dataSource[index];
//    //        model.isOpenComment =!model.isOpenComment;
//    [UIView performWithoutAnimation:^{ // 解决在出现分页的时候 刷新某一cell时 出现 闪 或 上下移动的问题   消除tableview自带的fade动画
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    }];
    //    }
}



#pragma mark 赞按钮的点击事件
- (void)videoCommentZanBtbClickWithIndex:(NSInteger)index withCommentCell:(HMHVideoCommentTableViewCell *)cell{
    
    [self isJudgeLoginFavoriteWithState:NO sendText:nil withVideoDataSource:_HMH_dataSourceArr clickIndex:(NSInteger)index tableViewCell:cell];
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
// 点击键盘上的完成按钮时 发送评论
- (void)inputEndEditing{
//    [_HMH_commentToolBar.inputTextView setText:nil];
    
//    [self sendCommentRequest];
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


#pragma mark -键盘上发送按钮的点击事件
- (void)didSendText:(NSString *)text{
    
    [_HMH_commentToolBar.inputTextView resignFirstResponder];
}

#pragma mark - GestureRecognizer
// 点击背景隐藏
-(void)keyBoardHidden{
    [self.HMH_commentToolBar endEditing:YES];
}

#pragma mark ---- UIKeyboardNotification ----
- (void)keyboardWillShow:(NSNotification *)notifi{
//    NSDictionary *userInfo = [notifi userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    // 添加移动动画，使视图跟随键盘移动
//    [UIView animateWithDuration:duration.doubleValue animations:^{
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationCurve:[curve intValue]];
//        _HMH_customToolBarView.frame = CGRectMake(0, keyBoardEndY - 20 - _HMH_customToolBarView.bounds.size.height/2.0 , ScreenW, 46 + 40);
//
//        CGRect rect = self.HMH_commentToolBar.frame;
//        rect.origin.y = _HMH_customToolBarView.frame.origin.y;
//        self.HMH_commentToolBar.frame = rect;
//
//        CGRect rect1 = self.HMH_selectView.frame;
//        rect1.origin.y = CGRectGetMaxY(self.HMH_commentToolBar.frame);
//        self.HMH_selectView.frame = rect1;
//    }];

}

- (void)keyboardWillHide:(NSNotification *)notifi{
}

#pragma mark 数据请求 ==========
- (void)requestData:(NSDictionary*)dic withUrl:(NSString *)url withRequestType:(NSString *)requestType requestName:(NSString *)requestName{
    __weak typeof(self)weakSelf = self;
    NSString *urlstr1 = [NSString stringWithFormat:@"%@",url];
    NSDictionary *nullDic=[[NSDictionary alloc]init];
    YTKRequestMethod requestMethod;
    YTKRequestSerializerType type = YTKRequestSerializerTypeHTTP;
    if ([requestType isEqualToString:@"get"]) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        requestMethod = YTKRequestMethodGET;
    }else if ([requestType isEqualToString:@"put"]) {
        requestMethod = YTKRequestMethodPUT;
        type = YTKRequestSerializerTypeJSON;
    }else {
        requestMethod = YTKRequestMethodPOST;
        type = YTKRequestSerializerTypeJSON;
    }
    
    [HFCarRequest requsetUrl:urlstr1 withRequstType:requestMethod requestSerializerType:type params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if(request.requestMethod == YTKRequestMethodGET ) {
            [weakSelf getPrcessdata:request.responseObject];
            
        }else if (request.requestMethod == YTKRequestMethodPUT) {
            [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
            [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
            [weakSelf getSendComentData:request.responseObject];
        }else {
            [weakSelf getLikeOrCancelLikeData:request.responseObject];
        }
       
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
         NSLog(@"失败");
    }];
    
//    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
//        if(request.requestMethod == YTKRequestMethodGET ) {
//            [weakSelf getPrcessdata:request.responseObject];
//            
//        }else if (request.requestMethod == YTKRequestMethodPUT) {
//            [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
//            [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
//            [weakSelf getSendComentData:request.responseObject];
//        }else {
//            [weakSelf getLikeOrCancelLikeData:request.responseObject];
//        }
//        
//    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"失败");
//        
//    }];
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
        
        if (self.HMH_judgeIsLogin == 10) {
            if (_HMH_dataSourceArr.count > _HMH_dianZanSelectIndex) {
                NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:_HMH_dianZanSelectIndex inSection:0];
                
                HMHVideoCommentTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                HMHVideoCommentModel *model = _HMH_dataSourceArr[_HMH_dianZanSelectIndex];
                [self commentDianZanRequestWithModel:model tabelViewCell:cell];
                
                self.HMH_judgeIsLogin = 0;
            }
        }
    }
}

// 发送评论数据返回
- (void)getSendComentData:(id)data{
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
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
    if (state != 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
