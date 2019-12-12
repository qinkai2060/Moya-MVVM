//
//  WARThemeSettingViewController.m
//  WARProfile
//
//  Created by helaf on 2018/3/7.
//

#import "WARThemeSettingViewController.h"
#import "UIImage+Color.h"
#import "UIColor+WARCategory.h"
#import "Masonry.h"
#import "WARThemeManager.h"
#import "WARMacros.h"
#import "WARConfigurationTemplateMale.h"
#import "WARConfigurationTemplateDefualt.h"
#import "WARCommonUI.h"

@interface WARThemeSettingViewController ()
{
    UIButton* _normalBtn;
    UIButton* _darkBtn;
}
@end

@implementation WARThemeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置主题";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initSubviews{
    
    [super initSubviews];
    
    _normalBtn = [self createBtnWithImageColor:@"00d8b7" tag:10001 title:@"默认主题"];
    [self.view addSubview:_normalBtn];
    
    _darkBtn = [self createBtnWithImageColor:@"999999" tag:10002 title:@"夜间模式"];
    [self.view addSubview:_darkBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    _normalBtn.frame = CGRectMake(20, kStatusBarAndNavigationBarHeight + 10, kScreenWidth - 40, 60);
    _darkBtn.frame = CGRectMake(20, CGRectGetMaxY(_normalBtn.frame) + 20, kScreenWidth - 40, 60);
}


- (UIButton*)createBtnWithImageColor:(NSString *)imgColor tag:(NSInteger)tag title:(NSString *)title{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    UIImage* img = [UIImage imageWithColor:[UIColor colorWithHexString:imgColor]];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [button setBackgroundImage:img forState:UIControlStateSelected];
    button.layer.cornerRadius = 3.0f;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(changeTheme:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)changeTheme:(UIButton *)sender{
    switch (sender.tag) {
        case 10001:
            [WARThemeManager sharedInstance].currentTheme = [[WARConfigurationTemplateDefualt alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass([[WARConfigurationTemplateDefualt alloc] init].class) forKey:WARSelectedThemeClassName];
            break;
        case 10002:
            [WARThemeManager sharedInstance].currentTheme = [[WARConfigurationTemplateMale alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass([[WARConfigurationTemplateMale alloc] init].class) forKey:WARSelectedThemeClassName];
            break;
        default:
            break;
    }
}

@end











