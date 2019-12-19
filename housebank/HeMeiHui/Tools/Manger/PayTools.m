//
//  PayTools.m
//  HeMeiHui
//
//  Created by 任为 on 2016/12/28.
//  Copyright © 2016年 hefa. All rights reserved.
//


#import "PayTools.h"
#import "WXPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SPayClient.h"


extern BOOL isBeecloundPay;

@implementation PayTools

-(void)doPayWith:(id)body{
    NSDictionary *dic = (NSDictionary*)body;
    _optional = dic[@"optional"];
    NSString *channel     = dic[@"payChannel"];
    NSString *payPlatform = dic[@"payPlatform"];
    NSString *token_id     = dic[@"token_id"];
    NSString *appid     = dic[@"appid"];

       if (_model) {
        _model=nil;
       }
      if([payPlatform isEqualToString:@"P_PLATFORM_SWIFTPASS"]){//BeeClound 微信
           isBeecloundPay = YES;
           NSDictionary *dic = (NSDictionary*)body;
           _optional = dic[@"optional"];
           if (_model) {
               _model=nil;
           }
          _model = [self setModelWith:dic];
           if (dic) {
               NSDictionary *modeDic = dic[@"payChannelConfig"];
               if (modeDic) {
                   self.appIdmodel = [[appIDModel alloc]init];
                   [self.appIdmodel setValuesForKeysWithDictionary:modeDic];
                   
               }
               
           }
     //     [self initBeeClound];//初始化支付渠道
           if ([channel isEqualToString:@"WX_APP"]) {
               if ([WXApi isWXAppInstalled]) {
                   
                //[self doPay:PayChannelWxApp withModel:_model];
                //配置微信APP支付
                   [[SPayClient sharedInstance]pay:nil amount:[NSNumber numberWithFloat:0.01] spayTokenIDString:token_id payServicesString:@"pay.weixin.app" finish:^(SPayClientPayStateModel *payStateModel, SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                       NSLog(@"%@",paySuccessDetailModel);
                   }];
                   
               }else{
                   UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未安装或安装的微信版本不支持支付" delegate:self.delegete cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                   [alter show];
               }
               
           }else if([channel isEqualToString:@"ALI_APP"]) {
               
               [self doPay:PayChannelAli  withModel:_model];
               
           }
           [BeeCloud setBeeCloudDelegate:self.delegete];
           
      }else if ([payPlatform isEqualToString:@"P_PLATFORM_WECHAT"]&&[channel isEqualToString:@"WX"]) {//原生微信
        isBeecloundPay  = NO;
        [WXApi registerApp:appid];
//          [WXApi registerApp:appid universalLink:nil];
        PayReq* req             = [[PayReq alloc] init];
        WXPayModel *wxModel     = [[WXPayModel alloc]init];
        [wxModel setValuesForKeysWithDictionary:dic];
        req.partnerId           = [dic objectForKey:@"partnerid"]?:@"";
        req.prepayId            =  [HFUntilTool EmptyCheckobjnil:[dic objectForKey:@"prepayid"]];
        req.nonceStr            = [dic objectForKey:@"noncestr"]?:@"";
        req.timeStamp           = wxModel.timestamp;
        req.package             = [dic objectForKey:@"package"]?:@"";
        req.sign                = [dic objectForKey:@"sign"]?:@"";
          if ([WXApi isWXAppInstalled]) {
              
              [WXApi sendReq:req];
//              [WXApi sendReq:req completion:nil];

          }else{
              UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未安装或安装的微信版本不支持支付" delegate:self.delegete cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
              [alter show];
          }
          
    }else if([payPlatform isEqualToString:@"P_PLATFORM_ALI"]&&[channel isEqualToString:@"ALI"]){//原生支付宝
        if (dic) {

            [self aliPay:dic];
            
        }
    }

}
//AliPay  原生
- (void)aliPay:(NSDictionary*)dic{
   
    NSString *signedString = dic[@"orderInfo"];
    if (signedString != nil) {
        NSString *appScheme = @"com.fybanks.HeMeiHui";
//        NSString *appScheme = @"HeMeiHui";
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

- (BeeModel*)setModelWith:(NSDictionary*)dic
{
    BeeModel *mode = [[BeeModel alloc]init];
    mode.billno  = dic[@"billno"];
    mode.payType = dic[@"payType"];
    mode.title   = dic[@"title"];
    mode.totalfee= dic[@"totalfee"];
    return mode;
}
//微信、支付宝、银联、百度钱包
- (void)doPay:(PayChannel)channel withModel:(BeeModel*)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_optional];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel; //支付渠道
    payReq.title = model.title; //订单标题
    payReq.totalFee = [NSString stringWithFormat:@"%@",model.totalfee]; //订单价格
    payReq.billNo = model.billno; //商户自定义订单号
    if (channel == PayChannelWxApp) {
        payReq.scheme = @"weixinpay";
    }else if(channel == PayChannelAliApp){
    
        payReq.scheme = @"AliPay";
    
    }
     //URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300; //订单超时时间
    payReq.cardType = 0; // 0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；默认为0
    payReq.viewController = (UIViewController*)self.delegete; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

- (void)initBeeClound
{
//    NSString *appidTest =@"24c127dd-2df5-4651-936b-02f41fa8441d";
//    NSString *appid =@"09f68b95-f13e-407b-bf1c-b3057b347403";
//     NSString *seTest = @"49a18c6a-0b9f-4fce-8677-8a3bf0c3af86";
//    NSString *se = @"3d2bbd86-9ca3-4375-acbb-141a3e795774";
//    if (self.appIdmodel.appId&&self.appIdmodel.appSecret) {
//
//        [BeeCloud initWithAppID:[NSString stringWithFormat:@"%@",self.appIdmodel.appId] andAppSecret:[NSString stringWithFormat:@"%@",self.appIdmodel.appSecret]];
//
//    }else {
//
//        [BeeCloud initWithAppID:appid andAppSecret:se];
//
//    }
//    if (self.model.weChatAppId) {
//
//        [BeeCloud initBCWXPay:self.appIdmodel.weChatAppId];
//
//    }else {
//        //初始化BeeClound 微信支付
//        [BeeCloud initBCWXPay:@"wxd8dc569956f97147"];
//
//    }
    
//    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
//    wechatConfigModel.appScheme = @"wxd3a1cdf74d0c41b3";
//    wechatConfigModel.wechatAppid = @"wxd3a1cdf74d0c41b3";
//    wechatConfigModel.isEnableMTA =YES;
//    
//    //配置微信APP支付
//    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
    
  //  [[SPayClient sharedInstance] application:application
          //     didFinishLaunchingWithOptions:launchOptions];
    
}

@end
