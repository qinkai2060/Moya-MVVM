
//
//  WARFriendMessageViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/8.
//

#import "WARFriendMessageViewController.h"
#import "WARNavgationCutsomBar.h"

#import "WARBaseMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"

@interface WARFriendMessageViewController ()

@property (nonatomic,strong) WARNavgationCutsomBar *customBar;

@end

@implementation WARFriendMessageViewController

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)initSubviews {
    [super initSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
}

- (void)initNavigationBar {
    [self.view addSubview:self.customBar];
}

#pragma mark - Event Response

- (void)leftAtction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

#pragma mark - Private
 
#pragma mark - Setter And Getter

- (WARNavgationCutsomBar *)customBar{
    if (!_customBar) {
        WS(weakself);
        _customBar = [[WARNavgationCutsomBar alloc] initWithTile:@"新消息" rightTitle:@"" alpha:0 backgroundColor:[UIColor whiteColor] rightHandler:^{ 
        } leftHandler:^{
            [weakself leftAtction];
        }];
        [_customBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat height = WAR_IS_IPHONE_X ? 88:64;
        _customBar.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _customBar;
}
@end
