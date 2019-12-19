//
//  MyDeleteUserResultViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyDeleteUserResultViewController.h"
#import "MyDeleteAccountView.h"
#import "MyDeletAcountModel.h"
#import "MyDeleteUserNoticeViewController.h"
@interface MyDeleteUserResultViewController ()
@property (nonatomic,strong)MyDeleteAccountView *mainView;
@end

@implementation MyDeleteUserResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户注销";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.mainView];
    NSMutableArray *data = [NSMutableArray array];
    MyDeletAcountModel *model = [[MyDeletAcountModel alloc] init];
    model.imageStr = @"my_warning";
    model.title = @"抱歉，无法注销";
    model.subtitle = @"由于以下原因，导致账号无法注销";
    model.contentMode = 1;
    model.rowHeight = 208;
    MyDeletAcountModel *model1 = [[MyDeletAcountModel alloc] init];
    model1.title = @"账号处于非安全状态";
    model1.subtitle = @"最近两周内，进行过改密等敏感操作，你的账户存在被 盗风险";
    model1.contentMode = 5;
    model1.rowHeight = 95;
    
    MyDeletAcountModel *model2 = [[MyDeletAcountModel alloc] init];
    model2.title = @"一个月（30天）有交易记录";
    model2.contentMode = 2;
    model2.rowHeight = 45;
    
    MyDeletAcountModel *model3 = [[MyDeletAcountModel alloc] init];
    model3.title = @"你的账户余额不为0";
    model3.contentMode = 2;
    model3.rowHeight = 45;
    MyDeletAcountModel *model5 = [[MyDeletAcountModel alloc] init];
    model5.title = @"你的有经营中的店铺";
    model5.contentMode = 2;
    model5.rowHeight = 45;
    MyDeletAcountModel *model4 = [[MyDeletAcountModel alloc] init];
    model4.title = @"如有疑问请联络我们的平台工作人员\n联系电话：400-601-0908";
    model4.contentMode = 6;
    model4.rowHeight = 60;
    [data addObject:model];
    if (self.hasPwdChange) {
       
        [data addObject:model1];
    }
    if (self.hasTransaction) {

        [data addObject:model2];
    }
    if (self.hasShop) {
        
        [data addObject:model5];
    }
    if (self.hasAsset) {
        [data addObject:model3];
    }
    [data addObject:model4];
    self.mainView.dataSource = [data copy];
    [self.mainView.btn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.mainView.btn bringSubviewToFront:self.mainView.btn.titleLabel];
    [self.mainView.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.mainView.btn.hidden = YES;
}
- (void)btnClick {
    [self.navigationController pushViewController:[MyDeleteUserNoticeViewController new] animated:YES];
}
- (MyDeleteAccountView *)mainView {
    if (!_mainView) {
        _mainView = [[MyDeleteAccountView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-KTopHeight)];
    }
    return _mainView;
}
- (NSArray*)dataSource {
    MyDeletAcountModel *model = [[MyDeletAcountModel alloc] init];
    model.imageStr = @"my_warning";
    model.title = @"抱歉，无法注销";
    model.subtitle = @"由于以下原因，导致账号无法注销";
    model.contentMode = 1;
    model.rowHeight = 208;

    MyDeletAcountModel *model4 = [[MyDeletAcountModel alloc] init];
    model4.title = @"如有疑问请联络我们的平台工作人员\n联系电话：400-601-0908";
    model4.contentMode = 6;
    model4.rowHeight = 60;

    
    return @[model,model4];
}
@end
