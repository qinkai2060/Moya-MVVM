//
//  ShareTools.m
//  HeMeiHui
//
//  Created by 任为 on 2016/12/28.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "ShareTools.h"
#import "QRCodeImage.h"

#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

@interface ShareTools()



@end

@implementation ShareTools
/** 标题按钮地下的指示器 */
static id _publishContent;//类方法中的全局变量这样用
static id prgramDic;
static id isyundian;
static UIVisualEffectView *_indicatorView;
static UIButton *_selectBtn;
static id _selectType; //@"链接" @"图片" 详情页分享来区分类型用
- (void)initShareSDK:(NSArray*)platomArrary
{

    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupQQWithAppId:@"1107995805" appkey:@"r6Lt4ijVvOi5PImr"];
        [platformsRegister setupSinaWeiboWithAppkey:@"2701599598" appSecret:@"d5b5bcfabeb644ad74c3c0d71192b577" redirectUrl:@"http://www.sharesdk.cn"];
        [platformsRegister setupWeChatWithAppId:@"wxb372eb1c4a8e393f" appSecret:@"c8550aeff667cc745c6dc3eaeae52174"];
    }];

    
}
//- (void)initShareSDK:(NSArray*)platomArrary
//{
//    NSArray *SharePlatformArrary = @[
//                                     @(SSDKPlatformTypeSinaWeibo),
//                                     @(SSDKPlatformTypeWechat),
//                                     @(SSDKPlatformTypeQQ),
//                                     ];
//    if (platomArrary&&platomArrary.count) {
//
//        SharePlatformArrary = platomArrary;
//    }
//    [ShareSDK registerActivePlatforms:SharePlatformArrary
//                             onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//             SSDKPlatformTypeSinaWeibo: [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2701599598"
//                                           appSecret:@"d5b5bcfabeb644ad74c3c0d71192b577"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:@"wxb372eb1c4a8e393f"
//                                       appSecret:@"c8550aeff667cc745c6dc3eaeae52174"];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"1107995805"
//                                      appKey:@"r6Lt4ijVvOi5PImr"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//
//             default:
//                 break;
//         }
//     }];
//
//}
- (void)doShare:(id)body{
    //    //构造分享内容
    //    id publishContent = [ShareSDK content:str1
    //                           defaultContent:str1
    //                                    image:nil
    //                                    title:@" "
    //                                      url:urlString
    //                              description:str1
    //                                mediaType:SSPublishContentMediaTypeText];
    //    //调用自定义分享
    //    [self shareWithContent:publishContent];
    
    
    
    
    NSMutableArray *sdkPlatomArrary = [NSMutableArray array];
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *infodic = body;
        NSString *shareSnsCustom = infodic[@"shareSnsCustom"];
        NSArray *shareSnsCustomArrary;
        if (![shareSnsCustom isKindOfClass:[NSNull class]]) {
            shareSnsCustomArrary = [shareSnsCustom componentsSeparatedByString:@","];
        }
        if (shareSnsCustomArrary.count) {
            for (NSString *platomName in shareSnsCustomArrary) {
                
                if ([platomName isEqualToString:@"Wechat"]) {//微信好友
                    [sdkPlatomArrary addObject:@(SSDKPlatformSubTypeWechatSession)];
                }else if ([platomName isEqualToString:@"WechatMoments"]){//微信朋友圈
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformSubTypeWechatTimeline)];
                    
                }else if ([platomName isEqualToString:@"WechatFavorite"]){//微信收藏
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformSubTypeWechatFav)];
                    
                    
                }else if ([platomName isEqualToString:@"QQ"]){
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformSubTypeQQFriend)];
                    
                    
                }else if ([platomName isEqualToString:@"QZone"]){
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformSubTypeQZone)];
                    
                    
                }else if ([platomName isEqualToString:@"SinaWeibo"]){
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformTypeSinaWeibo)];
                    
                    
                }else if ([platomName isEqualToString:@"TencentWeibo"]){
                    
                    [sdkPlatomArrary addObject:@(SSDKPlatformTypeTencentWeibo)];
                    
                }
                
            }
            
        }
        
    }
    [self initShareSDK:sdkPlatomArrary];
    NSDictionary *dic = (NSDictionary*)body;
    if (_shareModel   ==nil) {
        _shareModel   = [[shareModel alloc]init];
        [_shareModel setValuesForKeysWithDictionary:dic];
    }else{
        _shareModel   = nil;
        _shareModel   = [[shareModel alloc]init];
        [_shareModel setValuesForKeysWithDictionary:dic];
    }
    //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //    pasteboard.string = _shareModel.shareUrl;
    //    __weak typeof(self) weakSelf = self;
    //   UIAlertController * alertController  = [UIAlertController alertControllerWithTitle:@"温馨提示"
    //                                                                               message:@"已成功复制，直接粘贴进入微信/微博/QQ分享吧！" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
    //                                                     style:UIAlertActionStyleDefault handler:nil];
    //    [alertController addAction:action];
    //    [weakSelf.delegete presentViewController:alertController animated:YES completion:nil];
    //    分享功能。 复制粘贴
    //   [self shareSDKWithUrl:_shareModel isCircleOfFriends:NO];
    
}

//- (void)shareSDKWithUrl:(shareModel*)model isCircleOfFriends:(BOOL)isCircleOfFrieds
//{
//    __weak typeof(self) weakSelf = self;
//    //1、创建分享参数
//    NSArray* imageArray;
//    if (model.shareImageUrl.length > 0 && ![model.shareImageUrl isEqualToString:@"(null)"]) {
//        imageArray = @[model.shareImageUrl];
//    }
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        if ([model.shareType isEqualToString:@"SHARE_IMAGE"]) { // 图片分享
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareModel.shareImageUrl]]];
//
//            [shareParams SSDKSetupShareParamsByText:@"text"
//                                             images:@[image]
//                                                url:[NSURL URLWithString:@""]
//                                              title:@"title"
//                                               type:SSDKContentTypeImage];
//
//        } else { // web分享
//
//            [shareParams SSDKSetupWeChatParamsByText:_shareModel.shareDesc title:_shareModel.shareTitle url:[NSURL URLWithString:_shareModel.shareWeixinUrl] thumbImage:nil image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//
//            [shareParams SSDKSetupShareParamsByText:_shareModel.shareDesc
//                                             images:imageArray
//                                                url:[NSURL URLWithString:_shareModel.shareUrl]
//                                              title:_shareModel.shareTitle
//                                               type:SSDKContentTypeAuto];
//
//            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",_shareModel.shareTitle,_shareModel.shareUrl] title:_shareModel.shareTitle image:imageArray url:[NSURL URLWithString:_shareModel.shareUrl] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
//        }
//        [shareParams SSDKEnableUseClientShare];
//
//        //添加一个自定义的平台
//        SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"circle_icon"]
//                                                                                      label:@"合友圈"
//                                                                                    onClick:^{
//                                                                                        //自定义item被点击的处理逻辑
//                                                                                        HMHSendCircleOfFriendViewController *sendVC = [[HMHSendCircleOfFriendViewController alloc] init];
//                                                                                        sendVC.typeNum = @3;
//                                                                                        sendVC.heFaListModel = self.circleModel;
//                                                                                        [self.delegete.navigationController pushViewController:sendVC animated:YES];                                                                                    }];
//        //再把声明的platforms对象传进分享方法里的items参数里
//        NSArray * platforms;
//        if (isCircleOfFrieds) { // 如果是来自合友圈的转发
//            platforms =@[item,@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
//        }else {
//            platforms = nil;
//        }
//        //     [UMSocialUIManager setPreDefinePlatforms:baseDisplaySnsPlatforms];
//        SSUIShareActionSheetController* sheet =  [ShareSDK showShareActionSheet:self.delegete.view items:platforms
//                                                                    shareParams:shareParams
//                                                            onShareStateChanged:^(
//                                                                                  SSDKResponseState state,
//                                                                                  SSDKPlatformType platformType,
//                                                                                  NSDictionary *userData,
//                                                                                  SSDKContentEntity *contentEntity,
//                                                                                  NSError *error, BOOL end)
//                                                  {
//                                                      if (platformType ==SSDKPlatformTypeSinaWeibo) {
//
//                                                      }
//                                                      switch (state) {
//                                                          case SSDKResponseStateSuccess:
//                                                          {
//
//                                                              NSDictionary *str     = @{@"result_code":@"1",
//                                                                                        @"shareUrl":weakSelf.shareModel.shareUrl,
//                                                                                        @"longUrl":weakSelf.shareModel.longUrl
//                                                                                        };
//                                                              NSString *JsonStr = [str JSONString];
//                                                              NSString *jsStr   = [NSString stringWithFormat:@"shareCallback('%@')",JsonStr];
//                                                              [self.delegete sendShareState:jsStr];
//                                                              [self.delegete shareResultState:@"1"];
//                                                              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
//                                                                                                                                       message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
//                                                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
//                                                                                                               style:UIAlertActionStyleDefault handler:nil];
//                                                              [alertController addAction:action];
//                                                              [weakSelf.delegete presentViewController:alertController animated:YES completion:nil];
//                                                              break;
//                                                          }
//                                                          case SSDKResponseStateFail:
//                                                          {
//                                                              NSDictionary *str     = @{
//                                                                                        @"result_code":@"-1",
//                                                                                        @"shareUrl":weakSelf.shareModel.shareUrl,
//                                                                                        @"longUrl":weakSelf.shareModel.longUrl
//
//                                                                                        };
//                                                              NSString *JsonStr = [str JSONString];
//                                                              NSString *jsStr   = [NSString stringWithFormat:@"shareCallback('%@')",JsonStr];
//                                                              [self.delegete sendShareState:jsStr];
//                                                              [self.delegete shareResultState:@"-1"];
//
//                                                              if (error.code==105) {
//                                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享失败" message:@"请安装QQ和微信客户端进行分享" preferredStyle:UIAlertControllerStyleAlert];
//                                                                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                                                                  [alertController addAction:action];
//
//                                                                  [weakSelf.delegete presentViewController:alertController animated:YES completion:nil];                               break;
//                                                              }else{
//                                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"分享失败" preferredStyle:UIAlertControllerStyleAlert];
//                                                                  UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                                                                  [alertController addAction:action];
//                                                                  [weakSelf.delegete presentViewController:alertController animated:YES completion:nil];
//                                                              }
//
//                                                              break;
//
//                                                          }
//                                                          case SSDKResponseStateCancel:{
//
//                                                              NSDictionary *str     = @{
//                                                                                        @"result_code":@"2",
//                                                                                        @"shareUrl":weakSelf.shareModel.shareUrl,
//                                                                                        @"longUrl":weakSelf.shareModel.longUrl
//                                                                                        };
//                                                              NSString *JsonStr = [str JSONString];
//                                                              NSString *jsStr   = [NSString stringWithFormat:@"shareCallback('%@')",JsonStr];
//                                                              [self.delegete sendShareState:jsStr];
//                                                              [self.delegete shareResultState:@"2"];
//
//                                                          }
//
//                                                          case SSDKResponseStateBegin:{
//
//                                                              NSLog(@"分享开始");
//
//                                                          }
//                                                          default:
//                                                              break;
//                                                      }
//                                                  }
//                                                  ];
//        //省略微博分享编辑，直接跳转到微博APP
//        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
//    }
//}

#pragma mark 合友圈分享
//- (void)circleOfFriendsShareWithModel:(shareModel *)shareModel{
//    _shareModel = shareModel;
//    [self initShareSDK:@[@(SSDKPlatformTypeWechat)]];
//    [self shareSDKWithUrl:shareModel isCircleOfFriends:YES];
//}
+(NSDictionary*)dict:(NSDictionary *)response {
    NSDictionary *dic = @{
                          @"shareDesc":[[HFUntilTool EmptyCheckobjnil:[response  valueForKey:@"shareDesc"]] description],
                          @"shareImageUrl":[[HFUntilTool EmptyCheckobjnil:[response  valueForKey:@"shareImageUrl"]] description],
                          @"shareTitle":[[HFUntilTool EmptyCheckobjnil:[response valueForKey:@"shareTitle"]] description],
                          @"shareUrl":[[HFUntilTool EmptyCheckobjnil:[response  valueForKey:@"shareUrl"]] description],
                          @"longUrl":@"",
                          @"shareWeixinUrl":[HFUntilTool EmptyCheckobjnil:[response  valueForKey:@"shareImageUrl"]],
                          @"justUrl":@(YES)
                          };
    return dic;
}
+(void)shareWithContent:(id)publishContent/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    isyundian=nil;
    prgramDic=[NSDictionary dictionary];
    prgramDic=publishContent;
    isyundian=[publishContent objectForKey:@"yundian"];
    NSString *shareQRImageUrl=[prgramDic objectForKey:@"shareQRImageUrl"];//h5图片
    NSNumber * boolNum = prgramDic[@"justUrl"];
    BOOL justUrl = [boolNum boolValue];//h5无图片
   UIWindow *window = [ShareTools getWindow];

    for(UIView *v in window.subviews) {
        if(v.tag == 440 ||v.tag == 441){
            [v removeFromSuperview];
        }
    }
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    aTapGR.numberOfTapsRequired = 1;
    [blackView addGestureRecognizer:aTapGR];
    blackView.alpha=0.6;
    blackView.backgroundColor=HEXCOLOR(0X000000);
    blackView.tag = 440;
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 211+KBottomSafeHeight)];
    shareView.backgroundColor =HEXCOLOR(0xFFFFFF);
    shareView.tag = 441;
    [window addSubview:shareView];
    
    NSArray *titles = @[@"链接",@"图片"];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 46)];
    titleView.backgroundColor =HEXCOLOR(0xFFFFFF);
    [shareView addSubview:titleView];
    
    UILabel *Linelable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, ScreenW, 1)];
    Linelable1.backgroundColor=HEXCOLOR(0xEEEEEE);
    [titleView addSubview:Linelable1];
    
    CGFloat buttonW = 36*KWidth_Scale;
    CGFloat buttonH = 15;
    CGFloat buttonY = 16;
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xF3344A) forState:UIControlStateSelected];
        button.tag = 100+i;
        button.titleLabel.font = PFR13Font;
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (ScreenW/2-buttonW-20*KWidth_Scale)+i *(buttonW+40*KWidth_Scale);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [titleView addSubview:button];
        
    }
    UIButton *firstButton = titleView.subviews[1];
    UIButton *secondButton = titleView.subviews[2];
    firstButton.selected=YES;
    _selectBtn=firstButton;
    [self resetParamsType:prgramDic string:@"链接" viewType:@""];
    
    UIView *dicatorView = [[UIView alloc]init];
    _indicatorView=dicatorView;
    _indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    _indicatorView.dc_height = 2;
    _indicatorView.dc_y = titleView.dc_height - _indicatorView.dc_height;
    [firstButton.titleLabel sizeToFit];
    _indicatorView.dc_width = firstButton.titleLabel.dc_width;
    _indicatorView.dc_centerX = firstButton.dc_centerX;
    [titleView addSubview:_indicatorView];
    
    UILabel *textlable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    textlable.text=@"链接";
    textlable.font = PFR17Font;
    textlable.textColor=HEXCOLOR(0x333333);
    textlable.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:textlable];
    textlable.hidden=YES;
    
    if(justUrl)
    {
        
        firstButton.hidden=YES;
        secondButton.hidden=YES;
        _indicatorView.hidden=YES;
        textlable.hidden=NO;
        
    }else
    {
        textlable.hidden=YES;
        firstButton.hidden=NO;
        secondButton.hidden=NO;
        _indicatorView.hidden=NO;
    }
    NSArray *btnImages = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"微博"];
    NSArray *btnTitles = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"新浪微博"];
    for (NSInteger i=0; i<5; i++) {
        CGFloat top = 20.0f;
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame= CGRectMake(23*KWidth_Scale+i*KWidth_Scale*70, titleView.bottom+top, 50*KWidth_Scale, 75*KWidth_Scale);
        //        button.backgroundColor=[UIColor redColor];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        //        top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
        //        left : 为正数的时候往右偏移,为负数的时候往左偏移;
        //        bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
        //        right :为正数的时候往左偏移,为负数的时候往右偏移;
        //        CGSize titleSize = button.titleLabel.bounds.size;
        CGFloat offset = 40.0f;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height-offset/2, 0);
        // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
        // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -button.titleLabel.intrinsicContentSize.width);
        CGSize imageSize = button.imageView.bounds.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, -button.titleLabel.intrinsicContentSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height+10,  -imageSize.width,0, 0);
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
    UILabel *Linelable2=[[UILabel alloc]initWithFrame:CGRectMake(10, shareView.height-50*KWidth_Scale-KBottomSafeHeight, ScreenW-20, 1)];
    Linelable2.backgroundColor=HEXCOLOR(0xEEEEEE);
    [shareView addSubview:Linelable2];
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareView.height-50*KWidth_Scale-KBottomSafeHeight+1, shareView.width, 50*KWidth_Scale)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    cancleBtn.backgroundColor=[UIColor whiteColor];
    cancleBtn.tag = 339;
    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    //    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    blackView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        //        shareView.transform = CGAffineTransformMakeScale(1, 1);
        shareView.frame= CGRectMake(0, ScreenH-211-KBottomSafeHeight, ScreenW, 211+KBottomSafeHeight);
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
    
}

+ (UIWindow *)getWindow{
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//    NSString *version = [UIDevice currentDevice].systemVersion;
     UIWindow* window = nil;
//    if (isyundian) {
//         return [[UIApplication sharedApplication].windows lastObject];
//    }else
//    {
                if (@available(iOS 13.0, *))
                {
                    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
                    {
                        if (windowScene.activationState == UISceneActivationStateForegroundActive)
                        {
                            window = windowScene.windows.firstObject;

                            break;
                        }
                    }
                }else{
                    window = [UIApplication sharedApplication].keyWindow;
                }
        return window;
//    }
   

//    if (version.doubleValue >= 13.0) {
//        // 针对 11.0 以上的iOS系统进行处理
//        return [[UIApplication sharedApplication].windows lastObject];
//    } else {
//        // 针对 11.0 以下的iOS系统进行处理
//        return [UIApplication sharedApplication].keyWindow;
//    }
}

+(void)shareBtnClick:(UIButton *)btn
{
    
    //    NSLog(@"%@",[ShareSDK version]);
    UIWindow *window = [ShareTools getWindow];
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    UIView *_goodsView = [window viewWithTag:66666];

    //为了弹窗不那么生硬，这里加了个简单的动画
    //    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.5f animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShare" object:nil];
        shareView.frame= CGRectMake(0, ScreenH, ScreenW, 211+KBottomSafeHeight);
        blackView.alpha = 0;
        if (_goodsView) {
            [_goodsView removeFromSuperview];
        }
    } completion:^(BOOL finished) {
        [_goodsView removeFromSuperview];
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
        for (UIView *view in window.subviews) {
            if (view.tag == 66666 || view.tag == 440 || view.tag == 441) {
                [view removeFromSuperview];
            }
            
        }
    }];
    if (btn.tag==339) {//取消
        return;
    }
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = SSDKPlatformSubTypeWechatSession;
        }
            break;
            
        case 332:
        {
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        case 333:
        {
            shareType = SSDKPlatformSubTypeQQFriend;
        }
            break;
            
        case 334:
        {
            shareType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        case 335:
        {
            shareType = SSDKPlatformTypeSinaWeibo;
            
        }
            break;
            
            
            
        default:
            break;
    }
    
    if (btn.tag==335) {
         BOOL hasSinaWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://wb22222222"]];
        if (hasSinaWeibo) {
            //    //进行分享
            [ShareSDK share:shareType //传入分享的平台类型
                 parameters:publishContent
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 if (state == SSDKResponseStateSuccess)
                 {
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     // NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                 }
                 else if (state == SSDKResponseStateFail)
                 {
                     if (error.code==105) {
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装相应的客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                         
                     }else{
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     
                     
                 }
             }];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装新浪微博客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else
    {
        //    //进行分享
        [ShareSDK share:shareType //传入分享的平台类型
             parameters:publishContent
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             if (state == SSDKResponseStateSuccess)
             {
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 // NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
             }
             else if (state == SSDKResponseStateFail)
             {
                 if (error.code==105) {
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装相应的客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }else{
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
                 
             }
         }];
    }

 
    
}
#pragma mark - 头部按钮点击
+(void)topBottonClick:(UIButton *)button
{
    if (button.tag==_selectBtn.tag) {
        return;
    }else
    {
        _selectBtn.selected=NO;
        button.selected=YES;
        _selectBtn=button;
    }
    
    if (button.tag <1000) {
  
    if (button.tag ==100) {
        [self resetParamsType:prgramDic string:@"链接" viewType:@""];
    }else
    {
        [self resetParamsType:prgramDic string:@"图片" viewType:@""];
        
    }
        
    } else {
        //详情页
        if (button.tag ==1000) {
            _selectType = @"链接";

            [self resetParamsType:prgramDic string:@"链接" viewType:@"detail"];
        }else
        {
            _selectType = @"图片";

            [self resetParamsType:prgramDic string:@"图片" viewType:@"detail"];
            
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        _indicatorView.dc_width = button.titleLabel.dc_width;
        _indicatorView.dc_centerX = button.dc_centerX;
    }];
    
}

+(void)tapGRAction
{
    UIWindow *window = [ShareTools getWindow];
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    UIView *_goodsView = [window viewWithTag:66666];

    //为了弹窗不那么生硬，这里加了个简单的动画
    [UIView animateWithDuration:0.35f animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShare" object:nil];
        shareView.frame= CGRectMake(0, ScreenH, ScreenW, 211+KBottomSafeHeight);
        blackView.alpha = 0;
        if (_goodsView) {
            [_goodsView removeFromSuperview];
        }
    } completion:^(BOOL finished) {
        [_goodsView removeFromSuperview];
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
        for (UIView *view in window.subviews) {
            if (view.tag == 66666 || view.tag == 440 || view.tag == 441) {
                [view removeFromSuperview];
            }
        }
    }];
}
//viewType 详情页 传 @"detail"
+(void)resetParamsType:(NSDictionary*)dic string:(NSString *)type viewType:(NSString *)viewType
{
    NSString *text=dic[@"shareDesc"];
    NSString *title=dic[@"shareTitle"];
    
    if ([title isEqualToString:@""]||title==nil) {
        title=@"合美惠";
    }
    if ([text isEqualToString:@""]||text==nil) {
        text=title;
    }
    NSString *shareUrl=dic[@"shareUrl"];
    //    shareUrl=[shareUrl stringByReplacingOccurrencesOfString:@"#"withString:@"?#"];
    NSString *shareImageUrl=CHECK_STRING(dic[@"shareImageUrl"]);
    
    NSString *shareQRImageUrl=[dic objectForKey:@"shareQRImageUrl"];//h5图片
    BOOL justUrl=[prgramDic objectForKey:@"justUrl"];//h5无图片
    if (![shareQRImageUrl isKindOfClass:[NSNull class]]&&!justUrl) {
        if (![shareQRImageUrl isEqualToString:@""]&&shareQRImageUrl!=nil) {
            shareImageUrl=shareQRImageUrl;
        }
    }
    shareUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)shareUrl,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    //      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]]];
    //    // ------调用
    //    UIImage *img = [UIImage imageWithData:[self imageWithImage:image scaledToSize:CGSizeMake(300, 300)]];
    
    
    _publishContent = [NSMutableDictionary dictionary];
    if ([type isEqualToString:@"图片"]) {
        
        
        //        [_publishContent SSDKSetupShareParamsByText:@"text"
        //                                         images:img
        //                                            url:[NSURL URLWithString:@""]
        //                                          title:@"title"
        //                                           type:SSDKContentTypeImage];
        
        if ([viewType isEqualToString:@"detail"]) {
            //QQ
            UIWindow *window = [ShareTools getWindow];

            UIView *_goodsView = [window viewWithTag:66666];

            UIImage *img = [ShareTools makeImageWithView:_goodsView withSize:CGSizeMake(ScreenW - WScale(122), WScale(384))];
            
            [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
            //微信朋友圈
            [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
            //微信
            [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
            //空间
            [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQZone];
            //微博
//            [_publishContent SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",title,shareUrl] title:title image:img url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeImage];//[NSURL URLWithString:shareUrl]
            [_publishContent SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",title,shareUrl] title:title images:shareImageUrl video:nil url:[NSURL URLWithString:shareUrl] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeImage];
        } else {
        
        //QQ
        [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        //微信朋友圈
        [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        //微信
        [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        //空间
        [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQZone];
        //微博
        [_publishContent SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",title,shareUrl] title:title images:shareImageUrl video:nil url:[NSURL URLWithString:shareUrl] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeImage];
        }
    }else
    {
    if ([viewType isEqualToString:@"detail"]) {
                 UIWindow *window = [ShareTools getWindow];

                 UIView *_goodsView = [window viewWithTag:66666];

        id img;
        if (shareImageUrl.length == 0) {
            img = [UIImage imageNamed:@"icon_hflogo"];
        } else {
            img = [shareImageUrl get_Image];
        }
      
        //QQ
        [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        //微信朋友圈
        [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        //微信
                 [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        //空间
        [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:img type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
        //微博

        [_publishContent SSDKSetupSinaWeiboShareParamsByText:text title:title images:shareImageUrl video:nil url:[NSURL URLWithString:shareUrl] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeWebPage];
             } else {
                 
                 //QQ
                 [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                 //微信朋友圈
                 [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                 //微信
                 [_publishContent SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:shareUrl] thumbImage:nil image:shareImageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                 //空间
                 [_publishContent SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:shareUrl] audioFlashURL:nil videoFlashURL:nil thumbImage:nil images:shareImageUrl type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
                 //微博
                 [_publishContent SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",title,shareUrl] title:title images:shareImageUrl video:nil url:[NSURL URLWithString:shareUrl] latitude:0 longitude:0 objectID:nil isShareToStory:NO type:SSDKContentTypeWebPage];
                 
                 
             }

    }
    
}
//将图片压缩到100k以下
+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}
// ------这种方法对图片既进行压缩，又进行裁剪
+(NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}
-(UIViewController*)theTopViewController
{
    return [self topViewControllerWithRootViewController:[ShareTools getWindow].rootViewController];
}
-(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController* tabBarController=(UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {         UINavigationController* navigationController = (UINavigationController*)rootViewController;         return [self topViewControllerWithRootViewController:navigationController.visibleViewController];    } else if (rootViewController.presentedViewController)
     {
        UIViewController* presentedViewController = rootViewController.presentedViewController;         return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        return rootViewController;
        
    }}





/**************************** 详情 ****************************/
//view转成image
+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
//详情分享
+(void)goodDetailShareWithContent:(id)publishContent detailModel:(GoodsDetailModel *) detailModel;
/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    
    prgramDic=[NSDictionary dictionary];
    prgramDic=publishContent;
    NSString *shareQRImageUrl=[prgramDic objectForKey:@"shareQRImageUrl"];//h5图片
    NSNumber * boolNum = prgramDic[@"justUrl"];
    BOOL justUrl = [boolNum boolValue];//h5无图片
    
    UIWindow *window =[ShareTools getWindow];
    for(UIView *v in window.subviews) {
        if(v.tag == 440 ||v.tag == 441){
            [v removeFromSuperview];
        }
    }
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    aTapGR.numberOfTapsRequired = 1;
    [blackView addGestureRecognizer:aTapGR];
    blackView.alpha=0.6;
    blackView.backgroundColor=HEXCOLOR(0X000000);
    blackView.tag = 440;
    [window addSubview:blackView];
    
    
    
    UIView * _goodsView = [[UIView alloc] init];
    _goodsView.backgroundColor = [UIColor whiteColor];
    _goodsView.layer.cornerRadius = 10;
    _goodsView.layer.masksToBounds = YES;
    _goodsView.tag = 66666;
    [window addSubview:_goodsView];
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        if(KIsiPhoneX){
            make.top.equalTo(window).offset(WScale(120));

        } else {
            make.top.equalTo(window).offset(WScale(40));

        }
        
        make.left.equalTo(window).offset(WScale(60));
        make.right.equalTo(window).offset(-WScale(60));
        make.height.mas_equalTo(WScale(384));
    }];
    NSString *imgUrl = [ShareTools productUrlOfGoodsDetailModel:detailModel];
    
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    [_goodsView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsView);
        make.right.equalTo(_goodsView);
        make.top.equalTo(_goodsView);
        make.height.mas_equalTo(WScale(255));
    }];
    
    
    UIImageView * imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hflogo"]];
    [_goodsView addSubview:imgLogo];
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodsView).offset(WScale(15));
        make.top.equalTo(_goodsView).offset(WScale(15));
        make.size.mas_equalTo(CGSizeMake(WScale(39), WScale(39)));
        
    }];
    
    
    UIImageView * imgCode = [[UIImageView alloc] initWithImage:[QRCodeImage getQrImageWithBarcode:[prgramDic objectForKey:@"shareUrl"] Size:WScale(80)]];
    [_goodsView addSubview:imgCode];
    [imgCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_goodsView).offset(-WScale(15));
        make.top.equalTo(imgView.mas_bottom).offset(WScale(15));
        make.size.mas_equalTo(CGSizeMake(WScale(80), WScale(80)));
    }];
    
    UILabel * scanCode = [[UILabel alloc] init];
    scanCode.textAlignment = NSTextAlignmentLeft;
    scanCode.font = [UIFont systemFontOfSize:WScale(10)];
    scanCode.textColor = HEXCOLOR(0x666666);
    scanCode.text = @"-扫描二维码-";
    [_goodsView addSubview:scanCode];
    [scanCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgCode);
        make.bottom.equalTo(_goodsView.mas_bottom).offset(-WScale(15));
        make.height.mas_equalTo(WScale(10));
    }];
    
    
    UILabel * title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:WScale(11)];
    title.numberOfLines = 2;
    title.textColor = HEXCOLOR(0x333333);
    title.text = CHECK_STRING(detailModel.data.product.title);
    [_goodsView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(WScale(15));
        make.left.equalTo(_goodsView).offset(WScale(15));
        make.right.equalTo(imgCode.mas_left).offset(WScale(-15));
    }];
    
    
    UILabel * subtitle = [[UILabel alloc] init];
    subtitle.textAlignment = NSTextAlignmentLeft;
    subtitle.font = [UIFont systemFontOfSize:WScale(10)];
    subtitle.numberOfLines = 2;
    subtitle.textColor = HEXCOLOR(0x666666);
    subtitle.text = CHECK_STRING(detailModel.data.product.productSubtitle);
    [_goodsView addSubview:subtitle];
    [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(WScale(5));
        make.left.equalTo(_goodsView).offset(WScale(15));
        make.right.equalTo(imgCode.mas_left).offset(WScale(-15));
    }];
    
    
    UILabel * moneyLabel = [[UILabel alloc] init];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.font = [UIFont boldSystemFontOfSize:WScale(22)];
    moneyLabel.textColor = HEXCOLOR(0xF3344A);
    [_goodsView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_goodsView.mas_bottom).offset(-WScale(30));
        make.left.equalTo(_goodsView).offset(WScale(15));
    }];
    
    moneyLabel.attributedText =  [ShareTools moneyLabelForText:[NSString stringWithFormat:@"%.2f",detailModel.data.product.price]];
    
    UILabel * oldMoney = [[UILabel alloc] init];
    oldMoney.textAlignment = NSTextAlignmentLeft;
    oldMoney.font = [UIFont systemFontOfSize:WScale(10)];
    oldMoney.textColor = HEXCOLOR(0x999999);
    [_goodsView addSubview:oldMoney];
    [oldMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(WScale(5));
        make.left.equalTo(moneyLabel);
        make.height.mas_equalTo(WScale(10));
    }];
    
    NSString *strMoney = [self stringChangeMoneyWithStr:[NSString stringWithFormat:@"%.2f", detailModel.data.product.intrinsicPrice] numberStyle:NSNumberFormatterCurrencyStyle];
       NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价： %@",strMoney]];
       [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(3, newPrice.length - 3)];
       oldMoney.attributedText = newPrice;
       
    

    if(detailModel.data.product.intrinsicPrice == detailModel.data.product.price){
        oldMoney.hidden = YES;
    } else {
        oldMoney.hidden = NO;
    }
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 211+KBottomSafeHeight)];
    shareView.backgroundColor =HEXCOLOR(0xFFFFFF);
    shareView.tag = 441;
    [window addSubview:shareView];
    
    NSArray *titles = @[@"链接",@"图片"];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 46)];
    titleView.backgroundColor =HEXCOLOR(0xFFFFFF);
    [shareView addSubview:titleView];
    
    UILabel *Linelable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 45, ScreenW, 1)];
    Linelable1.backgroundColor=HEXCOLOR(0xEEEEEE);
    [titleView addSubview:Linelable1];
    
    CGFloat buttonW = 36*KWidth_Scale;
    CGFloat buttonH = 15;
    CGFloat buttonY = 16;
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:0];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0xF3344A) forState:UIControlStateSelected];
        button.tag = 1000+i;
        button.titleLabel.font = PFR13Font;
        [button addTarget:self action:@selector(topBottonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (ScreenW/2-buttonW-20*KWidth_Scale)+i *(buttonW+40*KWidth_Scale);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [titleView addSubview:button];
        
    }
    UIButton *firstButton = titleView.subviews[1];
    UIButton *secondButton = titleView.subviews[2];
    firstButton.selected=YES;
    _selectBtn=firstButton;
    _selectType = @"链接";
    [self resetParamsType:prgramDic string:@"链接" viewType:@"detail"];
    UIView *dicatorView = [[UIView alloc]init];
    _indicatorView=dicatorView;
    _indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    _indicatorView.dc_height = 2;
    _indicatorView.dc_y = titleView.dc_height - _indicatorView.dc_height;
    [firstButton.titleLabel sizeToFit];
    _indicatorView.dc_width = firstButton.titleLabel.dc_width;
    _indicatorView.dc_centerX = firstButton.dc_centerX;
    [titleView addSubview:_indicatorView];
    
    UILabel *textlable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    textlable.text=@"链接";
    textlable.font = PFR17Font;
    textlable.textColor=HEXCOLOR(0x333333);
    textlable.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:textlable];
    textlable.hidden=YES;
    
    if(justUrl)
    {
        
        firstButton.hidden=YES;
        secondButton.hidden=YES;
        _indicatorView.hidden=YES;
        textlable.hidden=NO;
        
    }else
    {
        textlable.hidden=YES;
        firstButton.hidden=NO;
        secondButton.hidden=NO;
        _indicatorView.hidden=NO;
    }
    NSArray *btnImages = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"微博"];
    NSArray *btnTitles = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"新浪微博"];
    for (NSInteger i=0; i<5; i++) {
        CGFloat top = 20.0f;
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame= CGRectMake(23*KWidth_Scale+i*KWidth_Scale*70, titleView.bottom+top, 50*KWidth_Scale, 75*KWidth_Scale);
        //        button.backgroundColor=[UIColor redColor];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        //        top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
        //        left : 为正数的时候往右偏移,为负数的时候往左偏移;
        //        bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
        //        right :为正数的时候往左偏移,为负数的时候往右偏移;
        //        CGSize titleSize = button.titleLabel.bounds.size;
        CGFloat offset = 40.0f;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height-offset/2, 0);
        // button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.frame.size.height-offset/2, 0, 0, -button.titleLabel.frame.size.width);
        // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -button.titleLabel.intrinsicContentSize.width);
        CGSize imageSize = button.imageView.bounds.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, -button.titleLabel.intrinsicContentSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height+10,  -imageSize.width,0, 0);
        button.tag = 331+i;
        [button addTarget:self action:@selector(goodDetailShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
    UILabel *Linelable2=[[UILabel alloc]initWithFrame:CGRectMake(10, shareView.height-50*KWidth_Scale-KBottomSafeHeight, ScreenW-20, 1)];
    Linelable2.backgroundColor=HEXCOLOR(0xEEEEEE);
    [shareView addSubview:Linelable2];
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareView.height-50*KWidth_Scale-KBottomSafeHeight+1, shareView.width, 50*KWidth_Scale)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    cancleBtn.backgroundColor=[UIColor whiteColor];
    cancleBtn.tag = 339;
    [cancleBtn addTarget:self action:@selector(goodDetailShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    //    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
    blackView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        //        shareView.transform = CGAffineTransformMakeScale(1, 1);
        shareView.frame= CGRectMake(0, ScreenH-211-KBottomSafeHeight, ScreenW, 211+KBottomSafeHeight);
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
    
}



+ (NSMutableAttributedString *)moneyLabelForText:(NSString *)money{
    float floatMoney = [money floatValue];
    floatMoney = floatMoney ?: 0.00;
    NSString *strMoney = [self stringChangeMoneyWithStr:[NSString stringWithFormat:@"%.2f",floatMoney] numberStyle:NSNumberFormatterCurrencyStyle] ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WScale(14)] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WScale(14)] range:NSMakeRange(strMoney.length - 2, 2)];
    return str;
}
/**
 * 金额的格式转化
 * str : 金额的字符串
 * numberStyle : 金额转换的格式
 * return  NSString : 转化后的金额格式字符串
 */
+ (NSString *)stringChangeMoneyWithStr:(NSString *)str numberStyle:(NSNumberFormatterStyle)numberStyle {
    
    // 判断是否null 若是赋值为0 防止崩溃
    if (([str isEqual:[NSNull null]] || str == nil)) {
        str = 0;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = numberStyle;
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]];
    
    return money;
}
+ (NSString *)productUrlOfGoodsDetailModel:(GoodsDetailModel*)goodsDetailModel{
    NSString *productUrl = @"";
    if (goodsDetailModel.data.product.productPics.count>0) {
        ProductPicsItem *PicsItem= [goodsDetailModel.data.product.productPics objectAtIndex:0];
        productUrl = [PicsItem.address get_sharImage];
    }
    return productUrl;
    
}
+(void)goodDetailShareBtnClick:(UIButton *)btn
{
    [self resetParamsType:prgramDic string:_selectType viewType:@"detail"];
    //    NSLog(@"%@",[ShareSDK version]);
    UIWindow *window = [ShareTools getWindow];
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    UIView *_goodsView = [window viewWithTag:66666];
    //为了弹窗不那么生硬，这里加了个简单的动画
    //    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.5f animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShare" object:nil];
        shareView.frame= CGRectMake(0, ScreenH, ScreenW, 211+KBottomSafeHeight);
        blackView.alpha = 0;
        if (_goodsView) {
            [_goodsView removeFromSuperview];
        }
    } completion:^(BOOL finished) {
        [_goodsView removeFromSuperview];
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
        for (UIView *view in window.subviews) {
            if (view.tag == 66666 || view.tag == 440 || view.tag == 441) {
                [view removeFromSuperview];
            }
            
        }
    }];
    if (btn.tag==339) {//取消
        return;
    }
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = SSDKPlatformSubTypeWechatSession;
        }
            break;
            
        case 332:
        {
            shareType = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        case 333:
        {
            shareType = SSDKPlatformSubTypeQQFriend;
        }
            break;
            
        case 334:
        {
            shareType = SSDKPlatformSubTypeQZone;
        }
            break;
            
        case 335:
        {
            shareType = SSDKPlatformTypeSinaWeibo;
            
        }
            break;
            
            
            
        default:
            break;
    }
    
    if (btn.tag==335) {
        BOOL hasSinaWeibo = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibosso://wb22222222"]];
        if (hasSinaWeibo) {
            //    //进行分享
            [ShareSDK share:shareType //传入分享的平台类型
                 parameters:publishContent
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 if (state == SSDKResponseStateSuccess)
                 {
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     // NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                 }
                 else if (state == SSDKResponseStateFail)
                 {
                     if (error.code==105) {
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装相应的客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                         
                     }else{
                         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     
                     
                 }
             }];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装新浪微博客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else
    {
        //    //进行分享
        [ShareSDK share:shareType //传入分享的平台类型
             parameters:publishContent
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             if (state == SSDKResponseStateSuccess)
             {
                 UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
                 // NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
             }
             else if (state == SSDKResponseStateFail)
             {
                 if (error.code==105) {
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请安装相应的客户端进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }else{
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分享失败" message:@"请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
                 
             }
         }];
    }
    
    
    
}
@end
