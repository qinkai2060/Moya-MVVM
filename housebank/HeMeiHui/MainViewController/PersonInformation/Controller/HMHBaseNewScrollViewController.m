//
//  HMHBaseNewScrollViewController.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMHBaseNewScrollViewController.h"


@interface HMHBaseNewScrollViewController()







@end

@implementation HMHBaseNewScrollViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setSubView {
   // [super setSubView];
    
    //创建滚动View
    [self createScrollView];
    
}



- (void)createScrollView {
    
    UIScrollView *scrollView = [UIScrollView new];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    self.contentView = contentView;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nvView.mas_bottom).mas_offset(1);
    //make.top.mas_equalTo(self.nvView.mas_bottom);
    make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView.height + 1);
    }];
    
    [self.view layoutIfNeeded];
}

@end
