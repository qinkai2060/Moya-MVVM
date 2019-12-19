//
//  HMHBaseNewViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMHBaseNewViewController.h"

@interface HMHBaseNewViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)UILabel *titleLabel;


@end

@implementation HMHBaseNewViewController {
    
    UILabel *_titleLabel;
    UIView *_nvView;
}

@synthesize nvView = _nvView;

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [UILabel wd_labelWithText:@"个人信息" font:WScale(17) textColor:[UIColor colorWithHexString:@"#333333"]];
    }
    return _titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self hiddenNvView];
    [self createNvView];
    [self setSubView];
    
    [self initNotification];
    [self removeNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNotification];
}

- (void)setSubView {
    
    //创建导航
    
}

- (void)initNotification {
   
}

- (void)removeNotification {
    
    
}

- (void)initData {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (void)createNvView {
    
    UIView *nvView = [UIView new];
    nvView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nvView];
    _nvView = nvView;
    nvView.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUSBAR_NAVBAR_HEIGHT);
    UIButton *backBtn = [UIButton buttonWithType:0];
    [nvView addSubview:backBtn];
    [backBtn setImage:ImageLive(@"back_light") forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, STATUSBAR_HEIGHT, 40, NAVBAR_HEIGHT);
    [backBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [nvView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(nvView);
        make.bottom.mas_equalTo(nvView.mas_bottom).mas_offset(-6);
    }];
    
}

- (void)setNvTitle:(NSString *)nvTitle {
    _nvTitle = nvTitle;
    self.titleLabel.text = nvTitle;
}

- (void)actionBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenNvView {
    self.navigationController.navigationBar.hidden = YES;
}


@end
