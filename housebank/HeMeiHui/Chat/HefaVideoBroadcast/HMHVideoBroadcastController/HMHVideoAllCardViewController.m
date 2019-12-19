//
//  HMHVideoAllCardViewController.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoAllCardViewController.h"
#import "HMHVideoCardTableViewCell.h"
#import "VideoCommentToolBarView.h"
#import "VideoSendMessageView.h"
#import "HFLoginViewController.h"

@interface HMHVideoAllCardViewController ()<UITableViewDataSource,UITableViewDelegate,CommentToolBarDelegate,VideoCardTableViewCellDelegate,UITextFieldDelegate,VideoCardTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VideoCommentToolBarView *HMH_commentToolBar;

@property (nonatomic, strong) UIView *HMH_blackView;
@property (nonatomic, strong) UIView *HMH_whiteView;

@property (nonatomic, strong) UITextField *HMH_searchTextField;

@property (nonatomic, strong) NSMutableArray *HMH_dataSourceArr;
@property (nonatomic, assign) NSInteger HMH_currrentPage;

@property (nonatomic, assign) NSInteger HMH_dianZanSelectIndex;

@property (nonatomic, assign) NSInteger HMH_judgeIsLogin;

@property (nonatomic, strong) HMHPopAppointViewController *loginViewController;

@end

@implementation HMHVideoAllCardViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
//        _HMH_blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _HMH_blackView.backgroundColor = [UIColor clearColor];
        _HMH_whiteView.frame =CGRectMake(0,self.view.frame.size.width*9/16 + self.HMH_statusHeghit, ScreenW, ScreenH-self.view.frame.size.width*9/16 - self.HMH_statusHeghit);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _HMH_dataSourceArr = [NSMutableArray arrayWithCapacity:1];
    self.HMH_judgeIsLogin = 0;
    [self HMH_createUI];
    [self refreshData];
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
    _HMH_whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW,ScreenH - self.view.frame.size.width*9/16)];
    _HMH_whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_HMH_whiteView];
    
    [self HMH_createTopView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50 + [VideoCommentToolBarView defaultHeight],ScreenW, _HMH_whiteView.frame.size.height - 50 - [VideoCommentToolBarView defaultHeight] - self.HMH_buttomBarHeghit - self.statusChangedWithStatusBarH) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [self createHeaderView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_HMH_whiteView addSubview:_tableView];
    
    __weak typeof(self)weakSelf = self;
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
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


-(void)loadData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    if (self.videoNo.length > 0) {

        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-vno/get"];
        if (getUrlStr) {
            getUrlStr =  [NSString stringWithFormat:@"%@/%@/%@?sid=%@",getUrlStr,self.videoNo,[NSNumber numberWithInteger:_HMH_currrentPage],sidStr];
        }
        [self requestData:nil withUrl:getUrlStr withRequestType:@"get" requestName:@""];
    }
}

- (void)judgeLoginCommentRequestWithText:(NSString *)sendText{
    
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }
    
    [self HMH_sendCommentRequestWithText:sendText];
    
//    if (self.isCardLogin) {
//        [self HMH_sendCommentRequestWithText:sendText];
//        return;
//    }
//    __weak typeof(self)weakSelf = self;
//    self.loginViewController.judgeIsLoginBack = ^(NSString *sidStr) {
//        weakSelf.HMH_judgeIsLogin = 0;
//        [weakSelf HMH_sendCommentRequestWithText:sendText];
//    };
}

// 发送评论数据请求
- (void)HMH_sendCommentRequestWithText:(NSString *)sendText{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    
    NSDictionary *dic = @{@"pid":@0,@"content":sendText,@"vno":self.videoNo};
    
    NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment/add"];
    if (getUrlStr) {
        getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
    }
    
    [self requestData:dic withUrl:getUrlStr withRequestType:@"put" requestName:@"sendComment"];
}

- (void)HMH_createTopView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50 + [VideoCommentToolBarView defaultHeight])];
    bgView.backgroundColor = [UIColor whiteColor];
    [_HMH_whiteView addSubview:bgView];
    
    // cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 30);
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"VS_closeImage@3x.png"] forState:UIControlStateNormal];
    [bgView addSubview:cancelBtn];

    //
    UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    allLab.font = [UIFont systemFontOfSize:15.0];
    allLab.textColor = RGBACOLOR(155, 156, 157, 1);
    allLab.text = @"全部跟帖";
    [bgView addSubview:allLab];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(allLab.frame) + 5, ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(242, 244, 245, 1);
    [bgView addSubview:lineLab];
    
    //
    [bgView addSubview:[self createTextField]];
    
    //_HMH_commentToolBar
//    _HMH_commentToolBar = [[VideoCommentToolBarView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineLab.frame) + 5, ScreenW, [VideoCommentToolBarView defaultHeight])];
//    _HMH_commentToolBar.isFromDetail = YES;
//    _HMH_commentToolBar.isFromGenTie = YES;
//    _HMH_commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
//    _HMH_commentToolBar.delegate = self;
//    [_HMH_commentToolBar.inputTextView setPlaceHolder:@"写跟帖"];
//
//#pragma mark  // 键盘上发送按钮的点击事件
//    [_HMH_commentToolBar setSendBtnClick:^(NSString *sendStr) {
//        //        [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
//        // sendStr 输入的内容
//        if ([sendStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0) {
//            //            [weakSelf showAlertView:@"评论不能为空"];
//            return;
//        }
//    }];
//    [bgView addSubview:_HMH_commentToolBar];
}

- (UIView *)createTextField{
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 36 + 10, ScreenW - 20,40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = RGBACOLOR(242, 242, 242, 1).CGColor;
    
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 8.5, 17, 17)];
    img.image = [UIImage imageNamed:@"VL_commentPen"];
    [bgView addSubview:img];
    
    //
    VideoSendMessageView *sendView = [[VideoSendMessageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 140)];
    sendView.placeHolderStr = @"请回复跟帖......";
    sendView.titleStr = @"回复跟帖";
    
    _HMH_searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height)];
    _HMH_searchTextField.backgroundColor = [UIColor clearColor];
    _HMH_searchTextField.delegate = self;
    _HMH_searchTextField.placeholder = @"写跟帖";
    _HMH_searchTextField.font = [UIFont systemFontOfSize:14.0];
    _HMH_searchTextField.inputAccessoryView = sendView;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(sendView)weakSend = sendView;
    sendView.sendMessageBlock = ^(NSString *messageStr) {
        [weakSend.sendTextView resignFirstResponder];
        [_HMH_searchTextField resignFirstResponder];
        
        [weakSelf judgeLoginCommentRequestWithText:messageStr];
    };
    [bgView addSubview:_HMH_searchTextField];
    
    return bgView;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_HMH_searchTextField resignFirstResponder];
    return NO;
}

- (UIView *)createHeaderView{
    //
    UIView *HMH_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    //
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(-12, 10, 90, 30)];
    hotView.backgroundColor = RGBACOLOR(245, 164, 70, 1);
    hotView.layer.masksToBounds = YES;
    hotView.layer.cornerRadius = hotView.frame.size.height / 2;
    [HMH_bgView addSubview:hotView];
    
    //
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 70, 30)];
    hotLab.textColor = [UIColor whiteColor];
    hotLab.font = [UIFont systemFontOfSize:15.0];
    hotLab.textAlignment = NSTextAlignmentRight;
    hotLab.text = @"热门跟帖";
    [hotView addSubview:hotLab];
    
    return HMH_bgView;
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

// 点赞按钮的点击事件
- (void)videoCardCommentZanBtbClickWithIndex:(NSInteger)index withTableViewCell:(HMHVideoCardTableViewCell *)cell{
    
    //哈哈
    if (!self.isJudgeLogin) {
        [HFLoginViewController showViewController:self];
        return;
    }

    
    //点赞按钮的点击事件
    if (_HMH_dataSourceArr.count > index) {
        _HMH_dianZanSelectIndex = index;
        HMHVideoCommentModel *model = _HMH_dataSourceArr[index];
        [self isJudgeLoginDianZanWithModel:model tableviewCell:cell];
    }
}

//点赞时 判断登录
- (void)isJudgeLoginDianZanWithModel:(HMHVideoCommentModel *)model tableviewCell:(HMHVideoCardTableViewCell *)cell{
    if (self.isCardLogin) {
        [self dianZanRequestDataWithModel:model tableViewCell:cell];
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.loginViewController.judgeIsLoginBack = ^(NSString *sidStr) {
        weakSelf.HMH_judgeIsLogin = 10;
        if (_HMH_currrentPage == 0) {
            [weakSelf refreshData];
        } else {
            [weakSelf loadData];
        }
    };
}
// 点赞数据请求
- (void)dianZanRequestDataWithModel:(HMHVideoCommentModel *)model tableViewCell:(HMHVideoCardTableViewCell *)cell{
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
        
        arr = @[@{@"vcId":model.id,@"vcLike":likeState}];
            
        dic = @{@"data":arr};
        
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"sns.video-comment/comment-like/update"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?sid=%@",getUrlStr,sidStr];
        }
        [self requestData:dic withUrl:getUrlStr withRequestType:@"delete" requestName:@"deleteLike"];

    }
    
    NSString *zanNum ;
    if (!model.myLike) {
        zanNum = @"1";
        cell.zanBtn.selected = YES;
        
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
        model.myLike = YES;
    } else if (model.myLike){
        zanNum = @"0";
        cell.zanBtn.selected = NO;
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
        model.myLike = NO;
    }
}

#pragma mark - HMH_commentToolBar  delegate------------

- (void)inputEndEditing{
    [_HMH_commentToolBar.inputTextView setText:nil];
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
    YTKRequestSerializerType type = YTKRequestSerializerTypeHTTP;
    if ([requestType isEqualToString:@"get"]){
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        requestTypeMethod = YTKRequestMethodGET;
    } else if ([requestType isEqualToString:@"put"]){
        requestTypeMethod = YTKRequestMethodPUT;
         type = YTKRequestSerializerTypeJSON;
    } else {
        requestTypeMethod = YTKRequestMethodPOST;
         type = YTKRequestSerializerTypeJSON;
    }
  
    [HFCarRequest requsetUrl:urlstr1 withRequstType:requestTypeMethod requestSerializerType:type params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        //        [weakSelf getPrcessdata:request.responseObject];
        if ([requestType isEqualToString:@"get"]){
            [weakSelf HMH_getPrcessdata:request.responseObject];
            //            [weakSelf getPrcessdata:request.responseObject];
        } else if ([requestType isEqualToString:@"put"]){
            if ([requestName isEqualToString:@"favorite"]) { // 收藏
            } else if ([requestName isEqualToString:@"history"]){ // 插入观看历史
            } else {
                [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
                [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
                [weakSelf HMH_getSendComentData:request.responseObject];
            }
        } else if ([requestType isEqualToString:@"post"]){
            [self getSendOrCancelLikeData:request.responseObject];
        }
       
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"失败");
    }];
    
//    [HFCarShoppingRequest requestURL:urlstr1 baseHeaderParams:nullDic requstType:requestTypeMethod params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
//        //        [weakSelf getPrcessdata:request.responseObject];
//        if ([requestType isEqualToString:@"get"]){
//            [weakSelf HMH_getPrcessdata:request.responseObject];
//            //            [weakSelf getPrcessdata:request.responseObject];
//        } else if ([requestType isEqualToString:@"put"]){
//            if ([requestName isEqualToString:@"favorite"]) { // 收藏
//            } else if ([requestName isEqualToString:@"history"]){ // 插入观看历史
//            } else {
//                [weakSelf.HMH_commentToolBar.inputTextView resignFirstResponder];
//                [weakSelf.HMH_commentToolBar.inputTextView setText:nil];
//                [weakSelf HMH_getSendComentData:request.responseObject];
//            }
//        } else if ([requestType isEqualToString:@"post"]){
//            [self getSendOrCancelLikeData:request.responseObject];
//        }
//    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"失败");
//        
//    }];
    
}

// 评论列表数据返回
- (void)HMH_getPrcessdata:(id)data{
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
            [self showNoContentViewWithPoint:CGPointMake(_HMH_whiteView.frame.size.width/2.0, self.view.frame.size.width*9/16 + self.HMH_statusHeghit + _HMH_whiteView.frame.size.height/2.0)];
        }
        [_tableView reloadData];
        
        // 用于登录成功之后调的方法
        if (self.HMH_judgeIsLogin == 10) {
            if (_HMH_dataSourceArr.count > _HMH_dianZanSelectIndex) {
                NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:_HMH_dianZanSelectIndex inSection:0];
                
                HMHVideoCardTableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                HMHVideoCommentModel *model = _HMH_dataSourceArr[_HMH_dianZanSelectIndex];
                [self dianZanRequestDataWithModel:model tableViewCell:cell];
                
                self.HMH_judgeIsLogin = 0;
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
        NSComparisonResult comparisonResult = [[VersionTools osVersion] compare:@"8.0"];
        if (comparisonResult == NSOrderedAscending) {//8.0以上的版本
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:resDic[@"msg"]  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 确定按钮的点击事件
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
        }
    }
}

// 点赞数据返回
- (void)getSendOrCancelLikeData:(id)data{
    NSDictionary *resDic = data;
    NSInteger state = [resDic[@"state"] integerValue];
//    if (state != 1) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:resDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
}

// 判登录
- (BOOL)isCardLogin {
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
                _loginViewController = [[HMHPopAppointViewController alloc]init];
                _loginViewController.urlStr = model.url;
                _loginViewController.isNavigationBarshow = NO;
                _loginViewController.isPresentJump = YES;
                [self presentViewController:_loginViewController animated:YES completion:nil];
            }
        }
    }
}



- (void)dismiss{
    self.view.backgroundColor = [UIColor clearColor];
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            _HMH_blackView.backgroundColor = [UIColor clearColor];
            _HMH_whiteView.frame =CGRectMake(0, ScreenH, ScreenW,ScreenH-self.view.frame.size.width*9/16);
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    });
}

@end
