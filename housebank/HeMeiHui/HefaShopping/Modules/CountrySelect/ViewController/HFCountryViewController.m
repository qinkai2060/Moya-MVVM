//
//  HFCountryViewController.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCountryViewController.h"
#import "HFCountryView.h"
#import "HFLoginViewModel.h"
#import "HFCountryCodeModel.h"
@interface HFCountryViewController ()
@property(nonatomic,strong)HFLoginViewModel *viewModel;
@property(nonatomic,strong)HFCountryView *contryView;
@end

@implementation HFCountryViewController

- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    self.viewModel = (HFLoginViewModel*)viewModel;
    if (self = [super initWithViewModel:viewModel]) {
        
    }
    return self;
}
- (void)hh_addSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contryView];
    NSArray *tempArray = [[HFCountryCodeModel jsonSerialization] valueForKey:@"indexKey"];
    
    NSLog(@"");
}
- (void)hh_bindViewModel {
    @weakify(self)
    [self.viewModel.countryCodeCloseSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.viewModel.didSelectCountryCodeSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (HFCountryView *)contryView {
    if (!_contryView) {
        CGFloat navh = IS_iPhoneX ? 24:0;
        _contryView = [[HFCountryView alloc] initWithFrame:CGRectMake(0, navh, ScreenW, ScreenH) WithViewModel:self.viewModel];
        _contryView.backgroundColor = [UIColor whiteColor];
    }
    return _contryView;
}

@end
