//
//  AboutUsViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsView.h"
#import "SuggestionBoxViewController.h"
#import "ContactUsViewController.h"
#import "AboutHFViewController.h"
@interface AboutUsViewController ()
@property (nonatomic, strong) AboutUsView *aboutUs;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.title = @"关于我们";
    [self.view addSubview:self.aboutUs];
}
- (AboutUsView *)aboutUs{
    if (!_aboutUs) {
        _aboutUs = [[AboutUsView alloc] init];
        _aboutUs.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        _aboutUs.arrDateSoure = [@[@"关于合发",@"意见箱",@"董事长邮箱",@"联系我们"] mutableCopy];
        __weak typeof (self) weakself = self;
        _aboutUs.clickBlock = ^(AboutUsViewType type) {
            switch (type) {
                case AboutUsViewtTypeAboutHF:
                    [weakself pushHF];
                    break;
                case AboutUsViewtTypeIdea:
                    [weakself pushIdeaVC];
                    break;
                case AboutUsViewtTypeBossEmail:
                    [weakself sendBossEmail];
                    break;
                case AboutUsViewtTypeCallUs:
                    [weakself pushContactUs];
                    break;
                    
                default:
                    break;
            }
        } ;
    }
    return _aboutUs;
}

/**
 意见箱
 */
- (void)pushIdeaVC{
    SuggestionBoxViewController *vc = [[SuggestionBoxViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHF{
    AboutHFViewController *hf = [[AboutHFViewController alloc] init];
    [self.navigationController pushViewController:hf animated:YES];
}

/**
 联系我们
 */
- (void)pushContactUs{
    ContactUsViewController *us = [[ContactUsViewController alloc] init];
    [self.navigationController pushViewController:us animated:YES];
}
- (void)sendBossEmail{
    //创建可变的地址字符串对象：
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //添加收件人：
    NSArray *toRecipients = @[@"dsz@hfhomes.cn"];
    // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
}
@end
