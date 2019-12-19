//
//  SpMainMineViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpMainMineViewController.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "SDCycleScrollView.h"
#import "UserInformationView.h"
#import "UserOrderCell.h"
#import "CommonServicesCell.h"
#import "RMBusinessServiceCell.h"
#import "PersonCenterSetingViewController.h"
#import "MyOrderViewController.h"
#import "CustomVerifiedSecPwdView.h"
#import "ResetSecondaryPasswordViewController.h"
#import "CustomPasswordAlter.h"
#import "NSString+NSHash.h"
#import "MyJumpHTML5ViewController.h"
#import "MyQrcodeViewController.h"
#import "HMHContactTabViewController.h"
#import "AchievementViewController.h"
#import "GroupMainViewController.h"
#import "CollectMainController.h"
#import "HFIMMessageController.h"
#import "HFAdreesListViewController.h"
#import "HFAddressListViewModel.h"
#import "CloudManageMainController.h"
#import "YunDianOrderViewController.h"
#import "WelfareViewController.h"
#import "ShopManagementCell.h"
#import "YunDianOrderDetailViewController.h"
#import "YunDianRefundDetailViewController.h"
#import "VipCenterViewController.h"
#import "VipGiftGetViewController.h"
#import "HFDBHandler.h"
#import "VipGiftBagViewController.h"
@interface SpMainMineViewController ()<NTESVerifyCodeManagerDelegate,UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)NTESVerifyCodeManager*manager;
@property (nonatomic, strong) UITableView *HMH_tableView;
@property (nonatomic, assign) NSInteger currrentPage;
@property (nonatomic, strong)SDCycleScrollView*cycleScrollView;
@property (nonatomic, strong) UserInformationView *tableViewHeader;
@property (nonatomic,strong)UIButton *spButton;
@property (nonatomic, strong) UIImageView *imgRMGift;//rm注册领取礼包
@end

@implementation SpMainMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  initShowDate];
    [self HMH_createTableView];
    [self initAddEventBtn];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginoutRefrenshFunc) name:@"loginout_refrensh" object:nil];
    
    
}

-(void)initAddEventBtn{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-71,300,66,66)];
    [btn setImage:[UIImage imageNamed:@"kefu"]  forState:UIControlStateNormal];
    //   btn.backgroundColor = [UIColor redColor];
    btn.tag = 0;
    btn.layer.cornerRadius = 8;
    [self.view addSubview:btn];
    self.spButton = btn;
    [_spButton addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [btn addGestureRecognizer:panRcognize];
    
}
//客服
- (void)addEvent:(UIButton*)btn {
    HFIMMessageController *vc = [[HFIMMessageController alloc] init];
    vc.title = @"在线客服";
    [vc setUrl:[NSString stringWithFormat:@"http://webchat.7moor.com/wapchat.html?accessId=2c5fe110-b494-11e7-8b49-0d6c5756f804&clientId=%@",[HFUserDataTools getUserUidStr]]];
    //        [vc setUrl:@"http://webchat.7moor.com/wapchat.html?accessId=2c5fe110-b494-11e7-8b49-0d6c5756f804&otherParams={%27nickName%27:%27H12962205%27}&clientId=935648"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBar.hidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, SCREEN_HEIGHT / 2.0);
            
            if (recognizer.view.center.x < SCREEN_WIDTH / 2.0) {
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }
                }
            }else{
                if (recognizer.view.center.y <= SCREEN_HEIGHT/2.0) {
                    //右上
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (SCREEN_WIDTH - recognizer.view.center.x  >= SCREEN_HEIGHT - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, SCREEN_HEIGHT - self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (stopPoint.y + self.spButton.width+40>= SCREEN_HEIGHT) {
                stopPoint = CGPointMake(stopPoint.x, SCREEN_HEIGHT - self.spButton.width/2.0-49-40);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + self.spButton.width/2.0 >= SCREEN_WIDTH) {
                stopPoint = CGPointMake(SCREEN_WIDTH - self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, self.spButton.width/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
//退出登录 重新登录刷新数据
- (void)loginoutRefrenshFunc{
    [self getListRequest];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden=YES;
    self.hidesBottomBarWhenPushed = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self getListRequest];
   
    //    /page/controlAppPageShow。开关接口
}

/** VIP个人中心信息*/
- (RACSignal *)requestVipInformation{
    
    RACSubject * subject = [RACSubject subject];
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/vip/member/queryVipQualification"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         if (Is_Kind_Of_NSDictionary_Class(request.responseJSONObject))
         {
             NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
             if ([[dict objectForKey:@"state"] isEqual:@1]) {
                 NSDictionary * dataDic = [dict objectForKey:@"data"];
                 NSNumber * vipRecommendFlag = [dataDic objectForKey:@"vipRecommendFlag"];
                 [subject sendNext:vipRecommendFlag];
                 [subject sendCompleted];
             }else {
                 NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":[dict objectForKey:@"msg"]}];
                 [subject sendError:error];
             }
         }
     }error:^(__kindof YTKBaseRequest * _Nonnull request) {
         [SVProgressHUD dismiss];
         [self showSVProgressHUDErrorWithStatus:@"网络异常请稍后重试！"];
     }];
    return  subject;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count >1) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)HMH_createTableView{
    self.isShow=@"0";
    _HMH_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TabBarHeight) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0,*)) {
        _HMH_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _HMH_tableView.dataSource = self;
    _HMH_tableView.delegate = self;
    _tableViewHeader=[[UserInformationView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 130+StatusBarHeight)];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = _tableViewHeader.bounds;
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 0.75);
    gl.locations = @[@(0.0f), @(1.0f)];
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFFFFF"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#F3F3F3"].CGColor];
    [_HMH_tableView.layer addSublayer:gl];
    _tableViewHeader.backgroundColor=[UIColor colorWithHexString:@"#F3F3F3"];
    _HMH_tableView.tableHeaderView=_tableViewHeader;
    _HMH_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_HMH_tableView];
    
    WEAKSELF;
    _tableViewHeader.clickBlock = ^(UserInformationViewlClickType flag) {
        [weakSelf headerViewClickType:flag];
    };
    //    [self getListRequest];
    // 下拉刷新
    _HMH_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getListRequest];
    }];
    
}

- (UIImageView *)imgRMGift{
    if (!_imgRMGift) {
        _imgRMGift = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icom_rm_git"]];
        _imgRMGift.userInteractionEnabled = YES;
        [self.view addSubview:_imgRMGift];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rmGetGiftAction)];
        [_imgRMGift addGestureRecognizer:tap];
        [_imgRMGift mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 90));
        }];
    }
    return _imgRMGift;
}
- (void)rmGetGiftAction{
    [self pushMyOrderHtml:[NSString stringWithFormat:@"/html/home/#/user/rmGiftList?sid=%@", [HFCarShoppingRequest sid]]];
}
#pragma requestData

- (void)headerViewClickType:(UserInformationViewlClickType)type{
    self.ismyAssets=NO;
    switch (type) {
        case UserInformationViewlClickTypeHeader://头像
        {
            [self requestCheckHadSecPwd];
        }
            break;
        case UserInformationViewlClickTypeUserName://用户名
        {
            [self requestCheckHadSecPwd];
            //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
            //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/personalinformation/essentialinformation.html?parent=1"];
            //                HtmlVC.hidesBottomBarWhenPushed=YES;
            //                [self.navigationController pushViewController:HtmlVC animated:YES];
            
            
        }
            break;
        case UserInformationViewlClickTypeStoreVip://门店会员
        {
            [self requestCheckHadSecPwd];
            //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
            //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/personalinformation/essentialinformation.html?parent=1"];
            //                HtmlVC.hidesBottomBarWhenPushed=YES;
            //                [self.navigationController pushViewController:HtmlVC animated:YES];
            
        }
            break;
        case UserInformationViewlClickTypeCompanyVip://企业会员
        {
            [self requestCheckHadSecPwd];
            //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
            //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/personalinformation/essentialinformation.html?parent=1"];
            //                HtmlVC.hidesBottomBarWhenPushed=YES;
            //                [self.navigationController pushViewController:HtmlVC animated:YES];
            
        }
            break;
        case UserInformationViewlClickTypeMessage://消息按钮
        {
            // HFShouYinViewController *newsView=[[HFShouYinViewController alloc]init];
            // newsView.isMore=YES;
            // [newsView setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/html/shopping/news/news.html"]];
            // newsView.fromeSource=@"globleNewsVC";
            // newsView.hidesBottomBarWhenPushed=YES;
            //[self.navigationController pushViewController:newsView animated:YES];
            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/shopping/news/news.html"];
            HtmlVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:HtmlVC animated:YES];
        }
            break;
        case UserInformationViewlClickTypeSetting://设置按钮
        {
            PersonCenterSetingViewController *vc = [[PersonCenterSetingViewController alloc] init];
            vc.hidesBottomBarWhenPushed=YES;
            vc.RMGrade = self.checkShopsModel.data.RMGrade;
            vc.imagePath = self.userInfoModel.data.userCenterInfo.imagePath;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case UserInformationViewlClickTypeMoney://我的资产按钮
        {
            self.ismyAssets=YES;
            [self requestCheckHadSecPwd];
        }
            break;
        case UserInformationViewlClickTypePerformance://我的业绩
        {
            [self checkMyPerformance];
        }
            break;
        case UserInformationViewlClickTypeVip://vip
        {
            
          [[self requestVipInformation] subscribeNext:^(NSNumber * x) {
                if (x) {
                    if ([x isEqualToNumber:@1]) {
                        VipGiftBagViewController *vip = [[VipGiftBagViewController alloc] init];
                        [self.navigationController pushViewController:vip animated:YES];
                    } else {
                        VipGiftGetViewController *vip = [[VipGiftGetViewController alloc] init];
                        [self.navigationController pushViewController:vip animated:YES];
                    }
                }
            }];
        }
            break;
        case UserInformationViewlClickTypeVipTag://vip标签
        {
            [self requestCheckHadSecPwd];
//            NSLog(@"vip标签");
//            VipCenterViewController *vip = [[VipCenterViewController alloc] init];
//            vip.imagePath = self.userInfoModel.data.userCenterInfo.imagePath;
//            vip.vipLevel = [NSNumber numberWithString:self.userInfoModel.data.userCenterInfo.vipLevel];
//            vip.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:vip animated:YES];
        }
            break;
        default:
            break;
    }
}
/**
 是否设置二级密码
 */
- (void)requestCheckHadSecPwd{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";;
    NSDictionary *dic = @{
                          @"sid":sid
                          };
     NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/checkHadSecPwd"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        [SVProgressHUD dismiss];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseString);
        if (CHECK_STRING_ISNULL(request.responseString) || !request.responseString.length) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        NSInteger response = [request.responseString integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:response] forKey:@"secPwd"];
        switch (response) {
            case 1:
            {
                //已设置
                [self setUpSecPwd];
            }
                break;
            case 2:
            {
                //未设置
                [self notSetUpSecPwd];
            }
                break;
            case 3:
            {
                //已验证
                [self verifiedSecPwd];
            }
                break;
                
                
            default:
                break;
        }
    }];
}
- (void)showSVProgressHUDErrorWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}
-(void)showSVProgressHUDSuccessWithStatus:(NSString *)str{
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
/**
 未设置二级密码
 */
- (void)notSetUpSecPwd{
    [CustomPasswordAlter showCustomPasswordAlterViewViewIn:self.view title:@"您还没有设置二级密码" suret:@"确认" closet:@"取消" sureblock:^{
        ResetSecondaryPasswordViewController *vc = [[ResetSecondaryPasswordViewController alloc] init];
        vc.isNavigation = YES;
        vc.ntitle = @"二级密码设置";
        [self.navigationController pushViewController:vc animated:YES];
        
    } closeblock:^{
        
    }];
}

/**
 已设置二级密码
 */
- (void)setUpSecPwd{
    [CustomVerifiedSecPwdView showCustomVerifiedSecPwdViewIn:self.tabBarController.view forgetblock:^{
        ResetSecondaryPasswordViewController *vc = [[ResetSecondaryPasswordViewController alloc] init];
        vc.isNavigation = YES;
        vc.ntitle = @"二级密码重置";
        [self.navigationController pushViewController:vc animated:YES];
    } sureblock:^(NSString * _Nonnull password) {
        [self requestCheckSecPwd:password];
    } closeblock:^{
        
    }];
}

/**
 已验证二级密码
 */
- (void)verifiedSecPwd{
    if (self.ismyAssets) {
        MyJumpHTML5ViewController *vc = [[MyJumpHTML5ViewController alloc] init];
        vc.webUrl = @"/html/home/#/user/property";
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/personalinformation/essentialinformation.html?parent=1"];
        HtmlVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:HtmlVC animated:YES];
        
    }
    
}
/**
 验证二级密码
 */
- (void)requestCheckSecPwd:(NSString *)password{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"secPwd":[[password MD5] MD5]
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/checkSecPwd"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        [SVProgressHUD dismiss];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseString);
        if (CHECK_STRING_ISNULL(request.responseString)) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        NSInteger response = [request.responseString integerValue];
        switch (response) {
            case 1:
            {
                //验证成功
                [self verifiedSecPwd];
                
            }
                break;
            case 2:
            {
                //验证失败
                [self showSVProgressHUDErrorWithStatus:@"二级密码错误!"];
            }
                break;
                
            default:
                break;
        }
    }];
}
//页面数据接口
-(void)getListRequest
{
    WEAKSELF
    [self.HMH_tableView.mj_header endRefreshing];
    [self.HMH_tableView.mj_footer endRefreshing];
    [SVProgressHUD show];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t searialQueue = dispatch_queue_create("com.hmc.www", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_enter(group);     dispatch_group_async(group, searialQueue, ^{
        // 网络请求一
        //1、  开关接口
        NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./page/controlAppPageShow"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeJSON params:nil success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             dispatch_group_leave(group);
             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                 //                 是否展示开关  0不展示 1展示
                 if ([dict objectForKey:@"data"]!=nil&&![[dict objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                     self.isShow=[[dict objectForKey:@"data"]  objectForKey:@"result"];
                 }else
                 {
                     self.isShow=@"0";
                 }
                 
                 if ([dict[@"state"] intValue] !=1) {
                     self.isShow=@"1";
                     return ;
                 }
                 
             }
             
         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
             dispatch_group_leave(group);
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
             NSLog(@"❤️1️⃣");
         }];
        
    });
    
//    dispatch_group_enter(group);
//    dispatch_group_async(group, searialQueue, ^{
//        //2   校验街镇代地址信息       待处理
//        [HFCarRequest requsetUrl:@"/user/checkAllAddress" withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid]} success:^(__kindof YTKBaseRequest * _Nonnull request)
//         {
//             dispatch_group_leave(group);
//             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
//             {
//                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
//                 if ([dict[@"state"] intValue] !=1) {
//                     if ([dict[@"state"] intValue] ==3) {//sid超时需登录
//                         [self gotoLogin];
//                     }else
//                     {
//                         [SVProgressHUD dismiss];
//                         [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
//                         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                         [SVProgressHUD dismissWithDelay:1.0];
//                     }
//                     return ;
//                 }
//
//             }
//
//         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
//             dispatch_group_leave(group);
//             [SVProgressHUD dismiss];
//             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
//             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//             [SVProgressHUD dismissWithDelay:1.0];
//         }];
//    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, searialQueue, ^{
        // 3    APP-MLS业绩显示。 待处理
       NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/getAchievementShow"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             dispatch_group_leave(group);
             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
             {
                 //                     code = 0;
                 //                     data =     {
                 //                         mlsShowFlag = 0;
                 //                     };
                 //                     msg = "";
                 //                     state = 1;
                 //                     total = "<null>";
                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                 if ([dict[@"state"] intValue] !=1) {
                     if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                         [self gotoLogin];
                     }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                         [SVProgressHUD dismissWithDelay:1.0];
                     }
                     
                     return ;
                 }
                 
//                 self.achievementModel=[[AchievementModel alloc]initWithDictionary:dict error:nil];
                 self.achievementModel = [AchievementModel modelWithJSON:dict];
                 if (self.achievementModel.data.mlsShowFlag) {
//                     关闭我的业绩入口
//                     _tableViewHeader.myPerformance.hidden=NO;
                 }
             }
             
         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
             dispatch_group_leave(group);
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
         }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, searialQueue, ^{
        // 4   APP-校验店铺信息
       NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/checkShops"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             dispatch_group_leave(group);
             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                 
                 if ([dict[@"state"] intValue] !=1) {
                     if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                         [self gotoLogin];
                     }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                         [SVProgressHUD dismissWithDelay:1.0];
                     }
                     return ;
                 }
//                 self.checkShopsModel=[[CheckShopsModel alloc]initWithDictionary:dict error:nil];
                 self.checkShopsModel = [CheckShopsModel modelWithJSON:dict];
             }
             
         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
             dispatch_group_leave(group);
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
         }];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, searialQueue, ^{
        //    5。 APP-刷新用户信息。 表单传参数
       NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/refreshUser"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             dispatch_group_leave(group);
             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                 if ([dict[@"state"] intValue] !=1) {
                     if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                         [self gotoLogin];
                     }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD showErrorWithStatus:dict[@"msg"]];
                         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                         [SVProgressHUD dismissWithDelay:1.0];
                     }
                     return ;
                 }
//                 self.userInfoModel=[[UserInfoModel alloc]initWithDictionary:dict error:nil];
                 self.userInfoModel = [UserInfoModel modelWithJSON:dict];
                 self.imgRMGift.hidden = [self.userInfoModel.data.userCenterInfo.hasRmGiftPack isEqualToString:@"1"]  ? NO : YES;
                 if (Is_Kind_Of_NSDictionary_Class(dict[@"data"]) && Is_Kind_Of_NSDictionary_Class(dict[@"data"][@"userCenterInfo"])) {
                     [HFDBHandler cacheLoginData:dict[@"data"][@"userCenterInfo"]];
                 }
             }
             
         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
             dispatch_group_leave(group);
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
         }];
        
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, searialQueue, ^{
        //6 APP-查询rm注册，代注册，升级未支付订单   待处理
          NSString * utrl = [[NetWorkManager shareManager] getForKey:@"order./user/findBuyerRegOrderStatus"];
        [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:[HFCarRequest sid] success:^(__kindof YTKBaseRequest * _Nonnull request)
         {
             dispatch_group_leave(group);
             if ( [request.responseJSONObject isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = (NSDictionary*)request.responseJSONObject;
                 if ([dict[@"state"] intValue] !=1) {
                     if ([dict[@"state"] intValue] ==3) {//sid超时需登录
                         [self gotoLogin];
                     }else
                     {
                         [SVProgressHUD dismiss];
                         [SVProgressHUD  showErrorWithStatus:dict[@"msg"]];
                         [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                         [SVProgressHUD dismissWithDelay:1.0];
                     }
                     return ;
                 }
//                 self.orderStatusModel=[[OrderStatusModel alloc]initWithDictionary:dict error:nil];
//                 self.orderStatusModel = [OrderStatusModel modelWithJSON:[dict objectForKey:@"data"]];
                    self.orderStatusModel = [OrderStatusModel modelWithJSON:dict];
                 NSData * data  = [NSKeyedArchiver archivedDataWithRootObject:self.orderStatusModel];
                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"orderStatus"];
                 //
                 ////                 [defaults synchronize];
                 //                 [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"orderStatus"];
             }
              
         }error:^(__kindof YTKBaseRequest * _Nonnull request) {
             dispatch_group_leave(group);
             [SVProgressHUD dismiss];
             [SVProgressHUD  showErrorWithStatus:@"网络异常请稍后重试！"];
             [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
             [SVProgressHUD dismissWithDelay:1.0];
         }];
    });
    
    //三个网络请求结束后，会进入这个方法，在这个方法中进行洁面的刷行
    dispatch_group_notify(group, searialQueue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self initShowDate];
                [_HMH_tableView reloadData];
                [_tableViewHeader refreshHeaderWithModel:self.userInfoModel];
            });
        });
    });
    
}
//初始化展示数据
-(void)initShowDate
{
    //        商铺管理数据源
    _nameArray1=[[NSMutableArray alloc]init];
    _imageArray1=[[NSMutableArray alloc]init];
    if (self.checkShopsModel.data.isSalesOrder) {
        //        销售订单管理
        [_nameArray1 addObject:@"销售订单管理"];
        [ _imageArray1 addObject:@"销售订单管理"];
    }
    if ([self.checkShopsModel.data.hasCloudShops integerValue]>0 ||self.checkShopsModel.data.RMGrade>1) {
        //        云店管理
        [_nameArray1 addObject:@"云店管理"];
        [ _imageArray1 addObject:@"云店管理"];
    }
    if (self.checkShopsModel.data.isHfShops) {
        //        有合发购物店铺
        if (self.checkShopsModel.data.hfShopsState==0||self.checkShopsModel.data.hfShopsState==4) {
            
            [_nameArray1 addObject:@"商城店铺入驻"];
            [ _imageArray1 addObject:@"商城店铺"];
            
        }else
        {
//            注释掉商城店铺管理。入口变为销售订单管理
//            [_nameArray1 addObject:@"商城店铺管理"];
//            [ _imageArray1 addObject:@"商城店铺"];
        }
        
    }else
    {
        [_nameArray1 addObject:@"商城店铺入驻"];
        [ _imageArray1 addObject:@"商城店铺"];
    }
    if (self.checkShopsModel.data.RMGrade<=1) {
        [_nameArray1 addObject:@"注册RM门店"];
        [_imageArray1 addObject:@"注册RM门店"];
        
    }
    //    RM门店管理数据源
    _nameArray2=[[NSMutableArray alloc]init];
    _imageArray2=[[NSMutableArray alloc]init];
    
    if (self.checkShopsModel.data.RMGrade==1) {//免费会员
        [_nameArray2 removeAllObjects];
        
    }else if (self.checkShopsModel.data.RMGrade==4)//高级
    {
//        [_nameArray2 addObject:@"邀请RM"];
        [_nameArray2 addObject:@"福利商品/福利订单"];
        
//        [_imageArray2 addObject:@"邀请RM"];
        [_imageArray2 addObject:@"福利商品"];
        if (self.checkShopsModel.data.townAgent||self.checkShopsModel.data.cityAgent||self.checkShopsModel.data.regionAgent||self.checkShopsModel.data.RMAgent== 0 || self.checkShopsModel.data.RMAgent== 1 || self.checkShopsModel.data.RMAgent== 3 || self.checkShopsModel.data.RMAgent== 6) {
            [_nameArray2 addObject:@"代理管理"];
            [_imageArray2 addObject:@"代理管理"];
        }
        [_nameArray2 addObject:@"代理商品"];
        [_imageArray2 addObject:@"代理商品"];
        
    }else if (self.checkShopsModel.data.RMGrade==2||self.checkShopsModel.data.RMGrade==3)
    {//初级。中级
//        [_nameArray2 addObject:@"邀请RM"];
        [_nameArray2 addObject:@"升级RM"];
        [_nameArray2 addObject:@"福利商品/福利订单"];
        
        
//        [_imageArray2 addObject:@"邀请RM"];
        [_imageArray2 addObject:@"升级RM"];
        [_imageArray2 addObject:@"福利商品"];
        
        if (self.checkShopsModel.data.townAgent||self.checkShopsModel.data.cityAgent||self.checkShopsModel.data.regionAgent||self.checkShopsModel.data.RMAgent== 0 || self.checkShopsModel.data.RMAgent== 1 || self.checkShopsModel.data.RMAgent== 3 ||  self.checkShopsModel.data.RMAgent== 6) {
            [_nameArray2 addObject:@"代理管理"];
            [_imageArray2 addObject:@"代理管理"];
        }
        [_nameArray2 addObject:@"代理商品"];
        [_imageArray2 addObject:@"代理商品"];
    }else
    {
        [_nameArray2 removeAllObjects];
        
    }
    if (self.checkShopsModel.data.RMGrade==4||self.checkShopsModel.data.agentWhite==1){
        if (self.checkShopsModel.data.RMAgent== 2 || self.checkShopsModel.data.RMAgent== 4  || self.checkShopsModel.data.RMAgent== 7 || self.checkShopsModel.data.RMAgent==8||self.checkShopsModel.data.RMAgent== 5)
        {//注册街镇代
            [_nameArray2 addObject:@"申请街镇代"];
            [_imageArray2 addObject:@"代理管理"];
        }
        
    }
////    代理商品
//    if (self.checkShopsModel.data.cityAgent||self.checkShopsModel.data.canBuyAgtProduct) {
//        [_nameArray2 addObject:@"代理商品"];
//        [_imageArray2 addObject:@"代理商品"];
//    }
   
    _nameArray3=[[NSMutableArray alloc]init];
    _imageArray3=[[NSMutableArray alloc]init];
    if (self.checkShopsModel.data.RMGrade==1) {//免费会员
        [_nameArray3 addObject:@"我的收藏"];
        [_nameArray3 addObject:@"我的团购"];
        [_nameArray3 addObject:@"购买门票"];
        [_nameArray3 addObject:@"邀请好友"];
//        [_nameArray3 addObject:@"通讯录邀约"];
        
        
        [_imageArray3 addObject:@"我的收藏"];
        [_imageArray3 addObject:@"我的团购"];
        [_imageArray3 addObject:@"menpiao"];
        [_imageArray3 addObject:@"邀请好友"];
//        [_imageArray3 addObject:@"通讯录邀约"];
        
        
    }else
    {
        [_nameArray3 addObject:@"销售线索"];
        [_nameArray3 addObject:@"我的收藏"];
        [_nameArray3 addObject:@"我的团购"];
        [_nameArray3 addObject:@"购买门票"];
        [_nameArray3 addObject:@"邀请好友"];
//        [_nameArray3 addObject:@"通讯录邀约"];
        
        
        [_imageArray3 addObject:@"销售线索"];
        [_imageArray3 addObject:@"我的收藏"];
        [_imageArray3 addObject:@"我的团购"];
        [_imageArray3 addObject:@"menpiao"];
        [_imageArray3 addObject:@"邀请好友"];
//        [_imageArray3 addObject:@"通讯录邀约"];
        
        
    }
}
#pragma mark tabelview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //   if (self.checkShopsModel.data.RMGrade>1) {
    
    return 4;
    //   }else
    //   {//免费会员
    //      return 3;
    //   }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {// 订单
            return 1;
        }
            
            break;
        case 1:
        {
            return _nameArray1.count;
        }
            
            break;
        case 2:
        {
            //RM门店管理
            return _nameArray2.count;
        }
            
            break;
        case 3:
        {
            //常用服务
            return _nameArray3.count;
        }
            
            break;
            
        default:
            return 1;
            break;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    switch (indexPath.section) {
        case 0:
        {
            //订单cell
            UserOrderCell *orderCell=[tableView dequeueReusableCellWithIdentifier:@"UserOrderCell"];
            if (orderCell == nil) {
                orderCell = [[UserOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserOrderCell"];
            }
            
            orderCell.clikBlock = ^(UserOrderCellClickType type) {
                [weakSelf UserOrderCellClickAction:type];
            };
            orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //  [orderCell refreshCellWithModel:[self.spikeDataList.data.spikes.list objectAtIndex:indexPath.row]];
            return orderCell;
            
        }
            break;
        case 1:
        {
            //            商铺管理
            ShopManagementCell *SMCell=[tableView dequeueReusableCellWithIdentifier:@"ShopManagementCell"];
            if (SMCell == nil) {
                SMCell = [[ShopManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopManagementCell"];
            }
            SMCell.selectionStyle = UITableViewCellSelectionStyleNone;
            SMCell.nameLable.text=[_nameArray1 objectAtIndex:indexPath.row];
            SMCell.iconImage.image=[UIImage imageNamed:[_imageArray1 objectAtIndex:indexPath.row]];
            //            待处理
            return SMCell;
        }
            break;
        case 2:
        {
            //            RM门店管理
            ShopManagementCell *SMCell=[tableView dequeueReusableCellWithIdentifier:@"ShopManagementCell"];
            if (SMCell == nil) {
                SMCell = [[ShopManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopManagementCell"];
            }
            SMCell.selectionStyle = UITableViewCellSelectionStyleNone;
            SMCell.nameLable.text=[_nameArray2 objectAtIndex:indexPath.row];
            SMCell.iconImage.image=[UIImage imageNamed:[_imageArray2 objectAtIndex:indexPath.row]];
            return SMCell;
            
        }
            break;
        case 3:
        {
            //            常用服务
            ShopManagementCell *SMCell=[tableView dequeueReusableCellWithIdentifier:@"ShopManagementCell"];
            if (SMCell == nil) {
                SMCell = [[ShopManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopManagementCell"];
            }
            SMCell.selectionStyle = UITableViewCellSelectionStyleNone;
            SMCell.nameLable.text=[_nameArray3 objectAtIndex:indexPath.row];
            SMCell.iconImage.image=[UIImage imageNamed:[_imageArray3 objectAtIndex:indexPath.row]];
            return SMCell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}
////常用服务
//- (void)commonServicesClickType:(CommonServicesViewClickType)type
//{
//    //    @"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"销售线索",@"邀请RM",@"代理商品",@"福利商品",@"升级RM"
//    switch (type) {
//        case CommonServicesViewTypeMyCollection://我的收藏
//        {
////            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
////            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/mall/myFollow.html"];
////            HtmlVC.hidesBottomBarWhenPushed=YES;
////            HtmlVC.navigationController.navigationBar.hidden=YES;
////            [self.navigationController pushViewController:HtmlVC animated:YES];
//            CollectMainController * collectVC = [[CollectMainController alloc]init];
//            collectVC.hidesBottomBarWhenPushed = YES;
//            collectVC.navigationController.navigationBar.hidden = NO;
//            [self.navigationController pushViewController:collectVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeInviteFriends://邀请好友
//        {
//            MyQrcodeViewController *VC = [[MyQrcodeViewController alloc]init];
//            VC.ntitle = @"邀请好友";
//            VC.imagePath = self.userInfoModel.data.userCenterInfo.imagePath ?: @"";
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeMailList://通讯录邀约
//        {
//            HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
//            HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
//            phoneVC.InviteClick = ^(NSString*PhoneNum){
//
//
//            };
//            NSString *sid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
//            NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
//            NSString *mobilephone =  [[NSUserDefaults standardUserDefaults]objectForKey:@"mobilephone"];
//            if (sid <= 0) { // 未登录状态
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前用户未登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
//
//            }else if (uid.length > 0 &&mobilephone.length > 0) {
//                NSDictionary *dic =@{
//                                     @"uid" : uid,
//                                     @"mobilephone" :mobilephone
//                                     };
//                conVC.phoneVC = phoneVC;
//                conVC.automaticallyAdjustsScrollViewInsets = NO;
//                conVC.infoDic = dic;
//                [self.navigationController pushViewController:conVC animated:YES];
//            }
//        }
//            break;
//        case CommonServicesViewTypeBankCard://银行卡管理
//        {
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/bankcard.html?parent=1"];
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeAddressManagement://地址管理
//        {
//
//            HFAdreesListViewController *HtmlVC=[[HFAdreesListViewController alloc]init];
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            HtmlVC.viewModel.fromeSource = HFAddressListViewModelSourceMine;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeGroupBuy://我的团购
//        {
////            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
////            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/airClass/MyCollage.html"];
////            HtmlVC.hidesBottomBarWhenPushed=YES;
////            HtmlVC.navigationController.navigationBar.hidden=YES;
////            [self.navigationController pushViewController:HtmlVC animated:YES];
//            GroupMainViewController *groupVC = [[GroupMainViewController alloc]init];
//            groupVC.hidesBottomBarWhenPushed = YES;
//            groupVC.navigationController.navigationBar.hidden = NO;
//            [self.navigationController pushViewController:groupVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeBuyTickets://购买门票
//        {
//            HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
//            pvc.urlStr =[NSString stringWithFormat:@"%@/html/house/other/PC_tickets.html",fyMainHomeUrl];
//            pvc.hidesBottomBarWhenPushed=YES;
//            pvc.navigationController.navigationBar.hidden=YES;
//            pvc.edgesForExtendedLayout=UIRectEdgeNone;
//            [self.navigationController pushViewController:pvc animated:YES];
//        }
//            break;
//
//        case CommonServicesViewTypeSalesLeads://销售线索
//        {
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/mls/track_r.html"];
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeInviteRM://邀请RM
//        {
//            //                    name2=@"注册RM门店";
//            //                    查询订单状态代支付跳转
//            //                    判断是否存在待支付订单，决定注册，代注册，升级跳转的页面
//            //                    data={
//            //                    P_BIZ_PROXY_REG_ORDER:11111; //代注册(邀请)
//            //                    P_BIZ_REGISTRATION_ORDER:2222;//自己注册
//            //                    P_BIZ_UPREGISTRATION_ORDER:33333;//升级
//            //                    }
//
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            if (self.orderStatusModel.data.P_BIZ_PROXY_REG_ORDER) {
//                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/failregister?orderNo=%@",self.orderStatusModel.data.P_BIZ_PROXY_REG_ORDER];
//            }else
//            {
//                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/rep/registerrm"];
//            }
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//
//        }
//            break;
//        case CommonServicesViewTypeAgencyGoods://代理商品
//        {
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/goods/cart/agency"];
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeWelfareGoods://福利商品
//        {
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/globalhome/agency-mall/welfare.html"];
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//        case CommonServicesViewTypeUpgradeRM://升级RM
//        {
//            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
//            if (self.orderStatusModel.data.P_BIZ_UPREGISTRATION_ORDER) {
//                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/failregister?orderNo=%@",self.orderStatusModel.data.P_BIZ_UPREGISTRATION_ORDER];
//            }else
//            {
//                if (self.checkShopsModel.data.RMGrade==2) {//初级
//                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/registerrm/jumreg/member"];
//                }
//                if (self.checkShopsModel.data.RMGrade==3) {//中级
//                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/registerrm/stereg/member"];
//                }
//
//            }
//            HtmlVC.navigationController.navigationBar.hidden=YES;
//            HtmlVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:HtmlVC animated:YES];
//        }
//            break;
//
//
//        default:
//            break;
//    }
//}
/**
 订单点击
 @param type 订单类型
 */
- (void)UserOrderCellClickAction:(UserOrderCellClickType)type{
    switch (type) {
        case UserOrderCellClickTypeRefund:
        {
            MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
            HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/order/all/refundList"];
            HtmlVC.hidesBottomBarWhenPushed=YES;
            HtmlVC.navigationController.navigationBar.hidden=YES;
            [self.navigationController pushViewController:HtmlVC animated:YES];
        }
            break;
            
        case UserOrderCellClickTypeAll://全部
        {
            [self pushMyOrderHtml:@"/html/home/#/my/orderList"];
        }
            break;
            
        case UserOrderCellClickTypePendingPayment://代付款
        {
            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=1"];
            
        }
            break;
        case UserOrderCellClickTypeToBeShipped: //待发货
        {
            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=2"];
            
        }
            break;
        case UserOrderCellClickTypeGoodsReceived://待h收货
        {
            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=3"];
            
        }
            break;
        case UserOrderCellClickTypeGrade://待评价
        {
            
            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=7"];
            
        }
            break;
            
            
            //        case UserOrderCellClickTypeAll://全部
            //        {
            //            [self pushMyOrderHtml:@"/html/home/#/my/orderList"];
            //        }
            //            break;
            //
            //        case UserOrderCellClickTypePendingPayment://代付款
            //        {
            //            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=1"];
            //        }
            //            break;
            //        case UserOrderCellClickTypeToBeShipped: //待发货
            //        {
            //            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=2"];
            //
            //        }
            //            break;
            //        case UserOrderCellClickTypeGoodsReceived://待h收货
            //        {
            //            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=3"];
            //
            //        }
            //            break;
            //        case UserOrderCellClickTypeGrade://待评价
            //        {
            //
            //            [self pushMyOrderHtml:@"/html/home/#/my/orderlist?orderState=7"];
            //
            //        }
            //            break;
            //
            
        default:
            //        {
            //            MyOrderViewController *vc = [[MyOrderViewController alloc] init];
            //            if (self.checkShopsModel.data.RMGrade==1) {//免费会员
            //                vc.titleArr = @[@"全部",@"商城",@"新零售",@"全球家"];
            //            }else {
            //                vc.titleArr = @[@"全部",@"商城",@"新零售",@"全球家",@"代理订单",@"福利订单",@"RM注册订单"];
            //            }
            //            vc.type = type;
            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            break;
    }
    
}
- (void)pushMyOrderHtml:(NSString *)webUrl{
    MyJumpHTML5ViewController *HtmlVC = [[MyJumpHTML5ViewController alloc] init];
    HtmlVC.webUrl = webUrl;
    HtmlVC.hidesBottomBarWhenPushed=YES;
    HtmlVC.navigationController.navigationBar.hidden=YES;
    [self.navigationController pushViewController:HtmlVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            //订单
            return 70;
        }
            
            break;
        case 1:
        {
            //商铺管理
            return 45;
        }
            
            break;
        case 2:
        {
            //RM门店管理
            return 45;
        }
            
            break;
        case 3:
        {
            //常用服务
            return 45;
        }
            
            break;
            
        default:
        {
            return 45;
        }
            
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            
        case 1:
        {//商铺管理
            
            if ([[_nameArray1 objectAtIndex:indexPath.row] isEqualToString:@"销售订单管理"]) {
                YunDianOrderViewController *vc = [[YunDianOrderViewController alloc] init];
                
                [self.navigationController pushViewController:vc animated:YES];
              
            }
            if ([[_nameArray1 objectAtIndex:indexPath.row] isEqualToString:@"云店管理"]) {
                CloudManageMainController * vc = [[CloudManageMainController alloc]init];
                vc.RMGrade=self.checkShopsModel.data.RMGrade;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([[_nameArray1 objectAtIndex:indexPath.row] isEqualToString:@"商城店铺入驻"]) {
                if (self.checkShopsModel.data.isHfShops) {
                    // 有合发购物店铺审核未通过
                    if (self.checkShopsModel.data.hfShopsState<3) {
                        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/oto/reg-progress-hfg.html"];
                        HtmlVC.hidesBottomBarWhenPushed=YES;
                        HtmlVC.navigationController.navigationBar.hidden=YES;
                        [self.navigationController pushViewController:HtmlVC animated:YES];
                        
                        
                    }else if(self.checkShopsModel.data.hfShopsState==3)
                    {  //有合发购物店铺审核通过
                        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/globalhome/house-owner/business_r.html"];
                        HtmlVC.hidesBottomBarWhenPushed=YES;
                        HtmlVC.navigationController.navigationBar.hidden=YES;
                        [self.navigationController pushViewController:HtmlVC animated:YES];
                        //                        name1=@"合发购店铺管理";
                        //                        /html/globalhome/house-owner/business_r.html
                    }else if(self.checkShopsModel.data.hfShopsState==6) {
                        NSComparisonResult comparisonResult = [[VersionTools osVersion] compare:@"8.0"];
                        if (comparisonResult == NSOrderedAscending) {//8.0以上的版本
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的店铺已下线，请至PC端维护店铺信息"  preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                // 确定按钮的点击事件
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的店铺已下线，请至PC端维护店铺信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alertView show];
                            
                        }
                        
                    }
                    
                }else
                {
                    //  name1=@"合发购店铺入驻";
                    MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/goods/main/registerHfg.html"];
                    HtmlVC.hidesBottomBarWhenPushed=YES;
                    HtmlVC.navigationController.navigationBar.hidden=YES;
                    [self.navigationController pushViewController:HtmlVC animated:YES];
                    //                  /html/goods/main/registerHfg.html
                }
            }
            if ([[_nameArray1 objectAtIndex:indexPath.row] isEqualToString:@"商城店铺管理"]) {
                if (self.checkShopsModel.data.isHfShops) {
                    // 有合发购物店铺审核未通过
                    if (self.checkShopsModel.data.hfShopsState<3) {
                        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/oto/reg-progress-hfg.html"];
                        HtmlVC.hidesBottomBarWhenPushed=YES;
                        HtmlVC.navigationController.navigationBar.hidden=YES;
                        [self.navigationController pushViewController:HtmlVC animated:YES];
                        
                        
                    }else if(self.checkShopsModel.data.hfShopsState==3)
                    {  //有合发购物店铺审核通过
                        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/globalhome/house-owner/business_r.html"];
                        HtmlVC.hidesBottomBarWhenPushed=YES;
                        HtmlVC.navigationController.navigationBar.hidden=YES;
                        [self.navigationController pushViewController:HtmlVC animated:YES];
                        //                        name1=@"合发购店铺管理";
                        //                        /html/globalhome/house-owner/business_r.html
                    }else if(self.checkShopsModel.data.hfShopsState==6) {
                        NSComparisonResult comparisonResult = [[VersionTools osVersion] compare:@"8.0"];
                        if (comparisonResult == NSOrderedAscending) {//8.0以上的版本
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的店铺已下线，请至PC端维护店铺信息"  preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                // 确定按钮的点击事件
                            }];
                            [alertController addAction:action];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的店铺已下线，请至PC端维护店铺信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alertView show];
                            
                        }
                        
                    }
                    
                }else
                {
                    //  name1=@"合发购店铺入驻";
                    MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/goods/main/registerHfg.html"];
                    HtmlVC.hidesBottomBarWhenPushed=YES;
                    HtmlVC.navigationController.navigationBar.hidden=YES;
                    [self.navigationController pushViewController:HtmlVC animated:YES];
                    //                  /html/goods/main/registerHfg.html
                }
            }
            if ([[_nameArray1 objectAtIndex:indexPath.row] isEqualToString:@"注册RM门店"]) {
                if (self.checkShopsModel.data.RMGrade<=1) {//注册RM
                    
                    MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                    if (self.checkShopsModel.data.regOrder && self.checkShopsModel.data.regOrder > 0) {
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/failregister?id=%ld",self.checkShopsModel.data.regOrder];
                    }else
                    {
                        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/registerrm"];
                    }
                    HtmlVC.navigationController.navigationBar.hidden=YES;
                    HtmlVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:HtmlVC animated:YES];
                }else
                {//新零售店铺管理
                    MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/newRetail/nRShopManagement?RMGrade=%ld",(long)self.checkShopsModel.data.RMGrade];
                    HtmlVC.hidesBottomBarWhenPushed=YES;
                    HtmlVC.navigationController.navigationBar.hidden=YES;
                    [self.navigationController pushViewController:HtmlVC animated:YES];
                }
            }
            
        }
            break;
        case 2:
        {//门店管理
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"邀请RM"]) {
               
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                if (self.checkShopsModel.data.proxyRegOrder && self.checkShopsModel.data.proxyRegOrder > 0) {
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/failregister?id=%ld",self.checkShopsModel.data.proxyRegOrder];
                }else
                {
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/rep/registerrm"];
                }
                HtmlVC.navigationController.navigationBar.hidden=YES;
                HtmlVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
            }
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"升级RM"]) {
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                if (self.checkShopsModel.data.upgradeOrder && self.checkShopsModel.data.upgradeOrder > 0) {
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/self/failregister?id=%ld",self.checkShopsModel.data.upgradeOrder];
                }else
                {
                    HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/upgrade/rmorder/upgrade/preorder"];
                }
                HtmlVC.navigationController.navigationBar.hidden=YES;
                HtmlVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
            }
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"福利商品/福利订单"]) {
                //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/globalhome/agency-mall/welfare.html"];
                //                HtmlVC.navigationController.navigationBar.hidden=YES;
                //                HtmlVC.hidesBottomBarWhenPushed=YES;
                //                [self.navigationController pushViewController:HtmlVC animated:YES];
                WelfareViewController * vc = [[WelfareViewController alloc] init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"代理管理"]) {
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/proxyManagement"];
                HtmlVC.navigationController.navigationBar.hidden=YES;
                HtmlVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
                
            }
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"代理商品"]) {
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/goods/cart/agency"];
                HtmlVC.navigationController.navigationBar.hidden=YES;
                HtmlVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
            }
            
            if ([[_nameArray2 objectAtIndex:indexPath.row] isEqualToString:@"申请街镇代"]) {
                [self jumpJumpHTML5RMGrade];
            }
        }
            break;
            
        case 3:
        {//常用服务
            
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"销售线索"]) {
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/mls/track_r.html"];
                HtmlVC.hidesBottomBarWhenPushed=YES;
                HtmlVC.navigationController.navigationBar.hidden=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
            }
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"我的收藏"]) {
                
                //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/mall/myFollow.html"];
                //                HtmlVC.hidesBottomBarWhenPushed=YES;
                //                HtmlVC.navigationController.navigationBar.hidden=YES;
                //                [self.navigationController pushViewController:HtmlVC animated:YES];
                CollectMainController * collectVC = [[CollectMainController alloc]init];
                collectVC.hidesBottomBarWhenPushed = YES;
                collectVC.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:collectVC animated:YES];
                
            }
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"我的团购"]) {
                //                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                //                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/house/airClass/MyCollage.html"];
                //                HtmlVC.hidesBottomBarWhenPushed=YES;
                //                HtmlVC.navigationController.navigationBar.hidden=YES;
                //                [self.navigationController pushViewController:HtmlVC animated:YES];
                GroupMainViewController *groupVC = [[GroupMainViewController alloc]init];
                groupVC.hidesBottomBarWhenPushed = YES;
                groupVC.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:groupVC animated:YES];
            }
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"邀请好友"]) {
                MyQrcodeViewController *VC = [[MyQrcodeViewController alloc]init];
                VC.ntitle = @"邀请好友";
                VC.imagePath = self.userInfoModel.data.userCenterInfo.imagePath ?: @"";
                [self.navigationController pushViewController:VC animated:YES];
            }
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"通讯录邀约"]) {
                HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
                HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
                phoneVC.InviteClick = ^(NSString*PhoneNum){
                    
                    
                };
                NSString *sid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
                NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
                NSString *mobilephone =  [[NSUserDefaults standardUserDefaults]objectForKey:@"mobilephone"];
                if (sid <= 0) { // 未登录状态
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前用户未登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                }else if (uid.length > 0 &&mobilephone.length > 0) {
                    NSDictionary *dic =@{
                                         @"uid" : uid,
                                         @"mobilephone" :mobilephone
                                         };
                    conVC.phoneVC = phoneVC;
                    conVC.automaticallyAdjustsScrollViewInsets = NO;
                    conVC.infoDic = dic;
                    [self.navigationController pushViewController:conVC animated:YES];
                }
            }
            if ([[_nameArray3 objectAtIndex:indexPath.row] isEqualToString:@"购买门票"]) {
                HMHPopAppointViewController *pvc = [[HMHPopAppointViewController alloc]init];
                pvc.urlStr =[NSString stringWithFormat:@"%@/html/house/other/PC_tickets.html",fyMainHomeUrl];
                pvc.hidesBottomBarWhenPushed=YES;
                pvc.navigationController.navigationBar.hidden=YES;
                pvc.edgesForExtendedLayout=UIRectEdgeNone;
                [self.navigationController pushViewController:pvc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    
}
-(void)jumpJumpHTML5RMGrade
{
    if (self.checkShopsModel.data.RMGrade==1) {//空投代理会员
        MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
        HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/ignorepage"];
        HtmlVC.hidesBottomBarWhenPushed=YES;
        HtmlVC.navigationController.navigationBar.hidden=YES;
        [self.navigationController pushViewController:HtmlVC animated:YES];
        //                    /html/home/#/user/ignorepage
    }else
    {
        if (self.checkShopsModel.data.RMGrade==4||self.checkShopsModel.data.agentWhite==1){
            if (self.checkShopsModel.data.RMAgent== 2 || self.checkShopsModel.data.RMAgent== 4  || self.checkShopsModel.data.RMAgent== 7 || self.checkShopsModel.data.RMAgent==8||self.checkShopsModel.data.RMAgent== 5)
            {//注册街镇代
                //                        name4=@"注册街镇代";
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/applicationInfo"];
                HtmlVC.hidesBottomBarWhenPushed=YES;
                HtmlVC.navigationController.navigationBar.hidden=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
                //                            /html/home/#/user/applicationInfo
                
            }else if (self.checkShopsModel.data.RMAgent== 0 || self.checkShopsModel.data.RMAgent== 1 || self.checkShopsModel.data.RMAgent== 3 || self.checkShopsModel.data.RMAgent== 6 )
            {//我的街镇代
                //                        name4=@"我的街镇代";
                MyJumpHTML5ViewController *HtmlVC=[[MyJumpHTML5ViewController alloc]init];
                HtmlVC.webUrl=[NSString stringWithFormat:@"/html/home/#/user/jzdlist"];
                HtmlVC.hidesBottomBarWhenPushed=YES;
                HtmlVC.navigationController.navigationBar.hidden=YES;
                [self.navigationController pushViewController:HtmlVC animated:YES];
                //                            /html/home/#/user/jzdlist
            }else
            {
                NSComparisonResult comparisonResult = [[VersionTools osVersion] compare:@"8.0"];
                if (comparisonResult == NSOrderedAscending) {//8.0以上的版本
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"出错了，请刷新或者联系管理员。"  preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 确定按钮的点击事件
                    }];
                    [alertController addAction:action];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"出错了，请刷新或者联系管理员。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                //
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 55;
        }
            break;
        case 1:
        {
            if (_nameArray1.count>0) {
                return 50;
            }else
            {
                return 0;
            }
            
        }
            break;
        case 2:
        {
            if (_nameArray2.count>0) {
                return 50;
            }else
            {
                return 0;
            }
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return 10;
        }
            break;
        case 1:
        {
            if (_nameArray1.count>0)
            {
                return 10;
            }else
            {
                return 0;
            }
            
        }
            break;
        case 2:
        {
            if (_nameArray2.count>0)
            {
                return 10;
            }else
            {
                return 0;
            }
        }
            break;
        case 3:
        {
            return 0;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 55)];
            headerView.backgroundColor=[UIColor whiteColor];
            UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(20,20, ScreenW-110, 20)];
            hotLab.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
            hotLab.textColor=HEXCOLOR(0x333333);
            hotLab.text = @"我的订单";
            [headerView addSubview:hotLab];
            
            
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(ScreenW-30, 23, 15, 15);
            [btn setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pushOrderVCAtion) forControlEvents:(UIControlEventTouchUpInside)];
            [headerView addSubview:btn];
            
            UILabel *cheackLable=[[UILabel alloc] initWithFrame:CGRectMake(ScreenW-90,23, 55, 15)];
            cheackLable.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
            cheackLable.textColor=HEXCOLOR(0x666666);
            cheackLable.text = @"查看全部";
            cheackLable.userInteractionEnabled = YES;
            [headerView addSubview:cheackLable];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushOrderVCAtion)];
            [cheackLable addGestureRecognizer:tap];
            return headerView;
        }
            break;
        case 1:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            headerView.backgroundColor=[UIColor whiteColor];
            UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(20,15, ScreenW-40, 20)];
            hotLab.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
            hotLab.textColor=HEXCOLOR(0x333333);
            hotLab.text = @"商铺管理";
            [headerView addSubview:hotLab];
            return headerView;
        }
            break;
        case 2:
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
            headerView.backgroundColor=[UIColor whiteColor];
            UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(20,15, ScreenW-40, 20)];
            hotLab.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightSemibold];
            hotLab.textColor=HEXCOLOR(0x333333);
            hotLab.text = @"RM门店管理";
            [headerView addSubview:hotLab];
            return headerView;
        }
            break;
        case 3:
        {
            //            常用服务
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
            break;
            
        default:
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
            break;
    }
    
    
}

/**
 订单-查看全部
 */
- (void)pushOrderVCAtion{
    [self pushMyOrderHtml:@"/html/home/#/my/orderList"];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    footView.backgroundColor=HEXCOLOR(0xF5F5F5);
    return footView;
    
    
}

//查看绩效
-(void)checkMyPerformance
{
    AchievementViewController *vc = [[AchievementViewController alloc] init];
    vc.view.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:vc.view];
    [vc setDatavale:[NSString stringWithFormat:@"%ld",(long)self.userInfoModel.data.userCenterInfo.marketPerformance] shopLab:[NSString stringWithFormat:@"%ld",(long)self.userInfoModel.data.userCenterInfo.marketPerformanceProfit]];
}
-(void)tapGRAction:(UITapGestureRecognizer*)gesture
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    //单条移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginout_refrensh" object:nil];
    //移除所有观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
