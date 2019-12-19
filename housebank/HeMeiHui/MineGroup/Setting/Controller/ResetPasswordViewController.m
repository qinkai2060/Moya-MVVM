//
//  ResetPasswordViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "AboutUsTableViewCell.h"
#import "ResetLoginPasswodViewController.h"
#import "ResetSecondaryPasswordViewController.h"

@interface ResetPasswordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrDateSoure;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setUI];
    
    [self requestCheckHadSecPwd];
}
- (void)requestCheckHadSecPwd{
    [SVProgressHUD show];
    NSString *sid = USERDEFAULT(@"sid")?:@"";;
    NSDictionary *dic = @{
                          @"sid":sid
                          };
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"user./user/checkHadSecPwd"];
    [HFCarRequest requsetUrl:utrl withRequstType:YTKRequestMethodPOST requestSerializerType:YTKRequestSerializerTypeHTTP params:dic success:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseObject);
        [SVProgressHUD dismiss];
        
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",request.responseString);
        if (CHECK_STRING_ISNULL(request.responseString) || !request.responseString.length) {
            [self showSVProgressHUDErrorWithStatus:@"网络请求失败!"];
            return ;
        }
        NSInteger response = [request.responseString integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:response] forKey:@"secPwd"];
        switch (response) {
            case 1:
            {
                //已设置
                [self setedSecondaryPassWord:YES];
            }
                break;
            case 2:
            {
                //未设置
               
                [self setedSecondaryPassWord:NO];

            }
                break;
            case 3:
            {
                //已验证
                [self setedSecondaryPassWord:YES];

            }
                break;
                
                
            default:
                [self setedSecondaryPassWord:NO];
                break;
        }
    }];
}

- (void)setedSecondaryPassWord:(BOOL)isSeted{
    if (isSeted) {
        self.arrDateSoure =
        @[@{
              @"title":@"登录密码修改",
              @"class":@"ResetLoginPasswodViewController"
              },
          @{
              @"title":@"二级密码修改",
              @"class":@"ResetLoginPasswodViewController"
              },
          @{
              @"title":@"二级密码重置",
              @"class":@"ResetSecondaryPasswordViewController"
              }];
    } else {
        self.arrDateSoure =
        @[@{
              @"title":@"登录密码修改",
              @"class":@"ResetLoginPasswodViewController"
              },
          @{
              @"title":@"二级密码设置",
              @"class":@"ResetSecondaryPasswordViewController"
              }];
    }
   
    [self.tableView reloadData];
}
- (void)setUI{
    self.title = @"修改密码";

    [self.view addSubview:self.tableView];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }
    return _tableView;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDateSoure.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsTableViewCell"];
    if (!cell) {
        cell = [[AboutUsTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:[NSString stringWithFormat:@"AboutUsTableViewCell"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [_arrDateSoure[indexPath.row] objectForKey:@"title"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class class = NSClassFromString([_arrDateSoure[indexPath.row] objectForKey:@"class"]);
    UIViewController *vc = [[class alloc] init];
    
    NSDictionary *parameter = @{@"ntitle": [_arrDateSoure[indexPath.row] objectForKey:@"title"]};
    [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
        if ([vc respondsToSelector:NSSelectorFromString(key)]) {
            [vc setValue:obj forKey:key];
        }
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
    

}


@end
