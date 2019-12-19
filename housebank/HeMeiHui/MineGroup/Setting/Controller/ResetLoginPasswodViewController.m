//
//  ResetLoginPasswodViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ResetLoginPasswodViewController.h"
#import "ResetLoginPasswodView.h"



@interface ResetLoginPasswodViewController ()
@property (nonatomic, strong) ResetLoginPasswodView *resetLoginPasswodView;
@end

@implementation ResetLoginPasswodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.title = self.ntitle;
    [self.view addSubview:self.resetLoginPasswodView];
}

/**
 修改登陆密码
 */
- (void)requestResetLogin{
    [SVProgressHUD show];
    NSString *sid = self.sid ?: (USERDEFAULT(@"sid") ?: @"");
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"password":_resetLoginPasswodView.textfNew.text,
                          @"oldPassword":_resetLoginPasswodView.textfOriginal.text
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/upassword"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        
        [self showSVProgressHUDSuccessWithStatus:@""];
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseString);
        NSInteger response = [request.responseString integerValue];
        if (CHECK_STRING_ISNULL(request.responseString)) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        switch (response) {
            case 0:
            {
                [self showSVProgressHUDSuccessWithStatus:@"密码修改成功!"];
                [NSThread sleepForTimeInterval:1];
                if (self.successBlock) {
                    self.successBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 1:
            {
                [self showSVProgressHUDErrorWithStatus:@"修改失败!"];
                
            }
                break;
            case 8:
            {
                [self showSVProgressHUDErrorWithStatus:@"原密码错误!"];
            }
                break;
            default:
                [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
                break;
        }
    }];
}

/**
 修改二级密码
 */
- (void)requestResetSecondaryPassword{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";
    NSDictionary *dic = @{
                          @"sid":sid,
                          @"newpwd":_resetLoginPasswodView.textfNew.text,
                          @"oldpwd":_resetLoginPasswodView.textfOriginal.text
                          };
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/editbacktwo"];
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
                [self showSVProgressHUDSuccessWithStatus:@"密码修改成功!"];
                [NSThread sleepForTimeInterval:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case 1:
            {
                [self showSVProgressHUDErrorWithStatus:@"修改失败!"];
                
            }
                break;
            case 501:
            {
                [self showSVProgressHUDErrorWithStatus:@"原密码错误!"];
            }
                break;
            case 502:
            {
                [self showSVProgressHUDErrorWithStatus:@"用户不存在!"];
            }
                break;
            case 503:
            {
                [self showSVProgressHUDErrorWithStatus:@"会话id为空!"];
            }
                break;
                
            default:
                [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
                break;
        }
    }];
}

- (ResetLoginPasswodView *)resetLoginPasswodView{
    if (!_resetLoginPasswodView) {
        _resetLoginPasswodView = [[ResetLoginPasswodView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - IPHONEX_SAFE_AREA_TOP_HEIGHT_122)];
    }
    WEAKSELF;
    _resetLoginPasswodView.sureBlock = ^{
        if ([weakSelf.ntitle isEqualToString:@"二级密码修改"]) {
            //修改二级密码
            [weakSelf requestResetSecondaryPassword];
        } else {
            //修改登陆密码
            [weakSelf requestResetLogin];

        }
    };
    return _resetLoginPasswodView;
}

@end
