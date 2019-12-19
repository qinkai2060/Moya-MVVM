//
//  ResetSecondaryPasswordViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ResetSecondaryPasswordViewController.h"
#import "ResetSecondaryPasswordView.h"

@interface ResetSecondaryPasswordViewController ()
@property (nonatomic, strong) ResetSecondaryPasswordView *resetSecondaryPasswordView;
@end

@implementation ResetSecondaryPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.title =   self.ntitle ? self.ntitle : @"二级密码重置";
    [self.view addSubview:self.resetSecondaryPasswordView];
}
- (ResetSecondaryPasswordView *)resetSecondaryPasswordView{
    if (!_resetSecondaryPasswordView) {
        _resetSecondaryPasswordView = [[ResetSecondaryPasswordView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122)];
        WEAKSELF
        _resetSecondaryPasswordView.block = ^{
            [weakSelf requestResetSecondaryPassword];
        };
    }
    return _resetSecondaryPasswordView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNavigation) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:(UIBarMetricsDefault)];
        self.navigationController.navigationBar.shadowImage = nil;
    }
    
}
- (void)leftBarButtonItemAction{
    if (self.isNavigation) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/**
 二级密码重置
 */
- (void)requestResetSecondaryPassword{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"phone":USERDEFAULT(@"mobilephone"),
                          @"newPwd":objectOrEmptyStr(_resetSecondaryPasswordView.textfNewSerceCode.text),
                          @"checkCode":objectOrEmptyStr(_resetSecondaryPasswordView.textfVerificationCode.text)
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/broker/backtwo"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        
        [self showSVProgressHUDSuccessWithStatus:@""];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseString);
        if (CHECK_STRING_ISNULL(request.responseString)) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        NSInteger response = [request.responseString integerValue];
        switch (response) {
            case 0:
            {
                [self showSVProgressHUDSuccessWithStatus:@"二级密码重置成功!"];
                [NSThread sleepForTimeInterval:1];
                [self leftBarButtonItemAction];
            }
                break;
            case 1:
            {
                [self showSVProgressHUDErrorWithStatus:@"修改失败!"];
                
            }
                break;
            case 501:
            {
                [self showSVProgressHUDErrorWithStatus:@"手机号不正确!"];
            }
                break;
            case 502:
            {
                [self showSVProgressHUDErrorWithStatus:@"手机号不存在!"];
            }
                break;
            case 503:
            {
                [self showSVProgressHUDErrorWithStatus:@"验证码不正确!"];
            }
                break;
            case 504:
            {
                [self showSVProgressHUDErrorWithStatus:@"超过发送次数!"];
            }
                break;
                
            default:
                [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
                break;
        }
    }];
}

@end
