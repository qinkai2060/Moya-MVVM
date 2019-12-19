//
//  MyDeleteUserNoticeViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteUserNoticeViewController.h"
#import "MyDeleteAccountView.h"
#import "MyDeletAcountModel.h"
#import "MyDeleteUserResultViewController.h"
#import "HFAlertView.h"
@interface MyDeleteUserNoticeViewController ()
@property (nonatomic,strong)MyDeleteAccountView *mainView;
@end

@implementation MyDeleteUserNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户注销须知";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.mainView];
    self.mainView.dataSource = [self dataSource];
    [self.mainView.btn setTitle:@"继续申请" forState:UIControlStateNormal];
    [self.mainView.btn bringSubviewToFront:self.mainView.btn.titleLabel];
    [self.mainView.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)btnClick {
//    MyDeleteUserResultViewController *VC =    [MyDeleteUserResultViewController new];
//    VC.hasPwdChange = YES;
//    VC.hasShop = NO;
//    VC.hasAsset = NO;
//    VC.hasTransaction = NO;
// [self.navigationController pushViewController:VC animated:YES];
//    return;
    NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/account/cancellation"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:@{@"sid":[HFCarShoppingRequest sid]} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([[request.responseObject valueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict =  [request.responseObject valueForKey:@"data"];
            if ([[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"result"]] boolValue] ==YES) {
                [HFAlertView showAlertViewType:0 title:@"你的合美惠账户已注销成功" detailString:@"" cancelTitle:@"" vipBlock:^(HFAlertView *view) {
                    
                } sureTitle:@"我知道了" sureBlock:^(HFAlertView *view) {
                    // 回去
                    [HFUserDataTools logout];
                    [self.navigationController.tabBarController setSelectedIndex:0];
                    [self.navigationController.tabBarController.delegate tabBarController:self.navigationController.tabBarController shouldSelectViewController:self.navigationController.tabBarController.viewControllers[3]];
                    [self.navigationController popToRootViewControllerAnimated:NO];

                    
                }];
            }else {
                    MyDeleteUserResultViewController *VC =    [MyDeleteUserResultViewController new];
                    VC.hasPwdChange = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"hasPwdChange"]] boolValue];
                    VC.hasShop = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"hasShop"]] boolValue];
                    VC.hasAsset = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"hasAsset"]] boolValue];
                    VC.hasTransaction = [[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"hasTransaction"]] boolValue];
                 [self.navigationController pushViewController:VC animated:YES];
  
            }
        }else {
            [SVProgressHUD showErrorWithStatus:[request.responseObject valueForKey:@"msg"]];
            [SVProgressHUD dismissWithDelay:0.25];
        }

    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD showErrorWithStatus:@"服务器数据异常"];
        [SVProgressHUD dismissWithDelay:0.25];

    }];
    
}

- (MyDeleteAccountView *)mainView {
    if (!_mainView) {
        CGFloat h = IS_IPHONE_X()?20:0;
        _mainView = [[MyDeleteAccountView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight-h)];
    }
    return _mainView;
}
- (NSArray*)dataSource {
    MyDeletAcountModel *model = [[MyDeletAcountModel alloc] init];
    model.title = @"合美惠账户注销须知";
    model.subtitle = @"1.如果您仍坚持注销账户，您的账户需同时满足以下条\n件:\n1.账户进行过实名认证并且在两周内，您没有 进行改\n密、改绑等敏感操作，您的账户没有被盗风险。\n2.账户内无余额，没有资金问题待结算\n3.您在合美惠的订单全部处于完结状态，没有未完结的\n订单和服务，且一个月（30天）无交易记录\n4.账户无任何纠纷，包括但不限于投诉、举报、诉讼\n、仲裁、国家有权机关调查等；\n在您满足上述条件前，合美惠暂时无法注销您的账\n户。\n2.合美惠账户一旦被注销将不可恢复\n您注销合美 惠账户的行为并不代表您在合美惠账户注销前的账户行为和相关责任得到豁免或减轻。您仍应\n对注销前账户 行为承担全部的法律责任。";
    model.contentMode = 4;
    model.rowHeight = self.mainView.height-50;
    
    return @[model];
}
@end

