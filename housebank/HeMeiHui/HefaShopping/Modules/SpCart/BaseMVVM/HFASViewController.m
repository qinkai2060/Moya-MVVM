//
//  HFASViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFASViewController.h"

@implementation HFASViewController
- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    if (self = [super init]) {
        @weakify(self)
        
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            
            @strongify(self)
            [self hh_addSubviews];
            [self hh_bindViewModel];
        }];
        //xxx
        [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
          
            @strongify(self)
            [self hh_layoutNavigation];
            [self hh_getNewData];
        }];
    }
    return self;
}
/**
 *  添加控件
 */
- (void)hh_addSubviews {}

/**
 *  绑定
 */
- (void)hh_bindViewModel {}

/**
 *  设置navation
 */
- (void)hh_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)hh_getNewData {}

@end
