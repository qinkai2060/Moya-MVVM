//
//  MyQrcodeViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/26.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "MyQrcodeViewController.h"
#import "QRCodeImage.h"
#define FitiPhone6Scale(x) ((x) * ScreenW / 375.0f)


@interface MyQrcodeViewController ()
{
    UIImageView *imgQrcode;
    UIImageView *imgDefaul;
    UIImageView *imgBg;
    UIView *bgView;
}
@end

@implementation MyQrcodeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self requestqueryCreateCode];
}
#define iphone7p (ScreenW == 414)
#define iphone7 (ScreenW == 375)
#define iphone5s (ScreenW == 320)
- (void)createView{
    self.title = self.ntitle ?: @"我的二维码";
    
    imgBg = [[UIImageView alloc] init];
    //            imgBg.image = [UIImage imageNamed:@"icon_idcard"];
    [self.view addSubview:imgBg];
    [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.equalTo(self.view).offset(-2);
        make.right.equalTo(self.view).offset(2);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
    }];
    
    bgView = [[UIView alloc] init];
    bgView.hidden = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(FitiPhone6Scale(95), FitiPhone6Scale(95)));
           if (KIsiPhoneX) {
               make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(425));
           } else if (iphone7p){
               make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(350));
               
           } else if (iphone7){
               make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(350));
               
           } else {
               make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(340));
           }
           make.centerX.equalTo(self.view);
       }];
    
    imgQrcode = [[UIImageView alloc] init];
    [self.view addSubview:imgQrcode];
    [imgQrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(FitiPhone6Scale(92), FitiPhone6Scale(92)));
//        if (KIsiPhoneX) {
//            make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(425));
//        } else if (iphone7p){
//            make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(350));
//
//        } else if (iphone7){
//            make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(350));
//
//        } else {
//            make.top.mas_equalTo(self.view).offset(FitiPhone6Scale(340));
//        }
        make.center.equalTo(bgView);
    }];
    
    
    imgDefaul = [[UIImageView alloc] init];
    imgDefaul.backgroundColor = [UIColor whiteColor];
    imgDefaul.layer.borderWidth = 0.5;
    imgDefaul.layer.borderColor = [UIColor whiteColor].CGColor;
    imgDefaul.hidden = NO;
    [self.view addSubview:imgDefaul];
    [imgDefaul mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imgQrcode);
        make.size.mas_equalTo(CGSizeMake(FitiPhone6Scale(25), FitiPhone6Scale(25)));
    }];
}

- (void)requestqueryCreateCode{
    [SVProgressHUD show];
    
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./index/shareQrImage"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseObject);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[request.responseObject objectForKey:@"data"]];
        if (!CHECK_STRING_ISNULL([dic objectForKey:@"bgUrl"]) && !CHECK_STRING_ISNULL([dic objectForKey:@"qrMsg"])) {
            [imgBg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bgUrl"]]];
            imgQrcode.image = [QRCodeImage getQrImageWithBarcode:[NSString stringWithFormat:@"%@%@",fyMainHomeUrl, [dic objectForKey:@"qrMsg"]] Size:100.0f];
            [imgDefaul sd_setImageWithURL:[self.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"defualt_user"]];

            imgDefaul.hidden = NO;
            bgView.hidden = NO;

            
        } else {
            imgDefaul.hidden = YES;
            bgView.hidden = YES;

            
        }
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        //        imgQrcode.image = [QRCodeImage getQrImageWithBarcode:[NSString stringWithFormat:@"%@/html/register.html?tuiId=%@&flag=1",fyMainHomeUrl, USERDEFAULT(@"uid")] Size:100.0f];
        //        imgBg.image = [UIImage imageNamed:@"icon_idcard"];
        //        imgDefaul.hidden = NO;
        imgDefaul.hidden = YES;
        bgView.hidden = YES;

        
    }];
}

@end
