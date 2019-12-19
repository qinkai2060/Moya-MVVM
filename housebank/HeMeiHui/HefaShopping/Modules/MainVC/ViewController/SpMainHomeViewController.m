//
//  SpMainHomeViewController.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/4.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpMainHomeViewController.h"
#import "HFHomeMainViewModel.h"
#import "WRNavigationBar.h"
#import "HFGlobalInterfaceModel.h"
#import "SpTypesSearchViewController.h"
#import "HFRegsiterView.h"
#import "HFHomeMainNewView.h"
#import "HFBrowserModel.h"
#import "HFNewsModel.h"
#import "HFAdModel.h"
#import "HFTimeLimitModel.h"
#import "HFSpecialPriceOneModel.h"
#import "HFFashionModel.h"
#import "HFZuberModel.h"
#import "HFModuleFourModel.h"
#import "HFMoudleFiveModel.h"
#import "HFModuleSixModel.h"
#import "MainHomeViewController.h"
#import "HFShouYinViewController.h"
#import "HMHGloblehomeTabBarViewController.h"
#import "HFLoginViewController.h"
#import "JPUSHService.h"
#import "HMHLiveVideoHomeViewController.h"
#import "HFLoginH5WebViewController.h"
#import "HFIMMessageController.h"
#import "HFYDDetialViewController.h"
#import "HFVIPViewController.h"
#import "VipLoadViewModel.h"
#import "VipGiftPopView.h"
#import "AdvertisementView.h"
#import "HFSectionModel.h"
#import "HFPopupModel.h"
#import "HFHomeBaseModel.h"
#import "HFUserLoginAlertView.h"
#import "SpTypesSearchListViewController.h"
@interface SpMainHomeViewController ()<HFShouYinViewControllerDelegate>
@property(nonatomic,strong)HFHomeMainNewView *homeMainView;
@property(nonatomic,strong)HFHomeMainViewModel *viewModel;
@property(nonatomic,strong)UIView *rightview;
@property(nonatomic,strong)UIButton *titlebtn;
@property (nonatomic, strong)  HMHGoodsPushAlertView *goodsAlertView;
@property (nonatomic, strong) AdvertisementView *guangGaoVc;
@property(nonatomic,strong)HFLinkMappModel *linkMappingModel;

@property (nonatomic, strong) VipLoadViewModel * vipLoadViewModel;
@property (nonatomic, strong) VipGiftPopView * popVipAlertView;
@property (nonatomic, assign) BOOL isShowAlert;//是否需要显示VIP
@property (nonatomic, assign) BOOL isShowPriveAlert;//是否需要显示隐私
@property (nonatomic, assign) BOOL isShowBannerAlert;//是否需要显示广告

@end

@implementation SpMainHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏按钮和标题颜色
    self.isShowPriveAlert = YES;
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    [self setNavBar];
    [self.view addSubview:self.homeMainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popHomeMe:) name:@"loadingHome" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBanner:) name:@"closeVIPPG" object:nil];
    [self.viewModel.moudleRqCommand execute:nil];
    [self enterHightEnd];
    [self didBrowserVC];
    [self didGlobalHandler];
    [self didNewsHandler];
    [self didNewsMoreHandler];
    [self didTimeKillHander];
    [self didBannerHandler];
    [self didSpecialHandler];
    [self didZuberHandler];
    [self didModuleFourHandler];
    [self didModuleFiveHandler];
    [self didModuleSixHandler];
    [self didFashionHandler];
    [self navBarAlpha];
    [self regInvitation];
    [HFKefuButton kefuBtn:self];
//    添加版本环境提示提示按钮
    NSString *contionTest=@"";
    if ([CurrentEnvironment isEqualToString:@"https://mall-api.fybanks.cn"]) {//测试1
         HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
        contionTest=[NSString stringWithFormat:@"测试1:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }else if ([CurrentEnvironment isEqualToString:@"https://mall-api.9yuekj.com"])//测试2
    {
        HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
          contionTest=[NSString stringWithFormat:@"测试2:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }else if ([CurrentEnvironment isEqualToString:@"https://mall-api.hfjyuan.com"])//测试3
    {
        HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
          contionTest=[NSString stringWithFormat:@"测试3:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }else if ([CurrentEnvironment isEqualToString:@"https://mall-api.ijiuyue.com"])//开发1
    {
        HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
          contionTest=[NSString stringWithFormat:@"开发1:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }
    else if ([CurrentEnvironment isEqualToString:@"https://mall-api.hfqqjia.com"])//开发2
    {
        HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
          contionTest=[NSString stringWithFormat:@"开发2:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }else if ([CurrentEnvironment isEqualToString:@"https://mall-api.heyoucloud.com"])//预生产
    {
        HFKefuButton *aleartView= [HFKefuButton showAlertView:self];
         contionTest=[NSString stringWithFormat:@"预生产:%@",AleartString];
        [aleartView setTitle:contionTest forState:UIControlStateNormal];
    }
  
    [self.viewModel.didFinishLoadData subscribeNext:^(id  _Nullable x) {
        //  首页数据加载完成  只启动时加载广告页面
        HFSectionModel *sectionModel=x;
        if (sectionModel.dataModelSource.count>0) {
            HFPopupModel *model=(HFPopupModel*)[sectionModel.dataModelSource objectAtIndex:0];
            if (model.dataArray.count>0) {
                HFPopupModel *model1=[model.dataArray objectAtIndex:0];
                if (!self.guangGaoVc.isOpen&&model1.linkMappingModel&&model1.linkMappingModel.link.length>0) {
                    [self.guangGaoVc.middleImageView sd_setImageWithURL:[NSURL URLWithString:model1.imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                    self.linkMappingModel=model1.linkMappingModel;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                    [self.guangGaoVc.middleImageView addGestureRecognizer:tap];
                    [self.guangGaoVc popViewAnimation];
                }
            }
            
        }
        
    }];
}
-(void)tapAction:(id)sender
{

    [self.guangGaoVc  closeAnimation];
    [self  enterModule:self.linkMappingModel];
    
//    HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
//    vc.isMore = YES;
//    if (![self.guangGaoVc.pagUrl hasPrefix:@"http"]) {
//        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,self.guangGaoVc.pagUrl]];
//    } else {
//        [vc setShareUrl:self.guangGaoVc.pagUrl];
//    }
//
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [HFCarRequest navtiveSwitch];
    self.navigationController.navigationBar.translucent = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self wr_setNavBarBarTintColor:[UIColor colorWithHexString:@"F3344A"]];
    [self setNavBgColor:[UIColor clearColor]];
    [self wr_setNavBarShadowImageHidden:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.homeMainView shipei];
//    [self.navigationController.navigationBar setTranslucent:YES];
#pragma mark -- VIP的弹框
    if (self.isShowAlert == YES&&self.isShowPriveAlert == NO) {
        [self addVIPAlertView];
    }
}
#pragma mark -- 控制弹框顺序
- (void)addVIPAlertView {
    self.guangGaoVc.hidden = NO;
//    @weakify(self);
//    [[self.vipLoadViewModel loadRequest_VipAlert]subscribeNext:^(RACTuple * x) {
//        @strongify(self);
//        if (x) {
//            NSNumber * alert = x.first;
//            if ([alert intValue]>1) {
//                self.popVipAlertView.memberLabel.text = [NSString stringWithFormat:@"%@会员资格",x.last];
//                [self.popVipAlertView popViewAnimation];
//
//            }
//        }else {
//            //不显示立刻领取就是显示广告
//            [UIView animateWithDuration:0.1 animations:^{
//                self.guangGaoVc.hidden = NO;
//            }];
//
//        }
//    } error:^(NSError * _Nullable error) {
//        //不显示立刻领取就是显示广告
//        [UIView animateWithDuration:0.1 animations:^{
//
//            self.guangGaoVc.hidden = NO;
//        }];
//
//    }];
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    
    [self goodsInfoPushMessageWithDic:userInfo];
}
- (void)goodsInfoPushMessageWithDic:(NSDictionary *)dic{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        // 江苏省徐少2天前已下单
        NSString *content = [dic valueForKey:@"content"];
        // 6
        NSString *contentTypeStr = [dic valueForKey:@"content_type"];
        NSDictionary *extras = [dic valueForKey:@"extras"];
        //  /user/1528341538994/s579a4k1mdocljh6.jpg
        NSString *userAvatarStr = [extras valueForKey:@"userAvatar"];
        NSString *urlStr = [extras valueForKey:@"targetUrl"];
        NSString *uidStr = [extras valueForKey:@"uid"];
        NSString *pageTagsStr = [extras valueForKey:@"pageTags4DisplayMsg"];
        // 4  如果没有返回的话 就默认为3秒   此类型为毫秒
        NSNumber *showTimeNum = [extras valueForKey:@"duration"];
        // 比如XXX省XX人3分钟前已下单
        NSString *contentStr = content;
        CGFloat w = [CommonManagementTools getWidthWithFontSize:14.0 height:35 text:contentStr];
        if (_goodsAlertView) {
            [_goodsAlertView hide];
        }
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
        
        if ([contentTypeStr longLongValue] == 1) {
            // uid相等 表示是自己下的单 所以就不用通知
            if ([uidStr isEqualToString:[self getUserUidStr]]) {
                return;
            }
            [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
        } else if ([contentTypeStr longLongValue] == 2){
            // 针对登录的用户  登录用户可以收到
            if (sidStr.length > 6) {
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            }
        } else if ([contentTypeStr longLongValue] == 3){
            // 针对没有登录的用户  未登录用户可以收到
            if (sidStr.length <= 6) {
                [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
            }
        } else if ([contentTypeStr longLongValue] == 4){
            // 针对所有的用户
            [self createGoodsViewWithWidth:w userIconUrl:userAvatarStr contentStr:contentStr showTime:showTimeNum urlStr:urlStr];
        }
    }
    //    }
}
- (NSString *)getUserUidStr{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"uid"]];
    if (uidStr.length > 0 && ![uidStr isEqualToString:@"(null)"]) { //已经登录
        return uidStr;
    }
    return @"";
}
- (void)createGoodsViewWithWidth:(CGFloat)w userIconUrl:(NSString *)userAvatarStr contentStr:(NSString *)contentStr showTime:(NSNumber *)showTimeNum urlStr:(NSString *)urlStr{
    CGFloat f = 0.0;
    if (userAvatarStr.length > 6) {
        f = 40;
    } else {
        f = 0;
    }
    CGFloat nav = IS_iPhoneX ? 44 : 20;
    _goodsAlertView = [[HMHGoodsPushAlertView alloc] initWithFrame:CGRectMake(0, nav + 44 + 60, w + 10 + f, 35) userIconUrl:userAvatarStr contentStr:contentStr isShowTime:[showTimeNum integerValue] / 1000];
    [_goodsAlertView show];
    
    __weak typeof(self)weakSelf = self;
}
- (void)enterHightEnd {
    @weakify(self)
    [self.viewModel.moudleSubjc subscribeNext:^(id  _Nullable x) {
      
    }];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)regInvitation {
    [self.viewModel.regSubject subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
             [HFRegsiterView show:x];
        }else {
            [SVProgressHUD showInfoWithStatus:@"邀请失败"];
            [SVProgressHUD dismiss];
        }
      
    }];
}
- (void)setNavBar {
      [self wr_setNavBarTintColor:[UIColor whiteColor]];
    UIButton *message =[UIButton buttonWithType:UIButtonTypeCustom];
    message.frame=CGRectMake(14, 0, 44, 44);
    [message setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [message addTarget:self action:@selector(globlalHomeClick:) forControlEvents:UIControlEventTouchUpInside];
    //message.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 0, 0);
    UIButton *forward =[UIButton buttonWithType:UIButtonTypeCustom];
    forward.frame=CGRectMake(44+14, 0, 44, 44);
    [forward setImage:[UIImage imageNamed:@"homeforward"] forState:UIControlStateNormal];
    [forward addTarget:self action:@selector(shareHomeClick:) forControlEvents:UIControlEventTouchUpInside];
  //  forward.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 0, 0);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:message];
    [view addSubview:forward];
    self.rightview = view;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    barItem.width = -15;
    self.navigationItem.rightBarButtonItem = barItem;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW-89-10-15-5, 30)];
    btn.layer.cornerRadius = 15.5;
    [btn setImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
    [btn setTitle:@"请输入商品名称"  forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, btn.width-30-20-10);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, btn.width-100-30-20);
   
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goSeachClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"F0F0F0"];
    self.titlebtn = btn;
    self.navigationItem.titleView = btn;
    [self.viewModel.shareSubject subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {
            [ShareTools shareWithContent:[ShareTools dict:x]];
        }else {
            [SVProgressHUD showWithStatus:@"分享失败"];
            [SVProgressHUD dismiss];
        }
        
    }];
    [self.viewModel.scrollerControlSubjc subscribeNext:^(id  _Nullable x) {
//        首页
        self.titlebtn.hidden = [x boolValue];
        self.rightview.hidden = [x boolValue];
    }];
}
- (void)goSeachClick{
    SpTypesSearchViewController *vc = [[SpTypesSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)popHomeMe:(NSNotification*)noti {
     [SVProgressHUD show];
    
 
      [self.viewModel.moudleRqCommand execute:nil];
    
    
// 检查沙盒是否需要展示隐私不需要
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPrivate"] boolValue]) {
        [HFUserLoginAlertView showAlertViewType:HFUserLoginAlertViewTypePrivate title:@"隐私政策" contextTX:[NSString stringWithFormat:@"%@/html/common/privicy-policies.html?hideTitle=1",fyMainHomeUrl] bottomTX:@"" bottomRangeList:@[] cancelTitle:@"不同意" cancelBlock:^(HFUserLoginAlertView *view) {
            exit(0);
        } sureTitle:@"同意" sureBlock:^(HFUserLoginAlertView *view) {
            self.isShowPriveAlert = NO;
            self.isShowAlert = YES;
            //展示完隐私去检查vip领取资格
            if (self.isShowAlert == YES) {
                [self addVIPAlertView];
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPrivate"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        } didTextView:^(NSString *string) {
            
        }];
    }else {
        // 不需要显示隐私的时候去检查VIP领取
        self.isShowAlert = YES;
        self.isShowPriveAlert = NO;
        [self addVIPAlertView];
    }

}
- (void)openBanner:(NSNotification*)noti {
    // VIP领取广告页面关闭了就把广告显示出来
    [UIView animateWithDuration:0.1 animations:^{
        self.guangGaoVc.hidden = NO;
    }];
}
-(void)globlalHomeClick:(UIButton*)sender {
    HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
    vc.delegate = self;
    [vc setShareUrl:[NSString stringWithFormat:@"%@/html/shopping/news/news.html",fyMainHomeUrl]];
    vc.isMore=YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)shareHomeClick:(UIButton*)sender{
    if ([HFUserDataTools isLogin]) {
        [self.viewModel.shareCommand execute:nil];
    }else {
        [HFLoginViewController showViewController:self];
    }
   
}
- (void)didBrowserVC {
    @weakify(self)
    [self.viewModel.didBrowserSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass:[HFBrowserModel class]]) {
            HFBrowserModel *model = (HFBrowserModel*)x;
            [self enterModule:model.linkMappingModel];
        }
       
    }];
}

- (void)didGlobalHandler {
    @weakify(self)
    [self.viewModel.didGloabalSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if([x isKindOfClass:[HFGlobalInterfaceModel class]]) {
            HFGlobalInterfaceModel *model = (HFGlobalInterfaceModel*)x;
            [self enterModule:model.linkMappingModel];
        }
        
    }];
}
- (void)didNewsHandler {
    @weakify(self)
    [self.viewModel.didNewsSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFNewsModel class]]) {
            HFNewsModel *newsModel = (HFNewsModel*)x;
            if ([newsModel.linkMappingModel.type containsString:@"_url"]) {
                HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                vc.delegate = self;
                vc.isMore = YES;
                if (![newsModel.linkMappingModel.link hasPrefix:@"http"]) {
                    [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,newsModel.linkMappingModel.link]];
                }else {
                    [vc setShareUrl:newsModel.linkMappingModel.link];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [self enterModule:newsModel.linkMappingModel];
            }
        
        }
        
    }];
}
- (void)didNewsMoreHandler {
    @weakify(self)
    [self.viewModel.didNewsMoreSubjc subscribeNext:^(id  _Nullable x) {
        HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
        vc.delegate = self;
        vc.isMore = YES;
        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,@"/appstatic/appindex/news/index.html?vv=1548659194646"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)didTimeKillHander {
    @weakify(self)
    [self.viewModel.didTimeKillSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFTimeLimitSmallModel class]]) {
            HFTimeLimitSmallModel *model = (HFTimeLimitSmallModel*)x;
            SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
            if ([NSString stringWithFormat:@"%ld", model.productId].length!=0) {
                vc.productId = [NSString stringWithFormat:@"%ld", model.productId];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }];
}
- (void)didBannerHandler {
     @weakify(self)
    [self.viewModel.didBannerSubjc subscribeNext:^(id  _Nullable x) {
         @strongify(self)
        if ([x isKindOfClass:[HFAdModel class]]) {
            HFAdModel *adModel = (HFAdModel*)x;
//            [HFCarRequest updateClickNumber:famousModel.bannerId]
            HFAdModel *itemsModel = [adModel.dataArray firstObject];
            [self enterModule:itemsModel.linkMappingModel];
        }
    }];
}

- (void)didSpecialHandler {
     @weakify(self)
    [self.viewModel.didSpecialSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFSpecialPriceOneModel class]]) {
            HFSpecialPriceOneModel *spModel = (HFSpecialPriceOneModel*)x;
            [self enterModule:spModel.linkMappingModel];
        }
    }];
}
- (void)didFashionHandler {
     @weakify(self)
    [self.viewModel.didFashionSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFFashionModel class]]) {
            HFFashionModel *fashionModel = (HFFashionModel*)x;
            [self enterModule:fashionModel.linkMappingModel];
        }
        
    }];
}
- (void)didZuberHandler {
     @weakify(self)
    [self.viewModel.didZuberSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFZuberModel class]]) {
            HFZuberModel *zuberModel = (HFZuberModel*)x;
            [self enterModule:zuberModel.linkMappingModel];
        }
        
    }];
}
- (void)didModuleFourHandler {
     @weakify(self)
    [self.viewModel.didModuleFourSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFModuleFourModel class]] ) {
            HFModuleFourModel *moduleFourModel = (HFModuleFourModel*)x;
            [self enterModule:moduleFourModel.linkMappingModel];
        }
    }];
}
- (void)didModuleFiveHandler {
     @weakify(self)
    [self.viewModel.didModuleFiveSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFMoudleFiveModel class]] ) {
            HFMoudleFiveModel *moduleFiveModel = (HFMoudleFiveModel*)x;
            if (moduleFiveModel.tag == 1000) {
                 [self enterModule:moduleFiveModel.linkMappingModel];
            }else {
                 [self enterModule:moduleFiveModel.linkMappingModel2];
            }
           
        }
        
    }];
}
- (void)didModuleSixHandler {
     @weakify(self)
    [self.viewModel.didModuleSixSubjc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isKindOfClass:[HFModuleSixModel class]] ) {
            HFModuleSixModel *moduleSixModel = (HFModuleSixModel*)x;
            [self enterModule:moduleSixModel.linkMappingModel];
        }
        
    }];
}
- (void)navBarAlpha {
    @weakify(self)
    [self.viewModel.sendScaleSubjc subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        CGFloat scale = [x floatValue];
        [self wr_setNavBarBackgroundAlpha:scale*1.0];
    }];
}
- (HFHomeMainNewView *)homeMainView {
    if (!_homeMainView) {
        CGFloat tabH = IS_iPhoneX ?83:49;
        _homeMainView = [[HFHomeMainNewView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-tabH) WithViewModel:self.viewModel];
        _homeMainView.backgroundColor = [UIColor whiteColor];
    }
    return _homeMainView;
}
- (HFHomeMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HFHomeMainViewModel alloc] init];
    }
    return _viewModel;
}
- (void)setNavBgColor:(UIColor *)bgColor
{
    [self.navigationController.navigationBar  setBackgroundImage:[UIImage imageWithColor:bgColor]
                                                  forBarPosition:UIBarPositionAny
                                                      barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[UIImage new]];
    
}

- (void)enterModule:(HFLinkMappModel*)model {
//    HFVIPViewController *vc = [[HFVIPViewController alloc] initWithViewModel:nil];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    //https://m.hfhomes.cn/html/house/onair/video-intro.html?vno=KZKT20191202742863
//     HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
//     [vc setShareUrl:@"https://m.hfhomes.cn/html/house/onair/video-intro.html?vno=KZKT20191202742863"];
//     vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    if([model.type isEqualToString:@"##"] || [model.link isEqualToString:@"##"]) {
        return;
    }
    if (model.isNeedLogin&&![HFUserDataTools isLogin]){
        [HFLoginViewController showViewController:self];
  
    }else {
        if ([model.type isEqualToString:@"hmhMall_details"]) { // 商品详情原生
            SpGoodsDetailViewController *vc = [[SpGoodsDetailViewController alloc] init];
            vc.productId = model.linkId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if ([model.type isEqualToString:@"hmhMall_grouplist"]) { // 合发一元拼团原生
            SpAssembleViewController *vc = [[SpAssembleViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.type isEqualToString:@"pfMall_home"]) { // VIP入口
            HFVIPViewController *vc = [[HFVIPViewController alloc] initWithViewModel:nil];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"hmhMall_classify"]) {// 合发分类原生
            SpTypesSearchListViewController *listVC = [[SpTypesSearchListViewController alloc] init];
            listVC.searchStr = @"";
            listVC.classId = model.linkId;
            listVC.level = @"";
            listVC.isFristIn = YES;
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
        } else if ([model.type isEqualToString:@"hmhMall_key"]) { // 合发购搜索原生
            SpTypesSearchViewController *vc = [[SpTypesSearchViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }  else  if ([model.type isEqualToString:@"hmhMall_discount"]) { // 名品折扣原生
            HFFamousGoodsViewController *vc = [[HFFamousGoodsViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }  else  if ([model.type isEqualToString:@"hmhMall_flashSale"]) { // 限时秒杀原生
            SpSpikeViewController  *vc = [[SpSpikeViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }  else  if ([model.type isEqualToString:@"hmhMall_new"]) { // 每日上新原生
            HFEveryDayViewController *vc  = [[HFEveryDayViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.type isEqualToString:@"hmhMall_99Sale"]) { // 99疯抢原生
            HFCrazyGoodsViewController *vc = [[HFCrazyGoodsViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([model.type isEqualToString:@"hmhMall_onlyFor"]) { // 直供原生
            HFHightEndGoodsViewController *vc = [[HFHightEndGoodsViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.type isEqualToString:@"hmhMall_invitationRegister"]) { // 邀请注册原生
            [self.viewModel.regCommand execute:nil];
        }else if ([model.type isEqualToString:@"hmhMall_live"]) { // 直播原生
           // HMHVideoHomeViewController *vc = [[HMHVideoHomeViewController alloc] init];
            HMHLiveVideoHomeViewController *vc = [[HMHLiveVideoHomeViewController alloc] init];
            vc.view.backgroundColor = [UIColor whiteColor];
            vc.hidesBottomBarWhenPushed = YES;
            [HMHLiveCommendClassTools shareManager].nvController = self.navigationController;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([model.type hasPrefix:@"hotel"]) { // 全球家详情H5
            if ([model.type isEqualToString:@"hotel_url"]) {
                if (model.link.length >0) {
                    HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                    vc.delegate = self;
                    vc.isMore = YES;
                    if (![model.link hasPrefix:@"http"]) {
                        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,model.link]];
                    }else {
                        [vc setShareUrl:model.link];
                    }
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];

                }
            }else if ([model.type isEqualToString:@"hotel_home"]){
                HMHGloblehomeTabBarViewController *vc = [[HMHGloblehomeTabBarViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                self.navigationController.navigationBar.hidden=YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                if (model.link.length >0) {
                    
                    HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                    vc.delegate = self;
                    vc.isMore = YES;
                    if (![model.link hasPrefix:@"http"]) {
                        [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,model.link]];
                    } else {
                        [vc setShareUrl:model.link];
                    }
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        else if([model.type hasPrefix:@"newRetail"]) {
            if (model.link.length >0) {
        
                HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                vc.delegate = self;
                if (![model.link hasPrefix:@"http"]) {
                    [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,model.link]];
                } else {
                    [vc setShareUrl:model.link];
                }
                // [vc webViewLoadDatafromMainUrl:model.link];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
   
        else {
            if (model.link.length >0) {
               
                HFShouYinViewController *vc = [[HFShouYinViewController alloc] init];
                vc.delegate = self;
                vc.isMore = YES;
                if (![model.link hasPrefix:@"http"]) {
                    [vc setShareUrl:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl,model.link]];
                } else {
                    [vc setShareUrl:model.link];
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (void)popNewVC:(NSString *)url vc:(nonnull UIViewController *)evc {
    evc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:evc animated:NO];
}
- (VipLoadViewModel *)vipLoadViewModel {
    if (!_vipLoadViewModel) {
        _vipLoadViewModel = [[VipLoadViewModel alloc]init];
    }
    return _vipLoadViewModel;
}

- (VipGiftPopView *)popVipAlertView {
    if (!_popVipAlertView) {
        _popVipAlertView = [[VipGiftPopView alloc]init];
    }
    return _popVipAlertView;
}

- (AdvertisementView *)guangGaoVc {
    if (!_guangGaoVc) {
        _guangGaoVc = [[AdvertisementView alloc]init];
        _guangGaoVc.hidden=YES;
    }
    return _guangGaoVc;
}
@end
