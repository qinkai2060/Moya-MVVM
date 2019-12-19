//
//  ChatMessageViewController.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/6.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "UIButton+setTitle_Image.h"
#import "HMHContactTabViewController.h"
#import "UIView+PPBadgeView.h"
//#import "HeFaCircleOfFriendViewController.h"


@interface ChatMessageViewController ()

@property(nonatomic,strong) NTESSessionListViewController *NETSessionVC;

@property (nonatomic,assign)CGFloat buttomBarHeghit;
@property (nonatomic,assign)CGFloat statusHeghit;


@end

@implementation ChatMessageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
   // self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.titleView = [self titleView];
    self.view.backgroundColor = RGBACOLOR(244, 244, 244, 1);

    self.statusHeghit = 20;
    self.buttomBarHeghit = 0;
    if (IS_iPhoneX) {
        self.statusHeghit = 44;
        self.buttomBarHeghit = 34;
    }
    
    self.tableView.frame = CGRectMake(0, self.statusHeghit + 44 + 80, ScreenW, ScreenH - self.statusHeghit - 44 - 80);
    
    [self createTopView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = !self.isShowNaBar;
//    self.navigationController.navigationBar.barTintColor =[UIColor colorWithHexString:self.BgColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn addTarget:self action:@selector(chatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [chatBtn setImage:[UIImage imageNamed:@"chat_user"] forState:UIControlStateNormal];
    [chatBtn setImage:[UIImage imageNamed:@"chat_user"] forState:UIControlStateHighlighted];
    [chatBtn sizeToFit];
    UIBarButtonItem *robotInfoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chatBtn];

    self.navigationItem.rightBarButtonItem = robotInfoButtonItem;
}

- (void)createTopView{
    // whiteView
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusHeghit + 44 + 2, ScreenW, 70)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    // 交易物流
    UIButton *businessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    businessBtn.frame = CGRectMake(ScreenW / 2 - ScreenW / 2 / 2 - 35, 10, 70, 50);
    [businessBtn setImage:[UIImage imageNamed:@"chat_wuLiu"] forState:UIControlStateNormal];
    [businessBtn setImage:[UIImage imageNamed:@"chat_wuLiu"] forState:UIControlStateHighlighted];

    [businessBtn setTitle:@"交易物流" forState:UIControlStateNormal];
    businessBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [businessBtn setTitleColor:RGBACOLOR(41, 156, 220, 1) forState:UIControlStateNormal];
    [businessBtn setImagePosition:2 spacing:3];

    [businessBtn addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.expRouterMsgCount>0) { // 添加小红点
        [businessBtn pp_addDotWithColor:[UIColor redColor]];
        [businessBtn pp_moveBadgeWithX:-15 Y:5];
    }
   
    [whiteView addSubview:businessBtn];
    
    // 通知
    UIButton *notificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationBtn.frame = CGRectMake(ScreenW / 2 + ScreenW / 2 / 2 - 35, 10, 70, 50);
    [notificationBtn setImage:[UIImage imageNamed:@"chat_notification"] forState:UIControlStateNormal];
    [notificationBtn setImage:[UIImage imageNamed:@"chat_notification"] forState:UIControlStateHighlighted];
    [notificationBtn setTitle:@"通知" forState:UIControlStateNormal];
    notificationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [notificationBtn setTitleColor:RGBACOLOR(41, 156, 220, 1) forState:UIControlStateNormal];
    [notificationBtn setImagePosition:2 spacing:3];
    
    [notificationBtn addTarget:self action:@selector(notificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.systemMsgCount>0) {
        [notificationBtn pp_addDotWithColor:[UIColor redColor]];
        [notificationBtn pp_moveBadgeWithX:-15 Y:5];
    }
    [whiteView addSubview:notificationBtn];
}

#pragma mark 交易物流按钮的点击事件
- (void)businessBtnClick:(UIButton *)btn{
    [btn pp_hiddenBadge];
    PopAppointViewControllerModel *model = [NavigationContrl getModelFrom:self.expressRouterMsgUrl];
    
    HMHPopAppointViewController*business = [[HMHPopAppointViewController alloc]init];
    business.isNavigationBarshow = NO;
    business.title = @"交易物流";
    business.urlStr = self.expressRouterMsgUrl;
    if (model) {
        business.title = model.title;
        business.naviBg = model.naviBg;
        business.isNavigationBarshow = model.showNavi;
        business.naviMask = model.naviMask;
        business.naviMaskHeight = model.naviMaskHeight;
        business.pageTag = model.pageTag;
    }
    business.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:business animated:YES];
}
#pragma mark 通知按钮的点击事件
- (void)notificationBtnClick:(UIButton *)btn{
    [btn pp_hiddenBadge];
    HMHPopAppointViewController*notifi = [[HMHPopAppointViewController alloc]init];
    /*
     
     PopAppointViewController *pvc = [[PopAppointViewController alloc]init];
     pvc.title = model.title;
     pvc.naviBg = model.naviBg;
     pvc.isNavigationBarshow = model.showNavi;
     pvc.naviMask = model.naviMask;
     pvc.naviMaskHeight = model.naviMaskHeight;
     pvc.urlStr = url;
     pvc.pageTag = model.pageTag;
     pvc.LastPageUrl = lastPageUrl;
     pvc.hidesBottomBarWhenPushed = YES;
     pvc.hidesBottomBarWhenPushed = YES;
     [navigation pushViewController:pvc animated:YES];
     */
    PopAppointViewControllerModel *model = [NavigationContrl getModelFrom:self.appMsgUrl];
    notifi.isNavigationBarshow = NO;
    notifi.title = @"通知";
    notifi.urlStr = self.appMsgUrl;
    if (model) {
        notifi.title = model.title;
        notifi.naviBg = model.naviBg;
        notifi.isNavigationBarshow = model.showNavi;
        notifi.naviMask = model.naviMask;
        notifi.naviMaskHeight = model.naviMaskHeight;
        notifi.pageTag = model.pageTag;
    }
    notifi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notifi animated:YES];
}

#pragma mark 通讯录按钮的点击事件
- (void)chatBtnClick:(UIButton *)btn{
    
    HMHContactTabViewController *conVC = [[HMHContactTabViewController alloc]init];
    HMHPhoneBookViewController *phoneVC = [[HMHPhoneBookViewController alloc]init];
    phoneVC.InviteClick = ^(NSString*PhoneNum){


    };
    NSString *sid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"sid"];
    NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    NSString *mobilephone =  [[NSUserDefaults standardUserDefaults]objectForKey:@"mobilephone"];
    if (sid <= 0) {
        HMHPopAppointViewController *login = [[HMHPopAppointViewController alloc]init];
        login.urlStr = self.loginUrl;
        login.isNavigationBarshow = NO;
        login.hidesBottomBarWhenPushed = YES;
        __weak  typeof (self)weakSelf = self;
        [login setAcontactCallBack:^(NSString *phoneNum, NSString *uid) {
            if (phoneNum.length > 0 && uid.length > 0) {
                    NSDictionary *dic =@{
                                         @"uid" : uid,
                                         @"mobilephone" :phoneNum
                                         };
                    conVC.phoneVC = phoneVC;
                    conVC.automaticallyAdjustsScrollViewInsets = NO;
                    conVC.infoDic = dic;
                    [weakSelf.navigationController pushViewController:conVC animated:YES];
                }
        }];
        [self.navigationController pushViewController:login animated:YES];
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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}

#pragma mark - Private

- (void)refreshSubview{

//    self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
//    self.emptyTipLabel.centerX = self.view.width * .5f;
//    self.emptyTipLabel.centerY = self.tableView.height * .5f;
    
    self.tableView.top = self.statusHeghit + 44 + 80;
    self.tableView.height = ScreenH - self.statusHeghit - 44 - 80;
}

- (UIView*)titleView{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
    titleLab.textColor = [UIColor blackColor];
//    titleLab.text =  self.naTitle;
    titleLab.text = @"消息";
    titleLab.textAlignment = NSTextAlignmentCenter;
    return titleLab;
}

-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
