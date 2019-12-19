//
//  HMHContactTabViewController.m
//  housebank
//
//  Created by 任为 on 2017/9/18.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHContactTabViewController.h"
#import "NTESSessionListViewController.h"
#import "UIButton+ContactButton.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import <AudioToolbox/AudioToolbox.h>



@interface HMHContactTabViewController ()<NIMChatManagerDelegate>

@property(nonatomic,weak)UIViewController *currentView;
@property(nonatomic,strong)NTESSessionListViewController *HMH_NETSessionVC;
@property(nonatomic,weak)UIButton *HMH_selectButton;
@property (nonatomic, strong) UILabel *HMH_redLab;

@end

@implementation HMHContactTabViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self supportedInterfaceOrientations];
//    [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//    [[self class]attemptRotationToDeviceOrientation];
//    
//    NSInteger unCount = [[[NIMSDK sharedSDK] conversationManager] allUnreadCount];
//    if (unCount) {
//        _HMH_redLab.hidden = NO;
//    } else {
//        _HMH_redLab.hidden = YES;
//    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleView];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
   // [[NIMSDK sharedSDK].conversationManager addDelegate:self];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setImage:[UIImage imageNamed:@"VH_blackBack"] forState:UIControlStateNormal];
   lButton.frame = CGRectMake(0, 0, 60, 44);
    lButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 24);
    [lButton addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:lButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //self.phoneVC = [[HMHPhoneBookViewController alloc]init];
    self.phoneVC.uid = [NSString stringWithFormat:@"%@",_infoDic[@"uid"]];
    self.phoneVC.mobilePhone = _infoDic[@"mobilephone"];
    self.phoneVC.color = @"#222222";
//    self.phoneVC.automaticallyAdjustsScrollViewInsets = NO;
    self.HMH_NETSessionVC = [[NTESSessionListViewController alloc]init];
//    self.HMH_NETSessionVC.automaticallyAdjustsScrollViewInsets = NO;
    self.HMH_NETSessionVC.view.frame = CGRectMake(0,0, self.view.width, self.view.height);
    self.phoneVC.view.frame = CGRectMake(0,0, self.view.width, self.view.height);
    [self addChildViewController:self.phoneVC];
    [self addChildViewController:self.HMH_NETSessionVC];
    [self.view addSubview:self.phoneVC.view];
    //[self.view addSubview:_HMH_NETSessionVC.view];

    // 判断IM是否登录
    [self judgeIMIsLogin];
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//消息
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    if ([[[NIMSDK sharedSDK]loginManager]isLogined]) {
//        NSInteger cout = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
//        UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//        if ([tab isKindOfClass:[UITabBarController class]]) {
//            UINavigationController *navc = tab.viewControllers[3];
//            if ([navc isKindOfClass:[UINavigationController class]]) {
//                UIViewController *vc = navc.viewControllers[0];
//                if (cout>0) {
//                    vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",cout];
//                }else{
//                    
//                    vc.tabBarItem.badgeValue = nil;
//                    
//                }
//            }
//        }
//    }
    
}
// 判断IM是否登录
- (void)judgeIMIsLogin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * account = [ud objectForKey:@"account"];
    NSString * token = [ud objectForKey:@"token"];
    LoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *dataAccount = [data account];
    NSString *dataToken = [data token];
    NSLog(@"%@    %@",account,token);
    if (account.length > 0 && token.length > 0 && ![account isEqualToString:@"(null)"] && ![token isEqualToString:@"(null)"]) {
        //是否登录
        BOOL islogin =  [[[NIMSDK sharedSDK]loginManager] isLogined];
        if (!islogin){ // 如果登录失败 重新登录
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[account,token] forKeys:@[@"accid",@"token"]];
            //登录
            [self loginAtNetease:dic];
            
        }
    } else if(dataAccount.length > 0 && dataToken.length > 0 ){
        //是否登录
        BOOL islogin =  [[[NIMSDK sharedSDK]loginManager] isLogined];
        if (!islogin){ // 如果登录失败 重新登录
            NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[dataAccount,dataToken] forKeys:@[@"accid",@"token"]];
            //登录
            [self loginAtNetease:dic];
        }
    }else {
        // 调接口
        NSString *uidStr = [NSString stringWithFormat:@"%@",_infoDic[@"uid"]];
        NSString *getUrlStr = [[NetWorkManager shareManager] getForKey:@"message.netease-receiver/netease-account/get"];
        if (getUrlStr) {
            getUrlStr = [NSString stringWithFormat:@"%@?userId=%@",getUrlStr,uidStr];
        }

        [self postData:nil withUrl:getUrlStr];
    }
}
// 获取im的token和accid
- (void)postData:(NSDictionary*)dic withUrl:(NSString *)url{


    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    [HFCarRequest requsetUrl:urlstr withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self HMH_prcessdata:request.responseObject];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}
// 请求成功之后做的处理
- (void)HMH_prcessdata:(id)data{
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resDic = data;
        NSInteger state = [resDic[@"state"] integerValue];
            if (state == 1) {
                NSDictionary *dataDic = resDic[@"data"];
                NSString *accid = dataDic[@"accid"];
                NSString *token = dataDic[@"token"];
                
                if (accid.length>0 && token.length>0) {
                    // 存账号和token
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:accid forKey:@"account"];
                    [ud setObject:token forKey:@"token"];
                    [ud synchronize];
                    
                    LoginData *sdkData = [[LoginData alloc] init];
                    sdkData.account   = accid;
                    sdkData.token     = token;
                    [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                    [[NTESServiceManager sharedManager] start];
                    //是否登录
                    BOOL islogin =  [[[NIMSDK sharedSDK]loginManager] isLogined];
                    if (!islogin){ // 如果登录失败 重新登录
                    
                        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[accid,token] forKeys:@[@"accid",@"token"]];
                        //登录
                        [self loginAtNetease:dic];
                    }
                    
                }
            }
    }else {
        return;
    }
}
// 登录
- (void)loginAtNetease:(id)body{
    NSDictionary *dic = body;
    NSString *accid = dic[@"accid"];
    NSString *token = dic[@"token"];
    if (accid.length > 0 && token.length > 0) {
        [[[NIMSDK sharedSDK] loginManager] login:accid
                                           token:token
                                      completion:^(NSError *error) {
                                          if (error == nil)
                                          {
                                              LoginData *sdkData = [[LoginData alloc] init];
                                              sdkData.account   = accid;
                                              sdkData.token     = token;
                                              [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                              [[NTESServiceManager sharedManager] start];
                                              
                                              NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                              [ud setObject:accid forKey:@"account"];
                                              [ud setObject:token forKey:@"token"];
                                              [ud synchronize];
                                              
                                          }
                                          else
                                          {
                                              NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
//                                              [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                          }
                                      }];
    }
}


- (void)setTitleView{
 
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ffffff"];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor blackColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 37)];
    UIButton *PhoneNumButton = [UIButton contactButtonWithTitle:@"通讯录" Color:@"#222222" font:[UIFont systemFontOfSize:12 weight:2]];
    PhoneNumButton.frame = CGRectMake(0, 0, titleView.bounds.size.width/2, titleView.bounds.size.height);
//    PhoneNumButton.frame = CGRectMake(0, 0, 140/2, 37);

    PhoneNumButton.selected = YES;
    
    UIButton *contactListButton = [UIButton contactButtonWithTitle:@"最近联系人" Color:@"#222222" font:[UIFont systemFontOfSize:12 weight:2]];
    self.navigationItem.titleView = titleView;
    contactListButton.frame = CGRectMake(titleView.bounds.size.width/2, 0, titleView.bounds.size.width/2, titleView.bounds.size.height);
//    contactListButton.frame = CGRectMake(140/2, 0, 140/2, 37);
    
    [contactListButton setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
    
    self.contactListButton = contactListButton;
    NSLog(@"%f",titleView.width);
    [titleView addSubview:PhoneNumButton];
    [titleView addSubview:contactListButton];

    _HMH_redLab = [[UILabel alloc] init];
    _HMH_redLab.frame = CGRectMake(contactListButton.width - 13, 3, 6, 6);
    _HMH_redLab.backgroundColor = [UIColor redColor];
    _HMH_redLab.layer.masksToBounds = YES;
    _HMH_redLab.layer.cornerRadius = _HMH_redLab.width / 2;
    [contactListButton addSubview:_HMH_redLab];
    _HMH_redLab.hidden = YES;

    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 10;
    titleView.layer.borderColor = [[UIColor blackColor]CGColor];
    titleView.layer.borderWidth = 1.5;

    PhoneNumButton.tag = 101;
    [PhoneNumButton addTarget:self action:@selector(butonCilck:) forControlEvents:UIControlEventTouchUpInside];
    contactListButton.tag = 102;
    [contactListButton addTarget:self action:@selector(butonCilck:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)butonCilck:(UIButton*)selectedButton{

    if (selectedButton == self.HMH_selectButton) {
        return;
    }
    NSArray *views = self.navigationItem.titleView.subviews;
    
    NSLog(@"%ld",selectedButton.tag);
    
    for (int i=0; i<views.count; i++) {
        
        UIButton *button = views[i];
        if (button==selectedButton) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor colorWithHexString:@"#222222"]];
         
        }else{
            button.selected = NO;
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    if (selectedButton.tag ==101 ) {
//        self.phoneVC.view.frame = CGRectMake(0, 0, ScreenW, self.view.height);
        [self replaceController:self.HMH_NETSessionVC newController:self.phoneVC];
       // [self.HMH_NETSessionVC.view removeFromSuperview];
       // [self.view addSubview:self.phoneVC.view];
        
    } else {
//        self.HMH_NETSessionVC.view.frame = CGRectMake(0, 0, ScreenW, self.view.height);

        [self replaceController:self.phoneVC newController:self.HMH_NETSessionVC];
      //  [self.phoneVC.view removeFromSuperview];
      //  [self.view addSubview:self.HMH_NETSessionVC.view];
       
    }
    self.HMH_selectButton = selectedButton;

}
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.1 options:UIViewAnimationOptionPreferredFramesPerSecondDefault animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
