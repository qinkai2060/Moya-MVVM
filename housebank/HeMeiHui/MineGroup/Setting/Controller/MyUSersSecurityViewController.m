//
//  MyUSersSecurityViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "MyUSersSecurityViewController.h"
#import "ResetPasswordViewController.h"
#import "MyAcountSecurityCell.h"
#import "MyDeleteAccountViewController.h"
@interface MyUSersSecurityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataSource;

@end

@implementation MyUSersSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户与安全";
    self.dataSource = 
                             @[@{
                                    @"title":@"修改密码",
                                    @"logo":@"icon_qrcode",
                                    @"class":@"ResetPasswordViewController"
                                    },
                                
                                @{
                                    @"title":@"注销",
                                    @"logo":@"icon_topcontacts",
                                    @"class":@"TopContactsViewController"
                                    },
                 
                             ];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableView];
}
#pragma mark - tableViewDelegate-----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr =self.dataSource;
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAcountSecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAcountSecurityCell"];
    if (!cell) {
        cell = [[MyAcountSecurityCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"MyAcountSecurityCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.dataSource[indexPath.row]];
    cell.titleL.text = [dic objectForKey:@"title"];
 
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataSource;
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:arr[indexPath.row]];
    if ([[dic valueForKey:@"title"] isEqualToString:@"修改密码"]) {
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        MyDeleteAccountViewController *vc = [[MyDeleteAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - KTopHeight) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}


@end
