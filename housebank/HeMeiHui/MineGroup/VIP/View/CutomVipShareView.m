//
//  CutomVipShareView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CutomVipShareView.h"
#import "UIButton+CustomButton.h"
#import "ShareTools.h"
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>


@interface CutomVipShareView()
{
    UIView *bgViewt;
    UIView *view;
}
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *leftMoney;
@property (nonatomic, strong) UILabel *rightMoney;
@property (nonatomic, strong) GoodsDetailModel *goodsDetailModel;
@property (nonatomic, assign) float addMoney;
@end

@implementation CutomVipShareView

+(instancetype)CutomVipShareViewIn:(UIView *)view addMoney:(float)addMoney goodsDetailModel:(GoodsDetailModel *)goodsDetailModel wxblock:(void(^)())wxblock pyqblock:(void(^)())pyqblock closeblock:(void(^)())closeblock{
    CutomVipShareView *cus = [[CutomVipShareView alloc] initWithFrame:view.bounds];
    cus.addMoney = addMoney;
    cus.goodsDetailModel = goodsDetailModel;
    cus.wxblock = wxblock;
    cus.pyqblock = pyqblock;
    cus.closeblock = closeblock;
    [view addSubview:cus];
    return cus;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    bgViewt = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, self.width, self.height)];
    bgViewt.backgroundColor = [UIColor clearColor];
    [self addSubview:bgViewt];
    
    UIView *tap = [[UIView alloc] init];
    [bgViewt addSubview:tap];
    [tap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgViewt);
    }];
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [bgViewt addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgViewt).offset(-WScale(179));
        make.left.equalTo(bgViewt).offset(WScale(25));
        make.right.equalTo(bgViewt).offset(-WScale(25));
        make.height.mas_equalTo(WScale(415));
    }];
    
    
    self.title = [[UILabel alloc] init];
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.font = [UIFont systemFontOfSize:WScale(16)];
    self.title.numberOfLines = 2;
    self.title.textColor = HEXCOLOR(0x333333);
    self.title.text = @"置分享设置分享设置分享设置";
    self.title.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(WScale(15));
        make.left.equalTo(view).offset(WScale(20));
        make.right.equalTo(view).offset(WScale(-20));
        make.height.mas_equalTo(WScale(50));
    }];
    
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    [view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(WScale(20));
        make.right.equalTo(view).offset(WScale(-20));
        make.top.equalTo(self.title.mas_bottom).offset(WScale(15));
        make.bottom.equalTo(view).offset(WScale(-50));
        
    }];
    
    self.leftMoney = [[UILabel alloc] init];
    self.leftMoney.textAlignment = NSTextAlignmentLeft;
    self.leftMoney.font = [UIFont boldSystemFontOfSize:WScale(24)];
    self.leftMoney.textColor = HEXCOLOR(0xF3344A);
//    self.leftMoney.text = @"¥3000.00";
    self.leftMoney.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.leftMoney];
    [self.leftMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.title);
        make.height.mas_equalTo(WScale(50));
    }];
    
    
    self.rightMoney = [[UILabel alloc] init];
    self.rightMoney.textAlignment = NSTextAlignmentLeft;
    self.rightMoney.font = [UIFont systemFontOfSize:WScale(12)];
    self.rightMoney.textColor = HEXCOLOR(0x999999);
    self.rightMoney.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.rightMoney];
    [self.rightMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(WScale(20));
        make.left.equalTo(self.leftMoney.mas_right).offset(WScale(10));
        make.height.mas_equalTo(WScale(15));
    }];
  
    

    
    UIButton *btnWX = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnWX setTitle:@"微信" forState:(UIControlStateNormal)];
    btnWX.tag = 100;
    btnWX.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnWX setImage:[UIImage imageNamed:@"icon_vip_wx"] forState:(UIControlStateNormal)];
    [btnWX setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [btnWX addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgViewt addSubview:btnWX];
    [btnWX mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(view.mas_bottom).offset(WScale(25));
        make.left.equalTo(bgViewt).offset(WScale(100));
        make.width.mas_equalTo(WScale(60));
        make.height.mas_equalTo(WScale(75));
    }];
  
    [self layoutIfNeeded];
    
    [btnWX layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleTop) imageTitleSpace:10];
    
    UIButton *btnPYQ = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnPYQ setTitle:@"朋友圈" forState:(UIControlStateNormal)];
    btnPYQ.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnPYQ setImage:[UIImage imageNamed:@"icon_vip_pyq"] forState:(UIControlStateNormal)];
    [btnPYQ setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btnPYQ.tag = 200;
    [btnPYQ addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgViewt addSubview:btnPYQ];
    [btnPYQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(WScale(25));
        make.right.equalTo(bgViewt).offset(-WScale(100));
        make.width.mas_equalTo(WScale(60));
        make.height.mas_equalTo(WScale(75));
    }];
    
    [self layoutIfNeeded];
    
    [btnWX layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleTop) imageTitleSpace:10];
    
    [btnPYQ layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyleTop) imageTitleSpace:10];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
    [tap addGestureRecognizer:tap1];
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = self.bounds;
    }];

}
- (void)setGoodsDetailModel:(GoodsDetailModel *)goodsDetailModel{
    _goodsDetailModel = goodsDetailModel;
    
    [self moneyLabelForText:[NSString stringWithFormat:@"%.2f", (self.addMoney + _goodsDetailModel.data.product.price)]];
    NSDictionary*attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString*attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"市场价¥%.2f",_goodsDetailModel.data.product.intrinsicPrice] attributes:attribtDic];
    self.rightMoney.attributedText= attribtStr;
    self.title.text = _goodsDetailModel.data.product.title;
    if (_goodsDetailModel.data.product.productPics.count >0) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[self productUrl]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }
    
}
- (NSString *)productUrl{
    NSString *productUrl = @"";
    if (self.goodsDetailModel.data.product.productPics.count>0) {
            ProductPicsItem *PicsItem= [self.goodsDetailModel.data.product.productPics objectAtIndex:0];
        productUrl = [PicsItem.address get_sharImage];
    }
  return productUrl;

}
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
- (void)touchAction{
    if (self.closeblock) {
        self.closeblock();
    }
    [self removeViewAnimate];
    
}
- (void)removeViewAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        bgViewt.frame = CGRectMake(0, ScreenH, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)btnAction:(UIButton *)btn{
    UIImage *frontcard = [self makeImageWithView:view withSize:CGSizeMake(ScreenW - WScale(50), WScale(415))];
    if (btn.tag == 100) {
        //微信
        if (self.wxblock) {
            self.wxblock();
        }
        
        [self share:SSDKPlatformSubTypeWechatSession image:frontcard];
    } else {
        //朋友圈
        if (self.pyqblock) {
            self.pyqblock();
        }
        [self share:SSDKPlatformSubTypeWechatTimeline image:frontcard];
    }
}
- (void)share:(SSDKPlatformType)shareType image:(UIImage *)image{
    //    //进行分享
    NSMutableDictionary *publishContent = [NSMutableDictionary dictionary];
    //    [publishContent SSDKSetupWeChatParamsByText:nil title:nil url:nil thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeImage forPlatformSubType:shareType];
    [publishContent SSDKSetupWeChatParamsByText:nil title:nil url:nil thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeImage forPlatformSubType:shareType];
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
- (void)moneyLabelForText:(NSString *)money{
    float floatMoney = [money floatValue];
    floatMoney = floatMoney ?: 0.00;
    NSString *strMoney = [NSString stringWithFormat:@"¥%.2f",floatMoney];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMoney];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
     [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(strMoney.length - 2, 2)];
    self.leftMoney.attributedText = str;
    
}
@end
