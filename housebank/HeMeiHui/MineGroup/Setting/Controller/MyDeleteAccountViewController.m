//
//  MyDeleteAccountViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteAccountViewController.h"
#import "MyDeleteAccountView.h"
#import "MyDeletAcountModel.h"
#import "MyDeleteUserNoticeViewController.h"
@interface MyDeleteAccountViewController ()
@property (nonatomic,strong)MyDeleteAccountView *mainView;
@end

@implementation MyDeleteAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户注销";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.mainView];
    self.mainView.dataSource = [self dataSource];
    [self.mainView.btn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.mainView.btn bringSubviewToFront:self.mainView.btn.titleLabel];
    [self.mainView.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)btnClick {
    [self.navigationController pushViewController:[MyDeleteUserNoticeViewController new] animated:YES];
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
    model.imageStr = @"my_warning";
    model.title = @"账户注销后，将放弃以下资产和权益";
    model.contentMode = 1;
    model.rowHeight = 180;
    
    MyDeletAcountModel *model1 = [[MyDeletAcountModel alloc] init];
    model1.title = @"1.身份、账户信息、会员权益将清空且无法";
    model1.contentMode = 2;
    model1.rowHeight = 45;
    
    MyDeletAcountModel *model2 = [[MyDeletAcountModel alloc] init];
    model2.title = @"2.交易记录将被清空";
    model2.contentMode = 2;
    model2.rowHeight = 45;
    
    MyDeletAcountModel *model3 = [[MyDeletAcountModel alloc] init];
    model3.title = @"请确保所有交易已完结且无纠纷\n账户注销后，已完成的交易将无法处理售后";
    model3.contentMode = 3;
    model3.rowHeight = 60;
    
    MyDeletAcountModel *model4 = [[MyDeletAcountModel alloc] init];
    model4.title = @"3.您账户中的抵扣券、注册券、优惠券等将被视作放弃";
    model4.contentMode = 2;
    model4.rowHeight = 45;
    
    MyDeletAcountModel *model5 = [[MyDeletAcountModel alloc] init];
    model5.title = @"4.注销后一年此号码不能再次注册合美惠账号";
    model5.contentMode = 2;
    model5.rowHeight = 45;
    
    return @[model,model1,model2,model3,model4,model5];
}
@end
