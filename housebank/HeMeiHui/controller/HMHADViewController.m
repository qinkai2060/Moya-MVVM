//
//  ADViewController.m
//  HeMeiHui
//
//  Created by 任为 on 2016/10/28.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "HMHADViewController.h"

@interface HMHADViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *HMH_adWebView;
@property (nonatomic, strong) UIProgressView *HMH_progressView;
@property (nonatomic, assign) NSUInteger HMH_loadCount;
@end

@implementation HMHADViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = NO;

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL         = navigationAction.request.URL;
    NSString *scheme   = [URL scheme];
    NSString * urlStr  =[NSString stringWithFormat:@"%@",URL];
    if ([urlStr containsString:@"https://itunes.apple.com/cn/app/he-fa-fang-yin/id1447851000"]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1447851000"]];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:self.HMH_color?:@"#ffb100"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    self.HMH_adWebView = [[WKWebView alloc]init];
    self.HMH_adWebView.UIDelegate = self;
    self.HMH_adWebView.navigationDelegate = self;
    [self.view addSubview:self.HMH_adWebView];
    [self.HMH_adWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    //标题栏
    CGRect NavRect = self.navigationController.navigationBar.frame;
        self.HMH_progressView = [[UIProgressView alloc]init];
        [self.HMH_adWebView addSubview:self.HMH_progressView];
        [self.HMH_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.top.equalTo(self.view.mas_top).offset(64);
            make.height.equalTo(@2);
        }];
     [_HMH_adWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.HMH_progressView.tintColor = [UIColor redColor];
    _HMH_adWebView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
       NSString *url=[self.HMH_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.HMH_adWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.title =self.title?:@"合发";
      self.view.backgroundColor = [UIColor lightGrayColor];
}
- (void)backButtonClick:(UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)observeValueForKeyPath:(NSString* )keyPath ofObject:(id)object change:(NSDictionary* )change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    }else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.HMH_progressView.progress = self.HMH_adWebView.estimatedProgress;
    }
    
    if (object == self.HMH_adWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.HMH_progressView.hidden = YES;
            [self.HMH_progressView setProgress:0 animated:NO];
        }else {
            self.HMH_progressView.hidden = NO;
            [self.HMH_progressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)setHMH_LoadCount:(NSUInteger)HMH_loadCount {
    _HMH_loadCount = HMH_loadCount;
    
    if (HMH_loadCount == 0) {
        self.HMH_progressView.hidden = YES;
        [self.HMH_progressView setProgress:0 animated:NO];
    }else {
        self.HMH_progressView.hidden = NO;
        CGFloat oldP = self.HMH_progressView.progress;
        CGFloat newP = (1.0 - oldP) / (HMH_loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.HMH_progressView setProgress:newP animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_HMH_adWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
